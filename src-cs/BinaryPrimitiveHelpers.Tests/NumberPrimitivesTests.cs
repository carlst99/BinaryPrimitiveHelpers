using BinaryPrimitiveHelpers.Primitives;

namespace BinaryPrimitiveHelpers.Tests;

public class NumberPrimitivesTests
{
    [Test]
    public void TestReadNumber_ThrowsOnSmallBuffer()
    {
        byte[] data = [0xff];
        Assert.Throws<ArgumentOutOfRangeException>(() => NumberPrimitives.ReadNumber<ushort>(data, Endian.Big));
    }

    [Test]
    public async Task TestReadNumber_Integers()
    {
        // Unsigned
        byte[] data = [ 0x00, 0x01 ];
        await Assert.That(NumberPrimitives.ReadNumber<ushort>(data, Endian.Big)).IsEqualTo((ushort)1);
        Array.Reverse(data);
        await Assert.That(NumberPrimitives.ReadNumber<ushort>(data, Endian.Little)).IsEqualTo((ushort)1);

        // Signed
        data = [ 0xff, 0xfe ];
        await Assert.That(NumberPrimitives.ReadNumber<short>(data, Endian.Big)).IsEqualTo((short)-2);
        Array.Reverse(data);
        await Assert.That(NumberPrimitives.ReadNumber<short>(data, Endian.Little)).IsEqualTo((short)-2);
    }

    [Test]
    public async Task TestReadNumber_Floats()
    {
        byte[] data = [ 0x3c, 0x00 ];
        await Assert.That(NumberPrimitives.ReadNumber<Half>(data, Endian.Big)).IsEqualTo((Half)1);
        Array.Reverse(data);
        await Assert.That(NumberPrimitives.ReadNumber<Half>(data, Endian.Little)).IsEqualTo((Half)1);
    }

    [Test]
    public async Task TestReadNumber_WithByteLength()
    {
        // Unsigned
        byte[] data = [ 0x00, 0x00, 0x01 ];
        await Assert.That(NumberPrimitives.ReadNumber<uint>(data, 3, Endian.Big)).IsEqualTo((uint)1);
        Array.Reverse(data);
        await Assert.That(NumberPrimitives.ReadNumber<uint>(data, 3, Endian.Little)).IsEqualTo((uint)1);

        // Signed
        data = [ 0xff, 0xff, 0xfe ];
        await Assert.That(NumberPrimitives.ReadNumber<int>(data, 3, Endian.Big)).IsEqualTo(-2);
        Array.Reverse(data);
        await Assert.That(NumberPrimitives.ReadNumber<int>(data, 3, Endian.Little)).IsEqualTo(-2);

        Assert.Throws<ArgumentOutOfRangeException>(() => NumberPrimitives.ReadNumber<ushort>(data, 3, Endian.Big));

        data = [0xff];
        Assert.Throws<ArgumentOutOfRangeException>(() => NumberPrimitives.ReadNumber<ushort>(data, Endian.Big));
    }

    [Test]
    public async Task TestTryReadNumber_HandlesSmallBuffer()
    {
        byte[] data = [0xff];
        bool result = NumberPrimitives.TryReadNumber(data, Endian.Big, out ushort _);
        await Assert.That(result).IsFalse();
    }

    [Test]
    public async Task TestTryReadNumber_Integers()
    {
        // Unsigned
        byte[] data = [ 0x00, 0x01 ];
        bool result = NumberPrimitives.TryReadNumber(data, Endian.Big, out ushort uvalue);
        await Assert.That(result).IsTrue();
        await Assert.That(uvalue).IsEqualTo((ushort)1);
        Array.Reverse(data);
        result = NumberPrimitives.TryReadNumber(data, Endian.Little, out uvalue);
        await Assert.That(result).IsTrue();
        await Assert.That(uvalue).IsEqualTo((ushort)1);

        // Signed
        data = [ 0xff, 0xfe ];
        result = NumberPrimitives.TryReadNumber(data, Endian.Big, out short svalue);
        await Assert.That(result).IsTrue();
        await Assert.That(svalue).IsEqualTo((short)-2);
        Array.Reverse(data);
        result = NumberPrimitives.TryReadNumber(data, Endian.Little, out svalue);
        await Assert.That(result).IsTrue();
        await Assert.That(svalue).IsEqualTo((short)-2);
    }

    [Test]
    public async Task TestTryReadNumber_Floats()
    {
        byte[] data = [ 0x3c, 0x00 ];
        bool result = NumberPrimitives.TryReadNumber(data, Endian.Big, out Half value);
        await Assert.That(result).IsTrue();
        await Assert.That(value).IsEqualTo((Half)1);

        Array.Reverse(data);
        result = NumberPrimitives.TryReadNumber(data, Endian.Little, out value);
        await Assert.That(result).IsTrue();
        await Assert.That(value).IsEqualTo((Half)1);
    }

