extension Equatable {
	@_disfavoredOverload
	@inlinable
	public subscript<Conversion: _ReadonlyConversions.ConversionProtocol>(
		_map conversion: Conversion
	) -> Conversion.Member where Conversion.Root == Self {
		get { conversion.extract(from: self) }
	}

	@_disfavoredOverload
	@inlinable
	public subscript<Conversion: _MutatingConversions.ConversionProtocol>(
		_convert conversion: Conversion
	) -> Conversion.Member where Conversion.Root == Self {
		get { conversion.extract(from: self) }
		set { conversion.embed(newValue, in: &self) }
	}

	@_disfavoredOverload
	@inlinable
	public subscript<Conversion: _NonMutatingConversions.ConversionProtocol>(
		_convert conversion: Conversion
	) -> Conversion.Member where Conversion.Root == Self {
		get { conversion.extract(from: self) }
		nonmutating set { conversion.embed(newValue, in: self) }
	}
}

extension Equatable {
	@_disfavoredOverload
	@inlinable
	public subscript<T>(
		map conversion: _ReadonlyConversions.AnyConversion<Self, T>
	) -> T {
		get { conversion.extract(from: self) }
	}

	@_disfavoredOverload
	@inlinable
	public subscript<T>(
		convert conversion: _MutatingConversions.AnyConversion<Self, T>
	) -> T {
		get { conversion.extract(from: self) }
		set { conversion.embed(newValue, in: &self) }
	}

	@_disfavoredOverload
	@inlinable
	public subscript<T>(
		convert conversion: _NonMutatingConversions.AnyConversion<Self, T>
	) -> T {
		get { conversion.extract(from: self) }
		nonmutating set { conversion.embed(newValue, in: self) }
	}
}
