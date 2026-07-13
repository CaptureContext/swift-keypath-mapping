extension _ReadonlyConversions {
	public struct AnyConversion<
		Root,
		Member
	>: ConversionProtocol {
		@inlinable
		public static func == (lhs: Self, rhs: Self) -> Bool {
			lhs.underlying._swift_keypath_mapper_isEqual(to: rhs.underlying)
		}

		@usableFromInline
		let underlying: any ConversionProtocol<Root, Member>

		@inlinable
		public init(
			getter: _Getters.AnyGetter<Root, Member>
		) {
			self.init(Conversion(getter: getter))
		}

		public init(_ underlying: any ConversionProtocol<Root, Member>) {
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

extension _MutatingConversions {
	public struct AnyConversion<
		Root,
		Member
	>: ConversionProtocol {
		@inlinable
		public static func == (lhs: Self, rhs: Self) -> Bool {
			lhs.underlying._swift_keypath_mapper_isEqual(to: rhs.underlying)
		}

		@usableFromInline
		let underlying: any ConversionProtocol<Root, Member>

		@inlinable
		public init(
			getter: _Getters.AnyGetter<Root, Member>,
			setter: _MutatingSetters.AnySetter<Root, Member>
		) {
			self.init(Conversion(
				getter: getter,
				setter: setter
			))
		}

		public init(_ underlying: any ConversionProtocol<Root, Member>) {
			self.underlying = underlying
		}

		@inlinable
		public func extract(from root: Root) -> Member {
			underlying.extract(from: root)
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

extension _NonMutatingConversions {
	public struct AnyConversion<
		Root,
		Member
	>: ConversionProtocol {
		@inlinable
		public static func == (lhs: Self, rhs: Self) -> Bool {
			lhs.underlying._swift_keypath_mapper_isEqual(to: rhs.underlying)
		}

		@usableFromInline
		let underlying: any ConversionProtocol<Root, Member>

		@inlinable
		public init(
			getter: _Getters.AnyGetter<Root, Member>,
			setter: _NonMutatingSetters.AnySetter<Root, Member>
		) {
			self.init(Conversion(
				getter: getter,
				setter: setter
			))
		}

		public init(_ underlying: any ConversionProtocol<Root, Member>) {
			self.underlying = underlying
		}

		@inlinable
		public func extract(from root: Root) -> Member {
			underlying.extract(from: root)
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

// MARK: - Specifiers

extension _ReadonlyConversions.AnyConversion {
	/// Marks a conversion as read-only.
	///
	/// - Parameters:
	///   - conversion: A read-only conversion.
	/// - Returns: `conversion`.
	@inlinable
	public static func readonly(
		_ conversion: Self
	) -> Self {
		return conversion
	}
}

extension _MutatingConversions.AnyConversion {
	/// Marks a conversion as mutating.
	///
	/// - Parameters:
	///   - conversion: A mutating conversion.
	/// - Returns: `conversion`.
	@inlinable
	public static func mutating(
		_ conversion: Self
	) -> Self {
		return conversion
	}
}

extension _NonMutatingConversions.AnyConversion {
	/// Marks a conversion as nonmutating.
	///
	/// - Parameters:
	///   - conversion: A nonmutating conversion.
	/// - Returns: `conversion`.
	@inlinable
	public static func nonmutating(
		_ conversion: Self
	) -> Self {
		return conversion
	}
}

// MARK: - Inline

extension _ReadonlyConversions.AnyConversion {
	/// Creates a mutating conversion from inline getter and setter closures.
	///
	/// - Parameters:
	///   - extract: A closure that extracts a member from a root value.
	///   - embed: A closure that writes a member into a mutable root value.
	/// - Returns: A mutating conversion backed by `extract` and `embed`.
	@inlinable
	public static func inline(
		extract: @escaping (Root) -> Member
	) -> Self {
		.init(
			getter: .inline(extract: extract)
		)
	}
}

extension _MutatingConversions.AnyConversion {
	/// Creates a mutating conversion from inline getter and setter closures.
	///
	/// - Parameters:
	///   - extract: A closure that extracts a member from a root value.
	///   - embed: A closure that writes a member into a mutable root value.
	/// - Returns: A mutating conversion backed by `extract` and `embed`.
	@inlinable
	public static func inline(
		extract: @escaping (Root) -> Member,
		embed: @escaping (inout Root, Member) -> Void
	) -> Self {
		.init(
			getter: .inline(extract: extract),
			setter: .inline(embed: embed)
		)
	}
}

extension _MutatingConversions.AnyConversion {
	/// Creates a mutating conversion from inline closures.
	///
	/// - Parameters:
	///   - extract: A closure that extracts a member from a root value.
	///   - embed: A closure that produces a new root from a member.
	/// - Returns: A mutating conversion backed by `extract` and `embed`.
	@inlinable
	public static func inline(
		extract: @escaping (Root) -> Member,
		embed: @escaping (Member) -> Root
	) -> Self {
		.init(
			getter: .inline(extract: extract),
			setter: .inline(embed: embed)
		)
	}
}

extension _NonMutatingConversions.AnyConversion {
	/// Creates a nonmutating conversion from inline getter and setter closures.
	///
	/// - Parameters:
	///   - extract: A closure that extracts a member from a root value.
	///   - embed: A closure that handles a write without mutating the root in place.
	/// - Returns: A nonmutating conversion backed by `extract` and `embed`.
	@inlinable
	public static func inline(
		extract: @escaping (Root) -> Member,
		embed: @escaping (Root, Member) -> Void
	) -> Self {
		.init(
			getter: .inline(extract: extract),
			setter: .inline(embed: embed)
		)
	}
}

extension _MutatingConversions.AnyConversion where Root == Member {
	/// Creates a mutating conversion from inline getter and setter closures.
	///
	/// - Parameters:
	///   - extract: A closure that extracts a member from a root value.
	///   - embed: A closure that writes a member into a mutable root value.
	/// - Returns: A mutating conversion backed by `extract` and `embed`.
	@inlinable
	public static func inline(
		embed: @escaping (inout Root, Member) -> Void
	) -> Self {
		.init(
			getter: .inline(extract: \.self),
			setter: .inline(embed: embed)
		)
	}
}

extension _MutatingConversions.AnyConversion where Root == Member {
	/// Creates a mutating conversion from inline closures.
	///
	/// - Parameters:
	///   - extract: A closure that extracts a member from a root value.
	///   - embed: A closure that produces a new root from a member.
	/// - Returns: A mutating conversion backed by `extract` and `embed`.
	@inlinable
	public static func inline(
		embed: @escaping (Member) -> Root
	) -> Self {
		.init(
			getter: .inline(extract: \.self),
			setter: .inline(embed: embed)
		)
	}
}

extension _NonMutatingConversions.AnyConversion where Root == Member {
	/// Creates a nonmutating conversion from inline getter and setter closures.
	///
	/// - Parameters:
	///   - extract: A closure that extracts a member from a root value.
	///   - embed: A closure that handles a write without mutating the root in place.
	/// - Returns: A nonmutating conversion backed by `extract` and `embed`.
	@inlinable
	public static func inline(
		embed: @escaping (Root, Member) -> Void
	) -> Self {
		.init(
			getter: .inline(extract: \.self),
			setter: .inline(embed: embed)
		)
	}
}