    [Test]
    public async Task TestTryReadNumber_WithByteLength()
    {
        // Unsigned
        byte[] data = [ 0x00, 0x00, 0x01 ];
        bool result = NumberPrimitives.TryReadNumber(data, 3, Endian.Big, out uint uvalue);
        await Assert.That(result).IsTrue();
        await Assert.That(uvalue).IsEqualTo((uint)1);
        Array.Reverse(data);
        result = NumberPrimitives.TryReadNumber(data, 3, Endian.Little, out uvalue);
        await Assert.That(result).IsTrue();
        await Assert.That(uvalue).IsEqualTo((uint)1);

        // Signed
        data = [ 0xff, 0xff, 0xfe ];
        result = NumberPrimitives.TryReadNumber(data, 3, Endian.Big, out int svalue);
        await Assert.That(result).IsTrue();
        await Assert.That(svalue).IsEqualTo(-2);
        Array.Reverse(data);
        result = NumberPrimitives.TryReadNumber(data, 3, Endian.Little, out svalue);
        await Assert.That(result).IsTrue();
        await Assert.That(svalue).IsEqualTo(-2);

        result = NumberPrimitives.TryReadNumber(data, 3, Endian.Big, out ushort _);
        await Assert.That(result).IsFalse();

        data = [0xff];
        result = NumberPrimitives.TryReadNumber(data, 3, Endian.Big, out ushort _);
        await Assert.That(result).IsFalse();
    }

    [Test]
    public void TestWriteNumber_ThrowsOnSmallBuffer()
    {
        byte[] data = new byte[1];
        Assert.Throws<ArgumentOutOfRangeException>(() => NumberPrimitives.WriteNumber(data, (ushort)1, Endian.Big));
    }

    [Test]
    public async Task TestWriteNumber_Integers()
    {
        byte[] expected = [ 0x00, 0x01 ];
        byte[] data = new byte[2];

        // Unsigned

        NumberPrimitives.WriteNumber(data, (ushort)1, Endian.Big);
        await Assert.That(data).IsEqualTo(expected);
        Array.Reverse(expected);
        NumberPrimitives.WriteNumber(data, (ushort)1, Endian.Little);
        await Assert.That(data).IsEqualTo(expected);

        // Signed

        expected = [ 0xff, 0xfe ];

        NumberPrimitives.WriteNumber(data, (short)-2, Endian.Big);
        await Assert.That(data).IsEqualTo(expected);
        Array.Reverse(expected);
        NumberPrimitives.WriteNumber(data, (short)-2, Endian.Little);
        await Assert.That(data).IsEqualTo(expected);
    }

    [Test]
    public async Task TestWriteNumber_Floats()
    {
        byte[] expected = [ 0x3c, 0x00 ];
        byte[] data = new byte[2];

        NumberPrimitives.WriteNumber(data, (Half)1, Endian.Big);
        await Assert.That(data).IsEqualTo(expected);
        Array.Reverse(expected);
        NumberPrimitives.WriteNumber(data, (Half)1, Endian.Little);
        await Assert.That(data).IsEqualTo(expected);
    }

    [Test]
    public async Task TestTryWriteNumber_HandlesSmallBuffer()
    {
        byte[] data = new byte[1];
        bool result = NumberPrimitives.TryWriteNumber(data, (ushort)1, Endian.Big);
        await Assert.That(result).IsFalse();
    }

    [Test]
    public async Task TestTryWriteNumber_Integers()
    {
        byte[] expected = [ 0x00, 0x01 ];
        byte[] data = new byte[2];

        // Unsigned

        await Assert.That(NumberPrimitives.TryWriteNumber(data, (ushort)1, Endian.Big)).IsTrue();
        await Assert.That(data).IsEqualTo(expected);
        Array.Reverse(expected);
        await Assert.That(NumberPrimitives.TryWriteNumber(data, (ushort)1, Endian.Little)).IsTrue();
        await Assert.That(data).IsEqualTo(expected);

        // Signed

        expected = [ 0xff, 0xfe ];

        await Assert.That(NumberPrimitives.TryWriteNumber(data, (short)-2, Endian.Big)).IsTrue();
        await Assert.That(data).IsEqualTo(expected);
        Array.Reverse(expected);
        await Assert.That(NumberPrimitives.TryWriteNumber(data, (short)-2, Endian.Little)).IsTrue();
        await Assert.That(data).IsEqualTo(expected);
    }

    [Test]
    public async Task TestTryWriteNumber_Floats()
    {
        byte[] expected = [ 0x3c, 0x00 ];
        byte[] data = new byte[2];

        await Assert.That(NumberPrimitives.TryWriteNumber(data, (Half)1, Endian.Big)).IsTrue();
        await Assert.That(data).IsEqualTo(expected);
        Array.Reverse(expected);
        await Assert.That(NumberPrimitives.TryWriteNumber(data, (Half)1, Endian.Little)).IsTrue();
        await Assert.That(data).IsEqualTo(expected);
    }
}
