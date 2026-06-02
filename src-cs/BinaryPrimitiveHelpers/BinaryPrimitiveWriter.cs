using BinaryPrimitiveHelpers.Primitives;
using BinaryPrimitiveHelpers.SourceGeneration;
using System;
using System.Numerics;
using System.Runtime.CompilerServices;
using System.Text;

namespace BinaryPrimitiveHelpers;

/// <summary>
/// A binary writer implementation aimed towards allocation-free writes of primitive types to a
/// <see cref="Span{T}"/> of bytes.
/// </summary>
[ExtendWithBinaryPrimitiveShims]
public ref partial struct BinaryPrimitiveWriter
{
    /// <summary>
    /// The underlying span of data.
    /// </summary>
    public Span<byte> Buffer;

    /// <summary>
    /// The offset into the <see cref="Buffer"/> that the writer is at.
    /// </summary>
    public int Offset;

    /// <summary>
    /// The default encoding to use when writing string values.
    /// </summary>
    public Encoding DefaultEncoding;

    /// <summary>
    /// Gets a span over the <see cref="Buffer"/> that has been consumed.
    /// </summary>
    public Span<byte> Consumed => Buffer[..Offset];

    /// <summary>
    /// Gets a span over the remaining <see cref="Buffer"/>.
    /// </summary>
    public Span<byte> Remaining => Buffer[Offset..];

    /// <summary>
    /// Indicates whether the writer has reached the end of the <see cref="Buffer"/>.
    /// </summary>
    public readonly bool IsAtEnd => Offset >= Buffer.Length;

    /// <summary>
    /// The remaining number of bytes that can be written to the <see cref="Buffer"/>.
    /// </summary>
    public readonly int RemainingLength => Buffer.Length - Offset;

    /// <summary>
    /// Initializes a new instance of the <see cref="BinaryPrimitiveWriter"/> struct.
    /// </summary>
    /// <param name="buffer">The underlying span of data to write to.</param>
    /// <param name="defaultEncoding">The default encoding to use when writing string values.</param>
    public BinaryPrimitiveWriter(Span<byte> buffer, Encoding? defaultEncoding = null)
    {
        Buffer = buffer;
        Offset = 0;
        DefaultEncoding = defaultEncoding ?? Encoding.UTF8;
    }

    /// <summary>
    /// Changes the <see cref="Offset"/> of the writer by the given <paramref name="amount"/>.
    /// </summary>
    /// <param name="amount">The amount to increment/decrement the offset by.</param>
    [MethodImpl(MethodImplOptions.AggressiveInlining)]
    public void Seek(int amount)
    {
        if (Offset + amount < 0 || Offset + amount > Buffer.Length)
            throw new ArgumentOutOfRangeException(nameof(amount), amount, "Cannot advance past the end of the buffer");
        Offset += amount;
    }

    /// <summary>
    /// Tries to change the <see cref="Offset"/> of the writer by the given <paramref name="amount"/>.
    /// </summary>
    /// <param name="amount">The amount to increment/decrement the offset by.</param>
    /// <returns><c>True</c> if the seek was within the bounds of the underlying buffer, else <c>false</c>.</returns>
    public bool TrySeek(int amount)
    {
        if (Offset + amount < 0 || Offset + amount > Buffer.Length)
            return false;

        Offset += amount;
        return true;
    }

    /// <summary>
    /// Writes a span of bytes to the underlying buffer.
    /// </summary>
    /// <param name="bytes">The bytes to write.</param>
    public void WriteBytes(ReadOnlySpan<byte> bytes)
    {
        bytes.CopyTo(Buffer[Offset..]);
        Offset += bytes.Length;
    }

    /// <summary>
    /// Tries to write a span of bytes to the underlying buffer.
    /// </summary>
    /// <param name="bytes">The bytes to write.</param>
    /// <returns><c>True</c> if the value was successfully written, else <c>false</c>.</returns>
    public bool TryWriteBytes(ReadOnlySpan<byte> bytes)
    {
        bool result = bytes.TryCopyTo(Buffer[Offset..]);

        if (result)
            Offset += bytes.Length;

        return result;
    }

    /// <summary>
    /// Gets a span of bytes that can be written to and advances the writer's offset.
    /// </summary>
    /// <param name="length">The length of the span to retrieve.</param>
    /// <returns>A writable span of bytes from the underlying buffer.</returns>
    public Span<byte> GetWritableSpan(int length)
    {
        Span<byte> buffer = Buffer.Slice(Offset, length);
        Offset += length;
        return buffer;
    }

    /// <summary>
    /// Tries to get a span of bytes that can be written to. If successful, the writer's offset will be advanced.
    /// </summary>
    /// <param name="length">The length of the span to retrieve.</param>
    /// <param name="buffer">A writable span of bytes from the underlying buffer.</param>
    /// <returns>
    /// Whether there was enough remaining length in the underlying buffer to retrieve a span of the given
    /// <paramref name="length"/>.
    /// </returns>
    public bool TryGetWritableSpan(int length, out Span<byte> buffer)
    {
        buffer = default;

        if (Offset + length >= Buffer.Length)
            return false;

        buffer = GetWritableSpan(length);
        return true;
    }

    /// <summary>
    /// Writes a byte
    /// </summary>
    /// <param name="value">The value to write.</param>
    [MethodImpl(MethodImplOptions.AggressiveInlining)]
    public void WriteByte(byte value)
        => Buffer[Offset++] = value;

    /// <summary>
    /// Tries to write a byte to the underlying buffer.
    /// </summary>
    /// <param name="value">The value to write.</param>
    /// <returns><c>True</c> if the value was successfully written, else <c>false</c>.</returns>
    public bool TryWriteByte(byte value)
    {
        if (Offset >= Buffer.Length)
            return false;

        WriteByte(value);
        return true;
    }

    /// <summary>
    /// Writes a boolean to the underlying buffer.
    /// </summary>
    /// <param name="value">The value to write.</param>
    /// <exception cref="Exception">Thrown if the read value was not a valid boolean.</exception>
    [MethodImpl(MethodImplOptions.AggressiveInlining)]
    public void WriteBool(bool value)
        => WriteByte((byte)(value ? 1 : 0));

    /// <summary>
    /// Tries to write a boolean to the underlying buffer.
    /// </summary>
    /// <param name="value">The value to write.</param>
    /// <returns><c>True</c> if the value was successfully written, else <c>false</c>.</returns>
    public bool TryWriteBool(bool value)
        => TryWriteByte((byte)(value ? 1 : 0));

#if NET8_0_OR_GREATER

    /// <summary>
    /// Writes an <see cref="INumber{T}"/> to the underlying buffer.
    /// </summary>
    /// <typeparam name="T">The type of the number to write.</typeparam>
    /// <param name="value">The value to write.</param>
    /// <param name="endian">The endianness in which to encode the number's binary representation.</param>
    /// <remarks>
    /// This generic method is less performant than the per-type/endian number reading methods.
    /// </remarks>
    public unsafe void WriteNumber<T>(T value, Endian endian)
        where T : unmanaged, INumber<T>
    {
        NumberPrimitives.WriteNumber(Buffer[Offset..], value, endian);
        Offset += sizeof(T);
    }

    /// <summary>
    /// Writes an <see cref="INumber{T}"/> that is stored using a non-standard number of bytes to the underlying buffer.
    /// </summary>
    /// <typeparam name="T">
    /// The type of number in which the value is stored. This type must be large enough to store the number of
    /// <paramref name="bytesToWrite"/>.
    /// </typeparam>
    /// <param name="value">The value to write.</param>
    /// <param name="bytesToWrite">The number of bytes in which to store the written value.</param>
    /// <param name="endian">The endianness in which to encode the number's binary representation.</param>
    public unsafe void WriteNumber<T>(T value, byte bytesToWrite, Endian endian)
        where T : unmanaged, INumber<T>, IShiftOperators<T, int, T>
    {
        NumberPrimitives.WriteNumber(Buffer[Offset..], value, bytesToWrite, endian);
        Offset += sizeof(T);
    }

    /// <summary>
    /// Tries to write an <see cref="INumber{T}"/> to the underlying buffer.
    /// </summary>
    /// <typeparam name="T">The type of the number to write.</typeparam>
    /// <param name="value">The value to write.</param>
    /// <param name="endian">The endianness in which to encode the number's binary representation.</param>
    /// <returns><c>True</c> if the value was successfully written, else <c>false</c>.</returns>
    /// <remarks>
    /// This generic method is less performant than the per-type/endian number reading methods.
    /// </remarks>
    public unsafe bool TryWriteNumber<T>(T value, Endian endian)
        where T : unmanaged, INumber<T>
    {
        bool result = NumberPrimitives.TryWriteNumber(Buffer[Offset..], value, endian);
        if (result)
            Offset += sizeof(T);
        return result;
    }

    /// <summary>
    /// Tries to write an <see cref="INumber{T}"/> that is stored using a non-standard number of bytes to the underlying
    /// buffer.
    /// </summary>
    /// <typeparam name="T">
    /// The type of number in which the value is stored. This type must be large enough to store the number of
    /// <paramref name="bytesToWrite"/>.
    /// </typeparam>
    /// <param name="value">The value to write.</param>
    /// <param name="bytesToWrite">The number of bytes in which to store the written value.</param>
    /// <param name="endian">The endianness in which to encode the number's binary representation.</param>
    /// <returns><c>True</c> if the value was successfully written, else <c>false</c>.</returns>
    public unsafe bool TryWriteNumber<T>(T value, byte bytesToWrite, Endian endian)
        where T : unmanaged, INumber<T>, IShiftOperators<T, int, T>
    {
        bool result = NumberPrimitives.TryWriteNumber(Buffer[Offset..], value, bytesToWrite, endian);
        if (result)
            Offset += sizeof(T);
        return result;
    }

#endif

    /// <summary>
    /// Writes a string to the underlying buffer.
    /// </summary>
    /// <param name="value">The value to write.</param>
    /// <param name="encoding">
    /// The encoding to write the string in. If <c>null</c>, defaults to <see cref="DefaultEncoding"/>.
    /// </param>
    public void WriteString(string value, Encoding? encoding = null)
    {
        encoding ??= DefaultEncoding;
        encoding.GetBytes(value, Buffer[Offset..]);
        Offset += value.Length;
    }

    /// <summary>
    /// Tries to write a string to the underlying buffer.
    /// </summary>
    /// <param name="value">The value to write.</param>
    /// <param name="encoding">
    /// The encoding to parse the string using. If <c>null</c>, defaults to <see cref="DefaultEncoding"/>.
    /// </param>
    /// <returns><c>True</c> if the value was successfully read, else <c>false</c>.</returns>
    public bool TryWriteString(string value, Encoding? encoding = null)
    {
        encoding ??= DefaultEncoding;

        int length = encoding.GetByteCount(value);
        if (Offset + length > Buffer.Length)
            return false;

        WriteString(value, encoding);
        return true;
    }

    /// <summary>
    /// Writes a null-terminated string to the underlying buffer.
    /// </summary>
    /// <param name="value">The value to write.</param>
    /// <param name="encoding">
    /// The encoding to write the string in. If <c>null</c>, defaults to <see cref="DefaultEncoding"/>.
    /// </param>
    public void WriteStringNullTerminated(string value, Encoding? encoding = null)
    {
        WriteString(value, encoding);
        WriteByte(0);
    }

    /// <summary>
    /// Tries to write a null-terminated string to the underlying buffer.
    /// </summary>
    /// <param name="value">The value to write.</param>
    /// <param name="encoding">
    /// The encoding to parse the string using. If <c>null</c>, defaults to <see cref="DefaultEncoding"/>.
    /// </param>
    /// <returns><c>True</c> if the value was successfully read, else <c>false</c>.</returns>
    public bool TryWriteStringNullTerminated(string value, Encoding? encoding = null)
    {
        encoding ??= DefaultEncoding;

        int length = encoding.GetByteCount(value) + 1;
        if (Offset + length > Buffer.Length)
            return false;

        WriteStringNullTerminated(value, encoding);
        return true;
    }
}
