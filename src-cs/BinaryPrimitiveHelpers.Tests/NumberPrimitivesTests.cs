using BinaryPrimitiveHelpers.Primitives;

namespace BinaryPrimitiveHelpers.Tests;

public class NumberPrimitivesTests
{
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
}
