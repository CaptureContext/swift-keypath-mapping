#if swift(<6.1) || PredefinedConversions
import Foundation

extension KeyPathMapper.Getter where Root: Collection {
	/// Reads an element at an index without bounds checking.
	///
	/// ```swift
	/// let values = [10, 20, 30]
	/// values[map: .unsafeIndex(1)] // 20
	/// ```
	///
	/// - Parameters:
	///   - index: The index to read.
	public static func unsafeIndex(_ index: Root.Index) -> Self
	where Member == Root.Element {
		.inline { $0[index] }
	}

	/// Reads an element at an index, returning `nil` when the index is invalid.
	///
	/// ```swift
	/// let values = [10, 20, 30]
	/// values[map: .safeIndex(10)] // nil
	/// ```
	///
	/// - Parameters:
	///   - index: The index to read.
	public static func safeIndex(_ index: Root.Index) -> Self
	where Member == Root.Element? {
		.inline { collection in
			guard collection.indices.contains(index)
			else { return nil }

			return collection[index]
		}
	}
}

extension KeyPathMapper.ReadonlyConversionTo where Root: Collection {
	/// Creates a read-only conversion for an element at an unchecked index.
	///
	/// - Parameters:
	///   - index: The index to read.
	@inlinable
	public static func unsafeIndex(_ index: Root.Index) -> Self
	where Member == Root.Element {
		.init(getter: .unsafeIndex(index))
	}

	/// Creates a read-only conversion for an element at a checked index.
	///
	/// - Parameters:
	///   - index: The index to read.
	@inlinable
	public static func safeIndex(_ index: Root.Index) -> Self
	where Member == Root.Element? {
		.init(getter: .safeIndex(index))
	}
}

extension KeyPathMapper.Getter where Root: MutableCollection {
	/// Reads an element at an index without bounds checking.
	///
	/// - Parameters:
	///   - index: The index to read.
	public static func unsafeIndex(_ index: Root.Index) -> Self
	where Member == Root.Element {
		.inline { $0[index] }
	}

	/// Reads an element at an index, returning `nil` when the index is invalid.
	///
	/// - Parameters:
	///   - index: The index to read.
	public static func safeIndex(_ index: Root.Index) -> Self
	where Member == Root.Element? {
		.inline { collection in
			guard collection.indices.contains(index)
			else { return nil }

			return collection[index]
		}
	}
}

extension KeyPathMapper.MutatingSetter where Root: MutableCollection {
	/// Writes an element at an index without bounds checking.
	///
	/// ```swift
	/// var values = [10, 20, 30]
	/// values[convert: .unsafeIndex(1)] = 99
	/// values // [10, 99, 30]
	/// ```
	///
	/// - Parameters:
	///   - index: The index to write.
	public static func unsafeIndex(_ index: Root.Index) -> Self
	where Member == Root.Element {
		.inline { $0[index] = $1 }
	}

	/// Writes an optional element at an index when both the index and value are valid.
	///
	/// `nil` writes are ignored.
	///
	/// ```swift
	/// var values = [10, 20, 30]
	/// values[convert: .safeIndex(10)] = 99
	/// values // [10, 20, 30]
	/// ```
	///
	/// - Parameters:
	///   - index: The index to write.
	public static func safeIndex(_ index: Root.Index) -> Self
	where Member == Root.Element? {
		.inline { collection, element in
			guard
				let element,
				collection.indices.contains(index)
			else { return }

			collection[index] = element
		}
	}
}

extension KeyPathMapper.MutatingConversionTo where Root: MutableCollection {
	/// Creates a mutating conversion for an element at an unchecked index.
	///
	/// - Parameters:
	///   - index: The index to read and write.
	@inlinable
	public static func unsafeIndex(_ index: Root.Index) -> Self
	where Member == Root.Element {
		.init(
			getter: .unsafeIndex(index),
			setter: .unsafeIndex(index)
		)
	}

	/// Creates a mutating conversion for an element at a checked index.
	///
	/// Reads return `nil` for invalid indices and writes are ignored when the
	/// index is invalid or the new value is `nil`.
	///
	/// - Parameters:
	///   - index: The index to read and write.
	@inlinable
	public static func safeIndex(_ index: Root.Index) -> Self
	where Member == Root.Element? {
		.init(
			getter: .safeIndex(index),
			setter: .safeIndex(index)
		)
	}
}
#endif
