extension _Getters {
	/// Type-erased getter
	public struct AnyGetter<
		Root,
		Member
	>: Getter {
		@inlinable
		public static func == (lhs: Self, rhs: Self) -> Bool {
			lhs.underlying._swift_keypath_mapper_isEqual(to: rhs.underlying)
		}

		@usableFromInline
		let underlying: any Getter<Root, Member>

		public init(_ underlying: any Getter<Root, Member>) {
			self.underlying = underlying
		}

		@inlinable
		public func extract(from root: Root) -> Member {
			underlying.extract(from: root)
		}

		@inlinable
		public func hash(into hasher: inout Hasher) {
			underlying.hash(into: &hasher)
		}
	}
}

extension _MutatingSetters {
	/// Type-erased mutating setter
	public struct AnySetter<
		Root,
		Member
	>: Setter {
		@inlinable
		public static func == (lhs: Self, rhs: Self) -> Bool {
			lhs.underlying._swift_keypath_mapper_isEqual(to: rhs.underlying)
		}

		@usableFromInline
		let underlying: any Setter<Root, Member>

		public init(_ underlying: any Setter<Root, Member>) {
			self.underlying = underlying
		}

		@inlinable
		public func embed(_ member: Member, in root: inout Root) {
			underlying.embed(member, in: &root)
		}

		@inlinable
		public func hash(into hasher: inout Hasher) {
			underlying.hash(into: &hasher)
		}
	}
}

extension _NonMutatingSetters {
	/// Type-erased nonmutating setter
	public struct AnySetter<
		Root,
		Member
	>: Setter {
		@inlinable
		public static func == (lhs: Self, rhs: Self) -> Bool {
			lhs.underlying._swift_keypath_mapper_isEqual(to: rhs.underlying)
		}

		@usableFromInline
		let underlying: any Setter<Root, Member>

		public init(_ underlying: any Setter<Root, Member>) {
			self.underlying = underlying
		}

		@inlinable
		public func embed(_ member: Member, in root: Root) {
			underlying.embed(member, in: root)
		}

		@inlinable
		public func hash(into hasher: inout Hasher) {
			underlying.hash(into: &hasher)
		}
	}
}

extension _MutatingSetters.AnySetter {
	@usableFromInline
	internal struct DisableMutations: _NonMutatingSetters.Setter {
		@usableFromInline
		static func == (lhs: Self, rhs: Self) -> Bool {
			lhs.underlying._swift_keypath_mapper_isEqual(to: rhs.underlying)
		}

		@usableFromInline
		let underlying: any _MutatingSetters.Setter<Root, Member>

		@usableFromInline
		init(for underlying: any _MutatingSetters.Setter<Root, Member>) {
			self.underlying = underlying
		}

		@usableFromInline
		func embed(_ member: Member, in root: Root) {
			var copy = root
			underlying.embed(member, in: &copy)
		}

		@usableFromInline
		func hash(into hasher: inout Hasher) {
			underlying.hash(into: &hasher)
		}
	}

	/// Converts a mutating setter into a nonmutating setter by writing through a
	/// mutable local copy of the root.
	///
	/// - Returns: A nonmutating wrapper around this setter.
	@inlinable
	public func _withMutationsDisabled() -> _NonMutatingSetters.AnySetter<Root, Member> {
		.init(DisableMutations(for: underlying))
	}
}

// MARK: - Erasure

extension _Getters.Getter {
	/// Erases getter to AnyGetter type
	@inlinable
	public func eraseToAnyGetter() -> _Getters.AnyGetter<Root, Member> {
		.init(self)
	}
}

extension _MutatingSetters.Setter {
	/// Erases mutating setter to AnySetter type
	@inlinable
	public func eraseToAnyMutatingSetter() -> _MutatingSetters.AnySetter<Root, Member> {
		.init(self)
	}
}

extension _NonMutatingSetters.Setter {
	/// Erases nonmutating setter to AnySetter type
	@inlinable
	public func eraseToAnyNonMutatingSetter() -> _NonMutatingSetters.AnySetter<Root, Member> {
		.init(self)
	}
}

// MARK: - Inline

extension _Getters.AnyGetter {
	/// Creates a getter from an inline closure.
	///
	/// - Parameters:
	///   - id: A stable identity used for equality and hashing.
	///   - extract: A closure that extracts a member from a root value.
	/// - Returns: A getter backed by `extract`.
	@inlinable
	public static func inline(
		id: (any Hashable) = ObjectIdentifier(Self.self),
		extract: @escaping (Root) -> Member
	) -> Self {
		.init(_Getters.Inline(id: id, extract: extract))
	}
}

extension _MutatingSetters.AnySetter {
	/// Creates a mutating setter from an inline closure.
	///
	/// - Parameters:
	///   - id: A stable identity used for equality and hashing.
	///   - embed: A closure that writes a member into a mutable root value.
	/// - Returns: A setter backed by `embed`.
	@inlinable
	public static func inline(
		id: (any Hashable) = ObjectIdentifier(Self.self),
		embed: @escaping (inout Root, Member) -> Void
	) -> Self {
		.init(_MutatingSetters.Inline(id: id, embed: embed))
	}

	/// Creates a mutating setter from an inline closure that returns a new root.
	///
	/// - Parameters:
	///   - id: A stable identity used for equality and hashing.
	///   - embed: A closure that produces a new root from a member.
	/// - Returns: A setter backed by `embed`.
	@inlinable
	public static func inline(
		id: (any Hashable) = ObjectIdentifier(Self.self),
		embed: @escaping (Member) -> Root
	) -> Self {
		.inline(id: id) { $0 = embed($1) }
	}
}

