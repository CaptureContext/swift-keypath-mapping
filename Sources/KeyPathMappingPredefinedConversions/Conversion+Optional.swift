import Foundation
import SwiftMarkerProtocols
import KeyPathMappingCore

// MARK: - Convert to optional

extension KeyPathMapper.Getter where Member == Root? {
	/// Lifts a value into an optional.
	///
	/// ```swift
	/// let value = 42
	/// value[mapPath: \.optional] // Int?(42)
	/// ```
	@inlinable
	public static var optional: Self {
		.inline { $0 }
	}
}

extension KeyPathMapper.MutatingSetter where Member == Root? {
	/// Writes an optional value back into a non-optional root.
	///
	/// `nil` writes are ignored.
	///
	/// ```swift
	/// var value = 42
	/// value[convert: .optional] = nil
	/// value // 42
	/// value[convert: .optional] = 0
	/// value // 0
	/// ```
	@inlinable
	public static var optional: Self {
		.inline { v, t in t.map { v = $0 } }
	}
}

extension KeyPathMapper.MutatingConversionTo where Member == Root? {
	/// Converts a value to an optional and ignores `nil` writes.
	///
	/// ```swift
	/// var value = 42
	/// value[convert: .optional] = nil
	/// value // 42
	/// value[convert: .optional] = 0
	/// value // 0
	/// ```
	@inlinable
	public static var optional: Self {
		return .init(
			getter: .optional,
			setter: .optional
		)
	}
}

// MARK: - Convert from optional

extension KeyPathMapper.Getter where Root: _OptionalProtocol, Member == Root.Wrapped {
	/// Unwraps an optional, supplying a default when the root is `nil`.
	///
	/// ```swift
	/// let value: Int? = nil
	/// value[getter: .unwrappedWith(0)] // 0
	/// ```
	///
	/// - Parameters:
	///   - defaultValue: The value to use when the root is `nil`.
	/// - Returns: A getter that unwraps the optional root.
	@inlinable
	public static func unwrappedWith(
		_ defaultValue: @escaping @autoclosure () -> Member,
	) -> Self {
		.inline { $0._optional ?? defaultValue() }
	}
}

extension KeyPathMapper.MutatingSetter where Root: _OptionalProtocol, Member == Root.Wrapped {
	/// Creates a setter that optionally materializes a wrapped value on write.
	///
	/// When `aggressive` is `false`, writes are ignored if the root is `nil`.
	/// When `true`, writes always store the new wrapped value.
	///
	/// - Parameters:
	///   - aggressive: Whether writes should create a wrapped value when the root is `nil`.
	/// - Returns: A setter for the wrapped optional value.
	@inlinable
	public static func aggressive(
		_ aggressive: Bool = true
	) -> Self {
		.inline {
			if aggressive || $0._optional != nil {
				$0._optional = $1
			}
		}
	}
}

extension KeyPathMapper.MutatingConversionTo where Root: _OptionalProtocol, Member == Root.Wrapped {
	/// Unwraps an optional and writes through to the wrapped value.
	///
	/// By default, writes are ignored when the root is `nil`. Set
	/// `aggressive` to `true` to materialize a value on write.
	///
	/// ```swift
	/// var value: Int? = nil
	/// value[convert: .unwrapped(with: 0)] // 0
	/// value[convert: .unwrapped(with: 0, aggressive: false)] = 2
	/// value // nil
	/// value[convert: .unwrapped(with: 0, aggressive: true)] = 2
	/// value // Optional(2)
	/// ```
	///
	/// - Parameters:
	///   - defaultValue: The value to read when the root is `nil`.
	///   - aggressive: Whether writes should create a wrapped value when the root is `nil`.
	/// - Returns: A conversion between an optional root and its wrapped value.
	@inlinable
	public static func unwrapped(
		with defaultValue: @escaping @autoclosure () -> Member,
		aggressive: Bool = false
	) -> Self {
		return .init(
			getter: .unwrappedWith(defaultValue()),
			setter: .aggressive(aggressive)
		)
	}
}

// MARK: - OptionalMap

extension KeyPathMapper.Getter where Root: _OptionalProtocol {
	@inlinable
	public static func optionalMap<Value>(
		_ keyPath: KeyPath<Root.Wrapped, Value>
	) -> Self where
		Member == Optional<Value>
	{
		return .inline { $0._optional?[keyPath: keyPath] }
	}
}

extension KeyPathMapper.MutatingSetter where Root: _OptionalProtocol {
	@inlinable
	public static func optionalMap<Value>(
		_ keyPath: WritableKeyPath<Root.Wrapped, Value>,
		aggressive: Bool = false
	) -> Self where Member == Optional<Value> {
		return .inline {
			if let value = $1 {
				$0._optional?[keyPath: keyPath] = value
			} else if aggressive {
				$0._optional = nil
			}
		}
	}
}

extension KeyPathMapper.NonMutatingSetter where Root: _OptionalProtocol {
	@inlinable
	public static func optionalMap<Value>(
		_ keyPath: ReferenceWritableKeyPath<Root.Wrapped, Value>
	) -> Self where Member == Optional<Value> {
		return .inline {
			if let value = $1 {
				$0._optional?[keyPath: keyPath] = value
			}
		}
	}
}

extension KeyPathMapper.MutatingConversionTo where Root: _OptionalProtocol {
	@inlinable
	public static func optionalMap<Value>(
		_ keyPath: WritableKeyPath<Root.Wrapped, Value>,
		aggressive: Bool = false
	) -> Self where Member == Optional<Value>	{
		return .init(
			getter: .optionalMap(keyPath),
			setter: .optionalMap(keyPath, aggressive: aggressive)
		)
	}
}

extension KeyPathMapper.NonMutatingConversionTo where Root: _OptionalProtocol {
	@inlinable
	public static func optionalMap<Value>(
		_ keyPath: ReferenceWritableKeyPath<Root.Wrapped, Value>
	) -> Self where Member == Optional<Value>	{
		return .init(
			getter: .optionalMap(keyPath),
			setter: .optionalMap(keyPath)
		)
	}
}

// MARK: - Other

extension KeyPathMapper {
	/// Views a mapper's value as an optional.
	///
	/// - Returns: A mapper over the optional form of the wrapped value.
	@inlinable
	public var optional: KeyPathMapper<Value?> {
		get { .init(value) }
		set { newValue.value.map { self.value = $0 } }
	}
}
