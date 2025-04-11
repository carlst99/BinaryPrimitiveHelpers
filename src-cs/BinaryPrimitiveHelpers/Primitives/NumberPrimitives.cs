using System;
using System.Numerics;
using System.Runtime.InteropServices;

namespace BinaryPrimitiveHelpers.Primitives;

public static class NumberPrimitives
{
    public static T ReadNumber<T>(Span<byte> source, Endian endian)
        where T : struct, INumber<T>
    {
        T value = MemoryMarshal.Read<T>(source);
        if (BitConverter.IsLittleEndian && endian is Endian.Big)
            MemoryMarshal.AsBytes(MemoryMarshal.CreateSpan(ref value, 1)).Reverse();
        return value;
    }

    public static unsafe void WriteNumber<T>(Span<byte> target, in T value, Endian endian)
        where T : struct, INumber<T>
    {
        MemoryMarshal.Write(target, value);
        if (BitConverter.IsLittleEndian && endian is Endian.Big)
            target[..sizeof(T)].Reverse();
    }
}
