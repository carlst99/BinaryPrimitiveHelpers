using Microsoft.CodeAnalysis;
using Microsoft.CodeAnalysis.Text;
using System.Collections.Immutable;
using System.Text;

namespace BinaryPrimitiveHelpers.SourceGeneration;

[Generator]
public class BinaryReaderGenerator : IIncrementalGenerator
{
    public readonly record struct TypeToExtend
    {
        public readonly string Namespace;
        public readonly string Name;

        public TypeToExtend(string @namespace, string name)
        {
            Namespace = @namespace;
            Name = name;
        }
    }

    public void Initialize(IncrementalGeneratorInitializationContext context)
    {
        RegisterMarkerAttribute(context);

        IncrementalValuesProvider<TypeToExtend?> typesToExtend = context.SyntaxProvider
            .ForAttributeWithMetadataName
            (
                "BinaryPrimitiveHelpers.SourceGeneration.ExtendWithBinaryPrimitiveShims",
                predicate: static (_, _) => true,
                transform: static (ctx, _) => GetTypeToExtend(ctx.SemanticModel, ctx.TargetNode)
            )
            .Where(static m => m is not null);

        // Combine the selected types with the `Compilation`
        IncrementalValueProvider<(Compilation, ImmutableArray<TypeToExtend?>)> compilationAndTypes
            = context.CompilationProvider.Combine(typesToExtend.Collect());

        context.RegisterSourceOutput
        (
            compilationAndTypes,
            static (spc, source) => Execute(source.Item1, source.Item2, spc)
        );
    }

    private static TypeToExtend? GetTypeToExtend(SemanticModel semanticModel, SyntaxNode enumDeclarationSyntax)
    {
        if (semanticModel.GetDeclaredSymbol(enumDeclarationSyntax) is not INamedTypeSymbol typeSymbol)
            return null;

        string fullName = typeSymbol.ToString();
        int index = fullName.LastIndexOf('.');

        return new TypeToExtend
        (
            fullName.Substring(0, index),
            fullName.Substring(index + 1)
        );
    }

    private static void Execute
    (
        Compilation compilation,
        ImmutableArray<TypeToExtend?> typesToExtend,
        SourceProductionContext context
    )
    {
        INamedTypeSymbol? binPrimsClass = compilation.GetTypeByMetadataName("System.Buffers.Binary.BinaryPrimitives");
        if (binPrimsClass is null)
            return;

        StringBuilder proxiedReadMethods = new();
        StringBuilder proxiedWriteMethods = new();
        foreach (ISymbol method in binPrimsClass.GetMembers())
        {
            if (method.Kind is not SymbolKind.Method)
                continue;
            if (method.DeclaredAccessibility is not Accessibility.Public)
                continue;

            if (method.Name.Contains("Read"))
                EmitMemberProxy(method, proxiedReadMethods);
            else if (method.Name.Contains("Write"))
                EmitMemberProxy(method, proxiedWriteMethods);
        }

        foreach (TypeToExtend? typeToExtend in typesToExtend)
        {
            if (typeToExtend is not { } value)
                continue;

            StringBuilder proxiedTypesToUse = value.Name.Contains("Read")
                ? proxiedReadMethods
                : proxiedWriteMethods;

            string result =
                $$"""
                #nullable enable
                
                using System.Buffers.Binary;
                
                namespace {{value.Namespace}};
                
                partial struct {{value.Name}}
                {
                {{proxiedTypesToUse}}
                }
                """;

            // Create a separate partial class file for each enum
            context.AddSource($"{value.Namespace}.{value.Name}.g.cs", SourceText.From(result, Encoding.UTF8));
        }
    }

    private static void EmitMemberProxy(ISymbol member, StringBuilder output)
    {
        IMethodSymbol method = (IMethodSymbol)member;

        string myMethodName = method.Name.Replace("BigEndian", "BE")
            .Replace("LittleEndian", "LE");

        output.Append("    ")
            .Append(method.DeclaredAccessibility.ToString().ToLower())
            .Append(" unsafe ")
            .Append(method.ReturnType)
            .Append(' ')
            .Append(myMethodName)
            .Append('(');

        if (method.Name.StartsWith("TryRead"))
            output.Append("out ").Append(method.Parameters[1].Type).Append(" value");
        else if (method.Name.Contains("Write"))
            output.Append(method.Parameters[1].Type).Append(" value");

        output.AppendLine(")")
            .AppendLine("    {");

        if (method.Name.StartsWith("Read"))
        {
            output.Append("        ").Append(method.ReturnType).Append(" value = BinaryPrimitives.").Append(method.Name).AppendLine("(Buffer[Offset..]);")
                .Append("        Offset += sizeof(").Append(method.ReturnType).AppendLine(");")
                .AppendLine("        return value;");
        }
        else if (method.Name.StartsWith("TryRead"))
        {
            output.Append("        ").Append(method.ReturnType).Append(" result = BinaryPrimitives.").Append(method.Name).AppendLine("(Buffer[Offset..], out value);")
                .AppendLine("        if (result)")
                .Append("            Offset += sizeof(").Append(method.Parameters[1].Type).AppendLine(");")
                .AppendLine("        return result;");
        }
        else if (method.Name.StartsWith("Write"))
        {
            output.Append("        BinaryPrimitives.").Append(method.Name).AppendLine("(Buffer[Offset..], value);")
                .Append("        Offset += sizeof(").Append(method.Parameters[1].Type).AppendLine(");");
        }
        else if (method.Name.StartsWith("TryWrite"))
        {
            output.Append("        ").Append(method.ReturnType).Append(" result = BinaryPrimitives.").Append(method.Name).AppendLine("(Buffer[Offset..], value);")
                .AppendLine("        if (result)")
                .Append("            Offset += sizeof(").Append(method.Parameters[1].Type).AppendLine(");")
                .AppendLine("        return result;");
        }

        output.AppendLine("    }");
    }


    private static void RegisterMarkerAttribute(IncrementalGeneratorInitializationContext context)
    {
        context.RegisterPostInitializationOutput
        (
            static postInitializationContext => postInitializationContext.AddSource
            (
                "ExtendWithBinaryPrimitiveShims.g.cs",
                SourceText.From
                (
                    """
                    using System;

                    namespace BinaryPrimitiveHelpers.SourceGeneration
                    {
                        [AttributeUsage(AttributeTargets.Struct)]
                        internal sealed class ExtendWithBinaryPrimitiveShims : Attribute
                        {
                        }
                    }
                    """,
                    Encoding.UTF8
                )
            )
        );
    }
}
