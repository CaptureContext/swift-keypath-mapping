extension KeyPathMappable {
	/// Reads a member using a read-only conversion.
	///
	/// - Parameters:
	///   - conversion: A read-only conversion rooted at `Self`.
	/// - Returns: The converted member.
	@inlinable
	public subscript<Conversion: _ReadonlyConversions.ConversionProtocol>(
		_map conversion: Conversion
	) -> Conversion.Member where Conversion.Root == Self {
		get { conversion.extract(from: self) }
	}

	/// Reads and writes a member using a mutating conversion.
	///
	/// - Parameters:
	///   - conversion: A mutating conversion rooted at `Self`.
	/// - Returns: The converted member.
	@inlinable
	public subscript<Conversion: _MutatingConversions.ConversionProtocol>(
		_convert conversion: Conversion
	) -> Conversion.Member where Conversion.Root == Self {
		get { conversion.extract(from: self) }
		set { conversion.embed(newValue, in: &self) }
	}

	/// Reads and writes a member using a nonmutating conversion.
	///
	/// - Parameters:
	///   - conversion: A nonmutating conversion rooted at `Self`.
	/// - Returns: The converted member.
	@inlinable
	public subscript<Conversion: _NonMutatingConversions.ConversionProtocol>(
		_convert conversion: Conversion
	) -> Conversion.Member where Conversion.Root == Self {
		get { conversion.extract(from: self) }
		nonmutating set { conversion.embed(newValue, in: self) }
	}
}

extension KeyPathMappable {
	/// Reads a member using a type-erased read-only conversion.
	///
	/// - Parameters:
	///   - conversion: A read-only conversion rooted at `Self`.
	/// - Returns: The converted member.
	@inlinable
	public subscript<T>(
		map conversion: _ReadonlyConversions.AnyConversion<Self, T>
	) -> T {
		get { conversion.extract(from: self) }
	}

	/// Reads and writes a member using a type-erased mutating conversion.
	///
	/// - Parameters:
	///   - conversion: A mutating conversion rooted at `Self`.
	/// - Returns: The converted member.
	@inlinable
	public subscript<T>(
		convert conversion: _MutatingConversions.AnyConversion<Self, T>
	) -> T {
		get { conversion.extract(from: self) }
		set { conversion.embed(newValue, in: &self) }
	}

	/// Reads and writes a member using a type-erased nonmutating conversion.
	///
	/// - Parameters:
	///   - conversion: A nonmutating conversion rooted at `Self`.
	/// - Returns: The converted member.
	@inlinable
	public subscript<T>(
		convert conversion: _NonMutatingConversions.AnyConversion<Self, T>
	) -> T {
		get { conversion.extract(from: self) }
		nonmutating set { conversion.embed(newValue, in: self) }
	}
}
