/// A type that exposes a mutable mapped value.
public protocol KeyPathMapperProtocol<Value> {
	associatedtype Value
	var value: Value { get set }
}

/// A lightweight wrapper for projecting mapping APIs over a root value.
///
/// `KeyPathMapper` is the main entry point for composing getters, setters, and
/// conversions with regular key paths.
public struct KeyPathMapper<Value>: KeyPathMapperProtocol {
	/// The wrapped root value.
	public var value: Value

	/// Creates a mapper for a root value.
	///
	/// - Parameters:
	///   - value: The root value to wrap.
	@inlinable
	public init(_ value: Value) {
		self.value = value
	}

	/// Accesses the wrapped value directly.
	///
	/// - Returns: The wrapped value.
	@inlinable
	public subscript() -> Value {
		get { value }
		set { self.value = newValue }
	}

	/// Replaces the wrapped value.
	///
	/// - Parameters:
	///   - value: A new root value.
	@inlinable
	public mutating func callAsFunction(_ value: Value) {
		self.value = value
	}

	/// Reads a value through a read-only key path on the mapper.
	///
	/// - Parameters:
	///   - keyPath: A read-only key path into the mapper.
	/// - Returns: The value at `keyPath`.
	@inlinable
	public subscript<T>(
		map keyPath: KeyPath<Self, T>
	) -> T {
		get { self[keyPath: keyPath] }
	}

	/// Reads or writes a value through a writable key path on the mapper.
	///
	/// - Parameters:
	///   - keyPath: A writable key path into the mapper.
	/// - Returns: The value at `keyPath`.
	@inlinable
	public subscript<T>(
		map keyPath: WritableKeyPath<Self, T>
	) -> T {
		get { self[keyPath: keyPath] }
		set { self[keyPath: keyPath] = newValue }
	}
}

extension KeyPathMapper: Sendable where Value: Sendable {}
extension KeyPathMapper: Equatable where Value: Equatable {}
extension KeyPathMapper: Hashable where Value: Hashable {}
