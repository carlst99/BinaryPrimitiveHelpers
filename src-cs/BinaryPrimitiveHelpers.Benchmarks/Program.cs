using System.Reflection;
using BenchmarkDotNet.Running;

namespace BinaryPrimitiveHelpers.Benchmarks;

public static class Program
{
    public static void Main(string[] args)
    {
        BenchmarkRunner.Run(Assembly.GetExecutingAssembly(), args: args);
    }
}
