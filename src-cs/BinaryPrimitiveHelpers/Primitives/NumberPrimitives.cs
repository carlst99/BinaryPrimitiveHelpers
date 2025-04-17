using System;
using System.Buffers.Binary;
using System.Numerics;
using System.Runtime.CompilerServices;
using System.Runtime.InteropServices;

namespace BinaryPrimitiveHelpers.Primitives;

public static class NumberPrimitives
{
    private static readonly Endian NativeEndian = BitConverter.IsLittleEndian ? Endian.Little : Endian.Big;

    /// <summary>
    /// Reads any <see cref="INumber{T}"/> from the <paramref name="source"/> buffer.
    /// </summary>
    /// <typeparam name="T">The type of number to read.</typeparam>
    /// <param name="source">The buffer in which the number is contained.</param>
    /// <param name="endian">The endianness of the number in its binary representation.</param>
    /// <returns>A number value.</returns>
    public static unsafe T ReadNumber<T>(ReadOnlySpan<byte> source, Endian endian)
        where T : struct, INumberBase<T>
    {
        T value = MemoryMarshal.Read<T>(source);
        if (endian != NativeEndian)
        {
            if (value is ushort or short or Half)
                value = Unsafe.BitCast<ushort, T>(BinaryPrimitives.ReverseEndianness(Unsafe.BitCast<T, ushort>(value)));
            else if (value is uint or int or float)
                value = Unsafe.BitCast<uint, T>(BinaryPrimitives.ReverseEndianness(Unsafe.BitCast<T, uint>(value)));
            else if (value is ulong or long or double)
                value = Unsafe.BitCast<ulong, T>(BinaryPrimitives.ReverseEndianness(Unsafe.BitCast<T, ulong>(value)));
            else
                MemoryMarshal.AsBytes(MemoryMarshal.CreateSpan(ref value, 1)).Reverse();
        }
        return value;
    }

    public static unsafe bool TryReadNumber<T>(ReadOnlySpan<byte> source, Endian endian, out T value)
        where T : struct, INumberBase<T>
    {
        value = default;

        if (sizeof(T) > source.Length)
            return false;

        value = ReadNumber<T>(source, endian);
        return true;
    }

    public static unsafe TContainer ReadNumber<TContainer>(ReadOnlySpan<byte> source, byte bytesToRead, Endian endian)
        where TContainer : struct, INumber<TContainer>, IShiftOperators<TContainer, int, TContainer>
    {
        // Check that the container type can hold the specified number of bytes to read
        if (bytesToRead > sizeof(TContainer))
        {
            throw new ArgumentOutOfRangeException
            (
                nameof(bytesToRead),
                bytesToRead,
                $"The type {typeof(TContainer).Name} is too small to receive the specified number of bytes"
            );
        }

        // Copy the given number of bytes into a well-sized array for reading the container type from
        // We copy into the opposite end of the array and then shift the number in order to support
        // signed integers (the shift operators respect the sign bit).

        Span<byte> container = stackalloc byte[sizeof(TContainer)];
        int start = endian is Endian.Big ? 0 : container.Length - bytesToRead;
        source[..bytesToRead].CopyTo(container[start..]);

        TContainer value = ReadNumber<TContainer>(container, endian);
        if (BitConverter.IsLittleEndian)
            value >>= (container.Length - bytesToRead) * 8;
        else
            value <<= (container.Length - bytesToRead) * 8;

        return value;
    }

    public static unsafe void WriteNumber<T>(Span<byte> target, in T value, Endian endian)
        where T : struct, INumber<T>
    {
        MemoryMarshal.Write(target, value);
        if (endian != NativeEndian)
            target[..sizeof(T)].Reverse();
    }
}
