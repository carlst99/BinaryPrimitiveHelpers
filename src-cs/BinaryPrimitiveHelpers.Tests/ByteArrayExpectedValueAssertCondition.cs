using System.Runtime.CompilerServices;
using System.Text;
using TUnit.Assertions.AssertConditions;
using TUnit.Assertions.AssertConditions.Interfaces;
using TUnit.Assertions.AssertionBuilders;

namespace BinaryPrimitiveHelpers.Tests;

public static class IValueSourceOfByteArrayExtensions
{
    public static InvokableValueAssertionBuilder<byte[]> IsEqualTo
    (
        this IValueSource<byte[]> valueSource,
        byte[] expected,
        [CallerArgumentExpression(nameof(expected))] string doNotPopulateThisValue1 = ""
    )
    {
        return valueSource.RegisterAssertion
        (
            assertCondition: new ByteArrayExpectedValueAssertCondition(expected),
            argumentExpressions: [doNotPopulateThisValue1]
        );
    }
}

public class ByteArrayExpectedValueAssertCondition : ExpectedValueAssertCondition<byte[], byte[]>
{
    public ByteArrayExpectedValueAssertCondition(byte[]? expected) : base(expected)
    {
    }

    protected override string GetExpectation()
    {
        if (ExpectedValue is null)
            return "to be equal to null";

        StringBuilder sb = new("to be equal to 0x[ ");
        foreach (byte value in ExpectedValue)
            sb.Append($"{value:x2} ");
        sb.Append(']');

        return sb.ToString();
    }

    protected override ValueTask<AssertionResult> GetResult(byte[]? actualValue, byte[]? expectedValue)
    {
        if (actualValue is null && expectedValue is not null)
            return AssertionResult.Fail("but it was null");
        if (actualValue is not null && expectedValue is null)
            return AssertionResult.Fail("but it was not null");

        if (actualValue is null && expectedValue is null)
            return AssertionResult.Passed;

        return actualValue!.SequenceEqual(expectedValue!)
            ? AssertionResult.Passed
            : AssertionResult.Fail("Byte arrays do not match");
    }
}
