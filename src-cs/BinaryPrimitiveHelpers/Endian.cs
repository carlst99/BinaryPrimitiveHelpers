namespace BinaryPrimitiveHelpers;

/// <summary>
/// Enumerates the possible endianness types (the order in which bytes of a word are arranged).
/// </summary>
public enum Endian
{
    /// <summary>
    /// Bytes of a word are arranged with the most significant bit first.
    /// </summary>
    Big,

    /// <summary>
    /// Bytes of a word are arranged with the least significant bit first.
    /// </summary>
    Little
}
