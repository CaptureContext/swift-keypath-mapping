extension _Getters {
	public struct Inline<
		Root,
		Member
	>: Getter {
		@inlinable
		public static func == (lhs: Self, rhs: Self) -> Bool {
			lhs.id._swift_keypath_mapper_isEqual(to: rhs.id)
		}

		@usableFromInline
		let id: (any Hashable)

		@usableFromInline
		let _extract: (Root) -> Member

		public init(
			id: (any Hashable) = ObjectIdentifier(Self.self),
			extract: @escaping (Root) -> Member
		) {
			self.id = id
			self._extract = extract
		}

		@inlinable
		public func extract(from root: Root) -> Member {
			self._extract(root)
		}

		@inlinable
		public func hash(into hasher: inout Hasher) {
			id.hash(into: &hasher)
		}
	}
}

extension _MutatingSetters {
	public struct Inline<
		Root,
		Member
	>: Setter {
		@inlinable
		public static func == (lhs: Self, rhs: Self) -> Bool {
			lhs.id._swift_keypath_mapper_isEqual(to: rhs.id)
		}

		@usableFromInline
		let id: (any Hashable)

		@usableFromInline
		let _embed: (inout Root, Member) -> Void

		public init(
			id: (any Hashable) = ObjectIdentifier(Self.self),
			embed: @escaping (inout Root, Member) -> Void
		) {
			self.id = id
			self._embed = embed
		}

		@inlinable
		public func embed(_ member: Member, in root: inout Root) {
			self._embed(&root, member)
		}

		@inlinable
		public func hash(into hasher: inout Hasher) {
			id.hash(into: &hasher)
		}
	}
}

extension _NonMutatingSetters {
	public struct Inline<
		Root,
		Member
	>: Setter {
		@inlinable
		public static func == (lhs: Self, rhs: Self) -> Bool {
			lhs.id._swift_keypath_mapper_isEqual(to: rhs.id)
		}

		@usableFromInline
		let id: (any Hashable)

		@usableFromInline
		let _embed: (Root, Member) -> Void

		public init(
			id: (any Hashable) = ObjectIdentifier(Self.self),
			embed: @escaping (Root, Member) -> Void
		) {
			self.id = id
			self._embed = embed
		}

		@inlinable
		public func embed(_ member: Member, in root: Root) {
			self._embed(root, member)
		}

		@inlinable
		public func hash(into hasher: inout Hasher) {
			id.hash(into: &hasher)
		}
	}
}
