extension KeyPathMapper {
	/// A read-only conversion rooted at this mapper's value type.
	public typealias ReadonlyConversionProtocol<Member> = _ReadonlyConversions.ConversionProtocol<Value, Member>
	/// A mutating conversion rooted at this mapper's value type.
	public typealias MutatingConversionProtocol<Member> = _MutatingConversions.ConversionProtocol<Value, Member>
	/// A nonmutating conversion rooted at this mapper's value type.
	public typealias NonMutatingConversionProtocol<Member> = _NonMutatingConversions.ConversionProtocol<Value, Member>
}

extension KeyPathMapper {
	/// A type-erased read-only conversion rooted at this mapper's value type.
	public typealias ReadonlyConversionTo<Member> = _ReadonlyConversions.AnyConversion<Value, Member>
	/// A type-erased mutating conversion rooted at this mapper's value type.
	public typealias MutatingConversionTo<Member> = _MutatingConversions.AnyConversion<Value, Member>
	/// A type-erased nonmutating conversion rooted at this mapper's value type.
	public typealias NonMutatingConversionTo<Member> = _NonMutatingConversions.AnyConversion<Value, Member>
}

extension KeyPathMapper {
	/// Reads a mapped member using a read-only conversion.
	///
	/// - Parameters:
	///   - conversion: A read-only conversion rooted at `Value`.
	@inlinable
	public subscript<Conversion: _ReadonlyConversions.ConversionProtocol>(
		_map conversion: Conversion
	) -> KeyPathMapper<Conversion.Member> where Conversion.Root == Value {
		get { .init(conversion.extract(from: value)) }
	}

	/// Reads and writes a mapped member using a mutating conversion.
	///
	/// - Parameters:
	///   - conversion: A mutating conversion rooted at `Value`.
	@inlinable
	public subscript<Conversion: _MutatingConversions.ConversionProtocol>(
		_convert conversion: Conversion
	) -> KeyPathMapper<Conversion.Member> where Conversion.Root == Value {
		get { .init(conversion.extract(from: value)) }
		set { conversion.embed(newValue.value, in: &value) }
	}

	/// Reads and writes a mapped member using a nonmutating conversion.
	///
	/// - Parameters:
	///   - conversion: A nonmutating conversion rooted at `Value`.
	@inlinable
	public subscript<Conversion: _NonMutatingConversions.ConversionProtocol>(
		_convert conversion: Conversion
	) -> KeyPathMapper<Conversion.Member> where Conversion.Root == Value {
		get { .init(conversion.extract(from: value)) }
		nonmutating set { conversion.embed(newValue.value, in: value) }
	}
}

extension KeyPathMapper {
	/// Reads a mapped member using a type-erased read-only conversion.
	///
	/// - Parameters:
	///   - conversion: A read-only conversion rooted at `Value`.
	@inlinable
	public subscript<T>(
		map conversion: ReadonlyConversionTo<T>
	) -> KeyPathMapper<T> {
		get { .init(conversion.extract(from: value)) }
	}

	/// Reads and writes a mapped member using a type-erased mutating conversion.
	///
	/// - Parameters:
	///   - conversion: A mutating conversion rooted at `Value`.
	@inlinable
	public subscript<T>(
		convert conversion: MutatingConversionTo<T>
	) -> KeyPathMapper<T> {
		get { .init(conversion.extract(from: value)) }
		set { conversion.embed(newValue.value, in: &value) }
	}

	/// Reads and writes a mapped member using a type-erased nonmutating conversion.
	///
	/// - Parameters:
	///   - conversion: A nonmutating conversion rooted at `Value`.
	@inlinable
	public subscript<T>(
		convert conversion: NonMutatingConversionTo<T>
	) -> KeyPathMapper<T> {
		get { .init(conversion.extract(from: value)) }
		nonmutating set { conversion.embed(newValue.value, in: value) }
	}
}
