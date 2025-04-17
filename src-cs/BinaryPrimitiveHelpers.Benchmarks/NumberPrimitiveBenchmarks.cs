using System;
using System.Buffers.Binary;
using BenchmarkDotNet.Attributes;
using BinaryPrimitiveHelpers.Primitives;

namespace BinaryPrimitiveHelpers.Benchmarks;

public class NumberPrimitiveBenchmarks
{
    private readonly byte[] _sourceU24BE = [0x00, 0x00, 0x01];
    private readonly byte[] _sourceU32BE = [0x00, 0x00, 0x00, 0x01];

    [Benchmark]
    public uint BuiltinReadU32BE()
    {
        return BinaryPrimitives.ReadUInt32BigEndian(_sourceU32BE);
    }

    [Benchmark]
    public uint NumberPrimitivesReadNumber_U32BE()
    {
        return NumberPrimitives.ReadNumber<uint>(_sourceU32BE, Endian.Big);
    }

    [Benchmark]
    public uint PlainReadU24BE()
    {
        return ReadUInt24BE(_sourceU24BE);
    }

    [Benchmark]
    public uint NumberPrimitivesReadNumber_U24BE()
    {
        return NumberPrimitives.ReadNumber<uint>(_sourceU24BE, 3, Endian.Big);
    }

    private static uint ReadUInt24BE(ReadOnlySpan<byte> source)
    {
        uint value = 0;
        value |= (uint)source[0] << 16;
        value |= (uint)source[1] << 8;
        value |= source[2];
        return value;
    }
}
