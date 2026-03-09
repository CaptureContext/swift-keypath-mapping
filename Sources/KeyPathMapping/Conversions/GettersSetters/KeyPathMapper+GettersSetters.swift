extension KeyPathMapper {
	/// A getter rooted at this mapper's value type.
	public typealias GetterProtocol<Member> = _Getters.Getter<Value, Member>
	/// A mutating setter rooted at this mapper's value type.
	public typealias MutatingSetterProtocol<Member> = _MutatingSetters.Setter<Value, Member>
	/// A nonmutating setter rooted at this mapper's value type.
	public typealias NonMutatingSetterProtocol<Member> = _NonMutatingSetters.Setter<Value, Member>
}

extension KeyPathMapper {
	/// A type-erased getter rooted at this mapper's value type.
	public typealias Getter<Member> = _Getters.AnyGetter<Value, Member>
	/// A type-erased mutating setter rooted at this mapper's value type.
	public typealias MutatingSetter<Member> = _MutatingSetters.AnySetter<Value, Member>
	/// A type-erased nonmutating setter rooted at this mapper's value type.
	public typealias NonMutatingSetter<Member> = _NonMutatingSetters.AnySetter<Value, Member>
}

extension KeyPathMapper {
	/// Reads a mapped member using a getter.
	///
	/// - Parameters:
	///   - getter: A getter rooted at `Value`.
	/// - Returns: A mapper wrapping the extracted member.
	@inlinable
	public subscript<
		Getter: _Getters.Getter
	>(
		_getter getter: Getter
	) -> KeyPathMapper<Getter.Member> where Getter.Root == Value {
		get { .init(getter.extract(from: value)) }
	}

	/// Reads and writes a mapped member using a getter and mutating setter.
	///
	/// - Parameters:
	///   - getter: A getter rooted at `Value`.
	///   - setter: A mutating setter rooted at `Value`.
	/// - Returns: A mapper wrapping the extracted member.
	@inlinable
	public subscript<
		Getter: _Getters.Getter,
		Setter: _MutatingSetters.Setter
	>(
		_getter getter: Getter,
		_setter setter: Setter
	) -> KeyPathMapper<Getter.Member> where
		Getter.Root == Value,
		Setter.Root == Value,
		Getter.Member == Setter.Member
	{
		get { .init(getter.extract(from: value)) }
		set { setter.embed(newValue.value, in: &value) }
	}

	/// Reads and writes the entire mapper value through a mutating setter.
	///
	/// This is useful for attaching setter side effects to the root value.
	///
	/// - Parameters:
	///   - setter: A mutating setter rooted at `Self`.
	/// - Returns: `self`.
	@inlinable
	public subscript<
		Setter: _MutatingSetters.Setter
	>(
		_setter setter: Setter
	) -> Self where
		Setter.Root == Self,
		Setter.Member == Self
	{
		get { self }
		set { setter.embed(newValue, in: &self) }
	}

	/// Reads and writes a mapped member using a getter and nonmutating setter.
	///
	/// - Parameters:
	///   - getter: A getter rooted at `Value`.
	///   - setter: A nonmutating setter rooted at `Value`.
	/// - Returns: A mapper wrapping the extracted member.
	@inlinable
	public subscript<
		Getter: _Getters.Getter,
		Setter: _NonMutatingSetters.Setter
	>(
		_getter getter: Getter,
		_setter setter: Setter
	) -> KeyPathMapper<Getter.Member> where
		Getter.Root == Value,
		Setter.Root == Value,
		Getter.Member == Setter.Member
	{
		get { .init(getter.extract(from: value)) }
		nonmutating set { setter.embed(newValue.value, in: value) }
	}

	/// Reads and writes the entire mapper value through a nonmutating setter.
	///
	/// This is useful for attaching setter side effects to the root value.
	///
	/// - Parameters:
	///   - setter: A nonmutating setter rooted at `Self`.
	/// - Returns: `self`.
	@inlinable
	public subscript<
		Setter: _NonMutatingSetters.Setter
	>(
		_setter setter: Setter
	) -> Self where
		Setter.Root == Self,
		Setter.Member == Self
	{
		get { self }
		set { setter.embed(newValue, in: self) }
	}
}

extension KeyPathMapper {
	/// Reads a mapped member using a type-erased getter.
	///
	/// - Parameters:
	///   - getter: A getter rooted at `Value`.
	/// - Returns: A mapper wrapping the extracted member.
	@inlinable
	public subscript<T>(
		getter getter: Getter<T>
	) -> KeyPathMapper<T> {
		get { .init(getter.extract(from: value)) }
	}

	/// Reads and writes a mapped member using a type-erased mutating setter.
	///
	/// - Parameters:
	///   - getter: A getter rooted at `Value`.
	///   - setter: A mutating setter rooted at `Value`.
	/// - Returns: A mapper wrapping the extracted member.
	@inlinable
	public subscript<T>(
		getter getter: Getter<T>,
		setter setter: MutatingSetter<T>
	) -> KeyPathMapper<T> {
		get { .init(getter.extract(from: value)) }
		set { setter.embed(newValue.value, in: &value) }
	}

	/// Reads and writes the entire mapper value through a type-erased mutating setter.
	///
	/// - Parameters:
	///   - setter: A mutating setter rooted at `Self`.
	/// - Returns: `self`.
	@inlinable
	public subscript(
		setter setter: KeyPathMapper<Self>.MutatingSetter<Self>
	) -> Self {
		get { self }
		set { setter.embed(newValue, in: &self) }
	}

	/// Reads and writes a mapped member using a type-erased nonmutating setter.
	///
	/// - Parameters:
	///   - getter: A getter rooted at `Value`.
	///   - setter: A nonmutating setter rooted at `Value`.
	/// - Returns: A mapper wrapping the extracted member.
	@inlinable
	public subscript<T>(
		getter getter: Getter<T>,
		setter setter: NonMutatingSetter<T>
	) -> KeyPathMapper<T> {
		get { .init(getter.extract(from: value)) }
		nonmutating set { setter.embed(newValue.value, in: value) }
	}

	/// Reads and writes the entire mapper value through a type-erased nonmutating setter.
	///
	/// - Parameters:
	///   - setter: A nonmutating setter rooted at `Self`.
	/// - Returns: `self`.
	@inlinable
	public subscript(
		setter setter: KeyPathMapper<Self>.NonMutatingSetter<Self>
	) -> Self {
		get { self }
		nonmutating set { setter.embed(newValue, in: self) }
	}
}