extension _NonMutatingSetters.AnySetter {
	/// Creates a nonmutating setter from an inline closure.
	///
	/// - Parameters:
	///   - id: A stable identity used for equality and hashing.
	///   - embed: A closure that handles a write without mutating the root in place.
	/// - Returns: A setter backed by `embed`.
	@inlinable
	public static func inline(
		id: (any Hashable) = ObjectIdentifier(Self.self),
		embed: @escaping (Root, Member) -> Void
	) -> Self {
		.init(_NonMutatingSetters.Inline(id: id, embed: embed))
	}
}

// MARK: - Perform

extension _MutatingSetters.AnySetter where Root == Member {
	/// Creates a setter that replaces the root and optionally invokes hooks
	/// before and after the write.
	///
	/// - Parameters:
	///   - id: A stable identity used for equality and hashing.
	///   - onWillSet: A hook invoked before the new value is written.
	///   - onDidSet: A hook invoked after the new value is written.
	/// - Returns: A setter that writes the incoming value into the root.
	@inlinable
	public static func perform(
		id: (any Hashable) = ObjectIdentifier(Self.self),
		onWillSet: ((Member) -> Void)? = nil,
		onDidSet: ((Member) -> Void)? = nil
	) -> Self {
		return .inline(id: id) {
			onWillSet?($1)
			$0 = $1
			onDidSet?($1)
		}
	}

	/// Creates a setter that replaces the root and optionally invokes hooks
	/// that can observe both the current root and incoming value.
	///
	/// - Parameters:
	///   - id: A stable identity used for equality and hashing.
	///   - onWillSet: A hook invoked before the new value is written.
	///   - onDidSet: A hook invoked after the new value is written.
	/// - Returns: A setter that writes the incoming value into the root.
	@inlinable
	public static func perform(
		id: (any Hashable) = ObjectIdentifier(Self.self),
		onWillSet: ((Root, Member) -> Void)? = nil,
		onDidSet: ((Root, Member) -> Void)? = nil
	) -> Self {
		return .inline(id: id) {
			onWillSet?($0, $1)
			$0 = $1
			onDidSet?($0, $1)
		}
	}

	/// Creates a setter that runs an operation before replacing the root.
	///
	/// - Parameters:
	///   - id: A stable identity used for equality and hashing.
	///   - operation: A hook invoked before the new value is written.
	/// - Returns: A setter that writes the incoming value into the root.
	@inlinable
	public static func onWillSet(
		id: (any Hashable) = ObjectIdentifier(Self.self),
		operation: @escaping (Member) -> Void
	) -> Self {
		return .inline(id: id) {
			operation($1)
			$0 = $1
		}
	}

	/// Creates a setter that runs an operation before replacing the root.
	///
	/// - Parameters:
	///   - id: A stable identity used for equality and hashing.
	///   - operation: A hook invoked with the current root and incoming member before the write.
	/// - Returns: A setter that writes the incoming value into the root.
	@inlinable
	public static func onWillSet(
		id: (any Hashable) = ObjectIdentifier(Self.self),
		operation: @escaping (Root, Member) -> Void
	) -> Self {
		return .inline(id: id) {
			operation($0, $1)
			$0 = $1
		}
	}

	/// Creates a setter that runs an operation after replacing the root.
	///
	/// - Parameters:
	///   - id: A stable identity used for equality and hashing.
	///   - operation: A hook invoked after the new value is written.
	/// - Returns: A setter that writes the incoming value into the root.
	@inlinable
	public static func onDidSet(
		id: (any Hashable) = ObjectIdentifier(Self.self),
		perform operation: @escaping (Member) -> Void
	) -> Self {
		return .inline(id: id) {
			$0 = $1
			operation($1)
		}
	}

	/// Creates a setter that runs an operation after replacing the root.
	///
	/// - Parameters:
	///   - id: A stable identity used for equality and hashing.
	///   - operation: A hook invoked with the updated root and written member after the write.
	/// - Returns: A setter that writes the incoming value into the root.
	@inlinable
	public static func onDidSet(
		id: (any Hashable) = ObjectIdentifier(Self.self),
		perform operation: @escaping (Root, Member) -> Void
	) -> Self {
		return .inline(id: id) {
			$0 = $1
			operation($0, $1)
		}
	}
}

extension _MutatingSetters.AnySetter where Root == Member {
	/// Creates AnySetter inline with a provided function that doesn't transform the value
	///
	/// - Warning: Reference-type transformations will be applied accordingly to default Swift handling of reference types
	/// - Parameters:
	///   - id: A stable identity used for equality and hashing.
	///   - operation: A closure that observes and updates the root value.
	/// - Returns: A setter backed by `operation`.
	@inlinable
	public static func perform(
		id: (any Hashable) = ObjectIdentifier(Self.self),
		operation: @escaping (Root, Member) -> Void
	) -> Self {
		return .inline(id: id) { operation($0, $1) }
	}
}

extension _NonMutatingSetters.AnySetter where Root == Member {
	/// Creates AnySetter inline with a provided function that doesn't transform the value
	///
	/// - Warning: Reference-type transformations will be applied accordingly to default Swift handling of reference types
	/// - Parameters:
	///   - id: A stable identity used for equality and hashing.
	///   - operation: A closure that observes the root and incoming value.
	/// - Returns: A setter backed by `operation`.
	@inlinable
	public static func perform(
		id: (any Hashable) = ObjectIdentifier(Self.self),
		operation: @escaping (Root, Member) -> Void
	) -> Self {
		return .inline(id: id, embed: operation)
	}
}
