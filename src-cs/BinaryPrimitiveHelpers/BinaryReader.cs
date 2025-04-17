using System;
using System.Diagnostics.CodeAnalysis;
using System.Runtime.CompilerServices;
using System.Text;

namespace BinaryPrimitiveHelpers;

public ref struct BinaryReader
{
    /// <summary>
    /// The underlying span of data.
    /// </summary>
    public required ReadOnlySpan<byte> Buffer;

    /// <summary>
    /// The offset into the <see cref="Buffer"/> that the reader is at.
    /// </summary>
    public int Offset = 0;

    /// <summary>
    /// The default encoding to use when reading string values.
    /// </summary>
    public Encoding DefaultEncoding = Encoding.UTF8;

    /// <summary>
    /// Gets a span over the <see cref="Buffer"/> that has been consumed.
    /// </summary>
    public ReadOnlySpan<byte> Consumed => Buffer[..Offset];

    /// <summary>
    /// Gets a span over the remaining <see cref="Buffer"/>.
    /// </summary>
    public ReadOnlySpan<byte> Remaining => Buffer[Offset..];

    /// <summary>
    /// Initializes a new instance of the <see cref="BinaryReader"/> struct.
    /// </summary>
    /// <param name="buffer">The underlying span of data to read from.</param>
    /// <param name="defaultEncoding">The default encoding to use when reading string values.</param>
    public BinaryReader(ReadOnlySpan<byte> buffer, Encoding? defaultEncoding = null)
    {
        Buffer = buffer;
        DefaultEncoding = defaultEncoding ?? Encoding.UTF8;
    }

    /// <summary>
    /// Changes the <see cref="Offset"/> of the reader by the given amount.
    /// </summary>
    /// <param name="amount">The amount to increment/decrement the offset by.</param>
    [MethodImpl(MethodImplOptions.AggressiveInlining)]
    public void Seek(int amount)
    {
        if (Offset + amount < 0 || Offset + amount >= Buffer.Length)
            throw new ArgumentOutOfRangeException(nameof(amount), amount, "Cannot advance past the end of the buffer");
        Offset += amount;
    }

    /// <summary>
    /// Reads a span of bytes from the underlying buffer.
    /// </summary>
    /// <param name="length">The number of bytes to read.</param>
    /// <returns>A span of the bytes read.</returns>
    public ReadOnlySpan<byte> ReadBytes(int length)
    {
        ReadOnlySpan<byte> slice = Buffer.Slice(Offset, length);
        Offset += length;
        return slice;
    }

    /// <summary>
    /// Tries to read a span of bytes from the underlying buffer.
    /// </summary>
    /// <param name="length">The number of bytes to read.</param>
    /// <param name="value">The value, if the read was successful.</param>
    /// <returns><c>True</c> if the value was successfully read, else <c>false</c>.</returns>
    public bool TryReadBytes(int length, out ReadOnlySpan<byte> value)
    {
        value = default;

        if (Offset + length > Buffer.Length)
            return false;

        value = ReadBytes(length);
        return true;
    }

    /// <summary>
    /// Reads a byte.
    /// </summary>
    /// <returns>A byte value.</returns>
    [MethodImpl(MethodImplOptions.AggressiveInlining)]
    public byte ReadByte()
        => Buffer[Offset++];

    /// <summary>
    /// Tries to read a byte from the underlying buffer.
    /// </summary>
    /// <param name="value">The value, if the read was successful.</param>
    /// <returns><c>True</c> if the value was successfully read, else <c>false</c>.</returns>
    public bool TryReadByte(out byte value)
    {
        value = 0;

        if (Offset + 1 >= Buffer.Length)
            return false;

        value = ReadByte();
        return true;
    }

    /// <summary>
    /// Reads a boolean from the underlying buffer.
    /// </summary>
    /// <returns>A boolean value</returns>
    /// <exception cref="Exception">Thrown if the read value was not a valid boolean.</exception>
    [MethodImpl(MethodImplOptions.AggressiveInlining)]
    public bool ReadBool()
        => ReadByte() switch
        {
            0 => false,
            1 => true,
            _ => throw new Exception("Warning: attempted to read 'boolean' value other than 0 or 1")
        };

    /// <summary>
    /// Tries to read a boolean from the underlying buffer.
    /// </summary>
    /// <param name="value">The value, if the read was successful.</param>
    /// <returns><c>True</c> if the value was successfully read, else <c>false</c>.</returns>
    public bool TryReadBool(out bool value)
    {
        value = false;

        if (Offset + 1 >= Buffer.Length || Buffer[Offset] > 1)
            return false;

        value = ReadBool();
        return true;
    }

    /// <summary>
    /// Reads a null-terminated string from the underlying buffer.
    /// </summary>
    /// <param name="encoding">
    /// The encoding to parse the string using. If <c>null</c>, defaults to <see cref="DefaultEncoding"/>.
    /// </param>
    /// <returns>A string value.</returns>
    /// <exception cref="InvalidOperationException">
    /// Thrown if no null-terminator was present in the underlying buffer.
    /// </exception>
    public string ReadStringNullTerminated(Encoding? encoding = null)
    {
        encoding ??= DefaultEncoding;

        int terminatorIndex = Buffer[Offset..].IndexOf((byte)0);
        if (terminatorIndex == -1)
            throw new InvalidOperationException("Null-terminator not found");

        string value = encoding.GetString(Buffer.Slice(Offset, terminatorIndex));
        Offset += terminatorIndex + 1;

        return value;
    }

    /// <summary>
    /// Tries to read a null-terminated string from the underlying buffer.
    /// </summary>
    /// <param name="value">The value, if the read was successful.</param>
    /// <param name="encoding">
    /// The encoding to parse the string using. If <c>null</c>, defaults to <see cref="DefaultEncoding"/>.
    /// </param>
    /// <returns><c>True</c> if the value was successfully read, else <c>false</c>.</returns>
    public bool TryReadStringNullTerminated([NotNullWhen(true)] out string? value, Encoding? encoding = null)
    {
        value = null;
        encoding ??= DefaultEncoding;

        int terminatorIndex = Buffer[Offset..].IndexOf((byte)0);
        if (terminatorIndex == -1)
            return false;

        value = encoding.GetString(Buffer.Slice(Offset, terminatorIndex));
        Offset += terminatorIndex + 1;
        return true;
    }

    /// <summary>
    /// Reads a string from the underlying buffer.
    /// </summary>
    /// <param name="length">The number of bytes consumed by the string.</param>
    /// <param name="encoding">
    /// The encoding to parse the string using. If <c>null</c>, defaults to <see cref="DefaultEncoding"/>.
    /// </param>
    /// <returns>The value.</returns>
    public string ReadString(int length, Encoding? encoding = null)
    {
        encoding ??= DefaultEncoding;

        string value = encoding.GetString(Buffer.Slice(Offset, length));
        Offset += length;

        return value;
    }

    /// <summary>
    /// Tries to read a string from the underlying buffer.
    /// </summary>
    /// <param name="length">The number of bytes consumed by the string.</param>
    /// <param name="value">The value, if the read was successful.</param>
    /// <param name="encoding">
    /// The encoding to parse the string using. If <c>null</c>, defaults to <see cref="DefaultEncoding"/>.
    /// </param>
    /// <returns><c>True</c> if the value was successfully read, else <c>false</c>.</returns>
    public bool TryReadString(int length, out string? value, Encoding? encoding = null)
    {
        value = null;
        encoding ??= DefaultEncoding;

        if (Offset + length > Buffer.Length)
            return false;

        value = encoding.GetString(Buffer.Slice(Offset, length));
        Offset += length;
        return true;
    }
}
