/// A type that opts into key-path-based mapping APIs.
///
/// Conform custom value types to `KeyPathMappable` to use mapping key paths and
/// conversions directly on the value. Many standard library container types
/// already conform out of the box.
public protocol KeyPathMappable {}

/// A read-only key path into a ``KeyPathMapper`` projection.
public typealias MappingKeyPath<A, B> = KeyPath<KeyPathMapper<A>, KeyPathMapper<B>>
/// A writable key path into a ``KeyPathMapper`` projection.
public typealias WritableMappingKeyPath<A, B> = WritableKeyPath<KeyPathMapper<A>, KeyPathMapper<B>>

extension KeyPathMappable {
	@_spi(Internals)
	public var __map: KeyPathMapper<Self> {
		get { .init(self) }
		set { self = newValue.value }
	}

	/// Reads a value through a mapping key path.
	///
	/// - Parameters:
	///   - keyPath: A read-only mapping key path into `Self`.
	/// - Returns: The value at `keyPath`.
	public subscript<T>(
		mapPath keyPath: MappingKeyPath<Self, T>
	) -> T {
		get { __map[keyPath: keyPath].value }
	}

	/// Reads or writes a value through a writable mapping key path.
	///
	/// - Parameters:
	///   - keyPath: A writable mapping key path into `Self`.
	/// - Returns: The value at `keyPath`.
	public subscript<T>(
		mapPath keyPath: WritableMappingKeyPath<Self, T>
	) -> T {
		get { __map[keyPath: keyPath].value }
		set { __map[keyPath: keyPath].value = newValue }
	}
}
