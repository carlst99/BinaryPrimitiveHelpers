using System;
using System.Buffers.Binary;
using System.Numerics;
using System.Runtime.InteropServices;

namespace BinaryPrimitiveHelpers.Primitives;

/// <summary>
/// Helper methods for reading and writing number primitives from binary buffers.
/// </summary>
public static class NumberPrimitives
{
    private static readonly Endian NativeEndian = BitConverter.IsLittleEndian ? Endian.Little : Endian.Big;

    /// <summary>
    /// Reads an <see cref="INumber{T}"/> from the <paramref name="source"/> buffer.
    /// </summary>
    /// <typeparam name="T">The type of number to read.</typeparam>
    /// <param name="source">The buffer in which the number is contained.</param>
    /// <param name="endian">The endianness of the number in its binary representation.</param>
    /// <returns>A number value.</returns>
    /// <remarks>
    /// This generic method is less performant than the dedicated methods on <see cref="BinaryPrimitives"/>.
    /// </remarks>
    public static T ReadNumber<T>(ReadOnlySpan<byte> source, Endian endian)
        where T : struct, INumber<T>
    {
        T value = MemoryMarshal.Read<T>(source);
        if (endian != NativeEndian)
            MemoryMarshal.AsBytes(MemoryMarshal.CreateSpan(ref value, 1)).Reverse();
        return value;
    }

    /// <summary>
    /// Tries to read an <see cref="INumber{T}"/> from the <paramref name="source"/> buffer.
    /// </summary>
    /// <typeparam name="T">The type of number to read.</typeparam>
    /// <param name="source">The buffer in which the number is contained.</param>
    /// <param name="endian">The endianness of the number in its binary representation.</param>
    /// <param name="value">The number value, if the read was successful.</param>
    /// <returns><c>True</c> if the value was successfully read, else <c>false</c>.</returns>
    /// <remarks>
    /// This generic method is less performant than the dedicated methods on <see cref="BinaryPrimitives"/>.
    /// </remarks>
    public static unsafe bool TryReadNumber<T>(ReadOnlySpan<byte> source, Endian endian, out T value)
        where T : unmanaged, INumber<T>
    {
        value = default;

        if (sizeof(T) > source.Length)
            return false;

        value = ReadNumber<T>(source, endian);
        return true;
    }

    /// <summary>
    /// Tries to read an <see cref="INumber{T}"/> that is stored using a non-standard number of bytes
    /// from the <paramref name="source"/> buffer.
    /// </summary>
    /// <typeparam name="TContainer">The type of number in which to store the read value.</typeparam>
    /// <param name="source">The buffer in which the number is contained.</param>
    /// <param name="bytesToRead">The number of bytes in which the number value is stored.</param>
    /// <param name="endian">The endianness of the number in its binary representation.</param>
    /// <returns>The number value.</returns>
    /// <exception cref="ArgumentOutOfRangeException">
    /// Thrown if <typeparamref name="TContainer"/> is not large enough to store the number of
    /// <paramref name="bytesToRead"/>.
    /// </exception>
    /// <remarks>
    /// This generic method is less performant than the dedicated methods on <see cref="BinaryPrimitives"/>.
    /// </remarks>
    public static unsafe TContainer ReadNumber<TContainer>(ReadOnlySpan<byte> source, byte bytesToRead, Endian endian)
        where TContainer : unmanaged, INumber<TContainer>, IShiftOperators<TContainer, int, TContainer>
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

    /// <summary>
    /// Tries to read an <see cref="INumber{T}"/> that is stored using a non-standard number of bytes
    /// from the <paramref name="source"/> buffer.
    /// </summary>
    /// <typeparam name="TContainer">The type of number in which to store the read value.</typeparam>
    /// <param name="source">The buffer in which the number is contained.</param>
    /// <param name="bytesToRead">The number of bytes in which the number value is stored.</param>
    /// <param name="endian">The endianness of the number in its binary representation.</param>
    /// <param name="value">The number value, if the read was successful.</param>
    /// <returns><c>True</c> if the value was successfully read, else <c>false</c>.</returns>
    /// <remarks>
    /// This generic method is less performant than the dedicated methods on <see cref="BinaryPrimitives"/>.
    /// </remarks>
    public static bool TryReadNumber<TContainer>
    (
        ReadOnlySpan<byte> source,
        byte bytesToRead,
        Endian endian,
        out TContainer value
    )
        where TContainer : unmanaged, INumber<TContainer>, IShiftOperators<TContainer, int, TContainer>
    {
        value = default;

        if (bytesToRead > source.Length)
            return false;

        value = ReadNumber<TContainer>(source, bytesToRead, endian);
        return true;
    }

    /// <summary>
    /// Writes an <see cref="INumber{T}"/> to the <paramref name="target"/> buffer.
    /// </summary>
    /// <typeparam name="T">The type of the number to write.</typeparam>
    /// <param name="target">The buffer to write the number value into.</param>
    /// <param name="value">The value to write.</param>
    /// <param name="endian">The endianness in which to encode the number's binary representation.</param>
    /// <remarks>
    /// This generic method is less performant than the dedicated methods on <see cref="BinaryPrimitives"/>.
    /// </remarks>
    public static unsafe void WriteNumber<T>(Span<byte> target, in T value, Endian endian)
        where T : unmanaged, INumber<T>
    {
        MemoryMarshal.Write(target, value);
        if (endian != NativeEndian)
            target[..sizeof(T)].Reverse();
    }

    /// <summary>
    /// Tries to write an <see cref="INumber{T}"/> to the <paramref name="target"/> buffer.
    /// </summary>
    /// <typeparam name="T">The type of the number to write.</typeparam>
    /// <param name="target">The buffer to write the number value into.</param>
    /// <param name="value">The value to write.</param>
    /// <param name="endian">The endianness in which to encode the number's binary representation.</param>
    /// <returns><c>True</c> if the value was successfully written, else <c>false</c>.</returns>
    /// <remarks>
    /// This generic method is less performant than the dedicated methods on <see cref="BinaryPrimitives"/>.
    /// </remarks>
    public static unsafe bool TryWriteNumber<T>(Span<byte> target, in T value, Endian endian)
        where T : unmanaged, INumber<T>
    {
        if (sizeof(T) > target.Length)
            return false;

        WriteNumber(target, value, endian);
        return true;
    }
}
