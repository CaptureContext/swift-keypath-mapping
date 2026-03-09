extension Equatable {
	/// Reads a member using a getter.
	///
	/// - Parameters:
	///   - getter: A getter rooted at `Self`.
	/// Reads and writes the entire value through a mutating setter.
	///
	/// This is useful for attaching setter side effects to the root value.
	///
	/// - Parameters:
	///   - setter: A mutating setter rooted at `Self`.
	/// - Returns: `self`.
	@_disfavoredOverload
	@inlinable
	public subscript<
		Getter: _Getters.Getter
	>(
		_getter getter: Getter
	) -> Getter.Member where Getter.Root == Self {
		get { getter.extract(from: self) }
	}

	/// Reads and writes a member using a getter and mutating setter.
	///
	/// - Parameters:
	///   - getter: A getter rooted at `Self`.
	///   - setter: A mutating setter rooted at `Self`.
	/// Reads and writes the entire value through a nonmutating setter.
	///
	/// This is useful for attaching setter side effects to the root value.
	///
	/// - Parameters:
	///   - setter: A nonmutating setter rooted at `Self`.
	/// - Returns: `self`.
	@_disfavoredOverload
	@inlinable
	public subscript<
		Getter: _Getters.Getter,
		Setter: _MutatingSetters.Setter
	>(
		_getter getter: Getter,
		_setter setter: Setter
	) -> Getter.Member where
		Getter.Root == Self,
		Setter.Root == Self,
		Getter.Member == Setter.Member
	{
		get { getter.extract(from: self) }
		set { setter.embed(newValue, in: &self) }
	}

	@_disfavoredOverload
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

	/// Reads and writes a member using a getter and nonmutating setter.
	///
	/// - Parameters:
	///   - getter: A getter rooted at `Self`.
	///   - setter: A nonmutating setter rooted at `Self`.
	@_disfavoredOverload
	@inlinable
	public subscript<
		Getter: _Getters.Getter,
		Setter: _NonMutatingSetters.Setter
	>(
		_getter getter: Getter,
		_setter setter: Setter
	) -> Getter.Member where
		Getter.Root == Self,
		Setter.Root == Self,
		Getter.Member == Setter.Member
	{
		get { getter.extract(from: self) }
		nonmutating set { setter.embed(newValue, in: self) }
	}

	@_disfavoredOverload
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

extension Equatable {
	/// Reads a member using a type-erased getter.
	///
	/// - Parameters:
	///   - getter: A getter rooted at `Self`.
	@_disfavoredOverload
	@inlinable
	public subscript<T>(
		getter getter: KeyPathMapper<Self>.Getter<T>
	) -> T {
		get { getter.extract(from: self) }
	}

	/// Reads and writes a member using a type-erased mutating setter.
	///
	/// - Parameters:
	///   - getter: A getter rooted at `Self`.
	///   - setter: A mutating setter rooted at `Self`.
	@_disfavoredOverload
	@inlinable
	public subscript<T>(
		getter getter: KeyPathMapper<Self>.Getter<T>,
		setter setter: KeyPathMapper<Self>.MutatingSetter<T>
	) -> T {
		get { getter.extract(from: self) }
		set { setter.embed(newValue, in: &self) }
	}

	/// Reads and writes the entire value through a type-erased mutating setter.
	///
	/// - Parameters:
	///   - setter: A mutating setter rooted at `Self`.
	/// - Returns: `self`.
	@_disfavoredOverload
	@inlinable
	public subscript(
		setter setter: KeyPathMapper<Self>.MutatingSetter<Self>
	) -> Self {
		get { self }
		set { setter.embed(newValue, in: &self) }
	}

	/// Reads and writes a member using a type-erased nonmutating setter.
	///
	/// - Parameters:
	///   - getter: A getter rooted at `Self`.
	///   - setter: A nonmutating setter rooted at `Self`.
	@_disfavoredOverload
	@inlinable
	public subscript<T>(
		getter getter: KeyPathMapper<Self>.Getter<T>,
		setter setter: KeyPathMapper<Self>.NonMutatingSetter<T>
	) -> T {
		get { getter.extract(from: self) }
		nonmutating set { setter.embed(newValue, in: self) }
	}

	/// Reads and writes the entire value through a type-erased nonmutating setter.
	///
	/// - Parameters:
	///   - setter: A nonmutating setter rooted at `Self`.
	/// - Returns: `self`.
	@_disfavoredOverload
	@inlinable
	public subscript(
		setter setter: KeyPathMapper<Self>.NonMutatingSetter<Self>
	) -> Self {
		get { self }
		nonmutating set { setter.embed(newValue, in: self) }
	}
}
