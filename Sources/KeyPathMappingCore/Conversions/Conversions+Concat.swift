extension _ReadonlyConversions {
	public struct Concat<
		First: ConversionProtocol,
		Second: ConversionProtocol
	>: ConversionProtocol where
		First.Member == Second.Root
	{
		public typealias Root = First.Root
		public typealias Member = Second.Member

		@usableFromInline
		let first: First

		@usableFromInline
		let second: Second

		public init(
			_ first: First,
			_ second: Second
		) {
			self.first = first
			self.second = second
		}

		@inlinable
		public func extract(from root: Root) -> Member {
			second.extract(from: first.extract(from: root))
		}
	}
}

extension _ReadonlyConversions.AnyConversion {
	@inlinable
	public func appending<T>(
		_ other: _ReadonlyConversions.AnyConversion<Member, T>
	) -> _ReadonlyConversions.AnyConversion<Root, T> {
		return .init(_ReadonlyConversions.Concat(
			self,
			other
		))
	}
}

extension _ReadonlyConversions.AnyConversion {
	@inlinable
	public static func concat<T0>(
		_ c0: _ReadonlyConversions.AnyConversion<Root, T0>,
		_ c1: _ReadonlyConversions.AnyConversion<T0, Member>
	) -> Self {
		c0
			.appending(c1)
	}

	@inlinable
	public static func concat<T0, T1>(
		_ c0: _ReadonlyConversions.AnyConversion<Root, T0>,
		_ c1: _ReadonlyConversions.AnyConversion<T0, T1>,
		_ c2: _ReadonlyConversions.AnyConversion<T1, Member>
	) -> Self {
		c0
			.appending(c1)
			.appending(c2)
	}

	@inlinable
	public static func concat<T0, T1, T2>(
		_ c0: _ReadonlyConversions.AnyConversion<Root, T0>,
		_ c1: _ReadonlyConversions.AnyConversion<T0, T1>,
		_ c2: _ReadonlyConversions.AnyConversion<T1, T2>,
		_ c3: _ReadonlyConversions.AnyConversion<T2, Member>
	) -> Self {
		c0
			.appending(c1)
			.appending(c2)
			.appending(c3)
	}

	@inlinable
	public static func concat<T0, T1, T2, T3>(
		_ c0: _ReadonlyConversions.AnyConversion<Root, T0>,
		_ c1: _ReadonlyConversions.AnyConversion<T0, T1>,
		_ c2: _ReadonlyConversions.AnyConversion<T1, T2>,
		_ c3: _ReadonlyConversions.AnyConversion<T2, T3>,
		_ c4: _ReadonlyConversions.AnyConversion<T3, Member>
	) -> Self {
		c0
			.appending(c1)
			.appending(c2)
			.appending(c3)
			.appending(c4)
	}
}

extension _MutatingConversions {
	public struct Concat<
		First: ConversionProtocol,
		Second: ConversionProtocol
	>: ConversionProtocol where
		First.Member == Second.Root
	{
		public typealias Root = First.Root
		public typealias Member = Second.Member

		@usableFromInline
		let first: First

		@usableFromInline
		let second: Second

		public init(
			_ first: First,
			_ second: Second
		) {
			self.first = first
			self.second = second
		}

		@inlinable
		public func extract(from root: Root) -> Member {
			second.extract(from: first.extract(from: root))
		}

		@inlinable
		public func embed(_ member: Member, in root: inout Root) {
			var intermediateRoot: First.Member = first.extract(from: root)
			second.embed(member, in: &intermediateRoot)
			first.embed(intermediateRoot, in: &root)
		}

		@usableFromInline
		func embed(_ member: Second.Member, in root: inout Second.Root) {
			second.embed(member, in: &root)
		}
	}
}

extension _MutatingConversions.AnyConversion {
	@inlinable
	public func appending<T>(
		_ other: _MutatingConversions.AnyConversion<Member, T>
	) -> _MutatingConversions.AnyConversion<Root, T> {
		return .init(_MutatingConversions.Concat(
			self,
			other
		))
	}
}

extension _MutatingConversions.AnyConversion {
	@inlinable
	public static func concat<T0>(
		_ c0: _MutatingConversions.AnyConversion<Root, T0>,
		_ c1: _MutatingConversions.AnyConversion<T0, Member>
	) -> Self {
		c0
			.appending(c1)
	}

	@inlinable
	public static func concat<T0, T1>(
		_ c0: _MutatingConversions.AnyConversion<Root, T0>,
		_ c1: _MutatingConversions.AnyConversion<T0, T1>,
		_ c2: _MutatingConversions.AnyConversion<T1, Member>
	) -> Self {
		c0
			.appending(c1)
			.appending(c2)
	}

	@inlinable
	public static func concat<T0, T1, T2>(
		_ c0: _MutatingConversions.AnyConversion<Root, T0>,
		_ c1: _MutatingConversions.AnyConversion<T0, T1>,
		_ c2: _MutatingConversions.AnyConversion<T1, T2>,
		_ c3: _MutatingConversions.AnyConversion<T2, Member>
	) -> Self {
		c0
			.appending(c1)
			.appending(c2)
			.appending(c3)
	}

	@inlinable
	public static func concat<T0, T1, T2, T3>(
		_ c0: _MutatingConversions.AnyConversion<Root, T0>,
		_ c1: _MutatingConversions.AnyConversion<T0, T1>,
		_ c2: _MutatingConversions.AnyConversion<T1, T2>,
		_ c3: _MutatingConversions.AnyConversion<T2, T3>,
		_ c4: _MutatingConversions.AnyConversion<T3, Member>
	) -> Self {
		c0
			.appending(c1)
			.appending(c2)
			.appending(c3)
			.appending(c4)
	}
}

extension _NonMutatingConversions {
	public struct Concat<
		First: ConversionProtocol,
		Second: ConversionProtocol
	>: ConversionProtocol where
		First.Member == Second.Root
	{
		public typealias Root = First.Root
		public typealias Member = Second.Member

		@usableFromInline
		let first: First

		@usableFromInline
		let second: Second

		public init(
			_ first: First,
			_ second: Second
		) {
			self.first = first
			self.second = second
		}

		@inlinable
		public func extract(from root: Root) -> Member {
			second.extract(from: first.extract(from: root))
		}

		@inlinable
		public func embed(_ member: Member, in root: Root) {
			let intermediateRoot: First.Member = first.extract(from: root)
			second.embed(member, in: intermediateRoot)
			first.embed(intermediateRoot, in: root)
		}
	}
}

extension _NonMutatingConversions.AnyConversion {
	@inlinable
	public func appending<T>(
		_ other: _NonMutatingConversions.AnyConversion<Member, T>
	) -> _NonMutatingConversions.AnyConversion<Root, T> {
		return .init(_NonMutatingConversions.Concat(
			self,
			other
		))
	}
}

extension _NonMutatingConversions.AnyConversion {
	@inlinable
	public static func concat<T0>(
		_ c0: _NonMutatingConversions.AnyConversion<Root, T0>,
		_ c1: _NonMutatingConversions.AnyConversion<T0, Member>
	) -> Self {
		c0
			.appending(c1)
	}

	@inlinable
	public static func concat<T0, T1>(
		_ c0: _NonMutatingConversions.AnyConversion<Root, T0>,
		_ c1: _NonMutatingConversions.AnyConversion<T0, T1>,
		_ c2: _NonMutatingConversions.AnyConversion<T1, Member>
	) -> Self {
		c0
			.appending(c1)
			.appending(c2)
	}

	@inlinable
	public static func concat<T0, T1, T2>(
		_ c0: _NonMutatingConversions.AnyConversion<Root, T0>,
		_ c1: _NonMutatingConversions.AnyConversion<T0, T1>,
		_ c2: _NonMutatingConversions.AnyConversion<T1, T2>,
		_ c3: _NonMutatingConversions.AnyConversion<T2, Member>
	) -> Self {
		c0
			.appending(c1)
			.appending(c2)
			.appending(c3)
	}

	@inlinable
	public static func concat<T0, T1, T2, T3>(
		_ c0: _NonMutatingConversions.AnyConversion<Root, T0>,
		_ c1: _NonMutatingConversions.AnyConversion<T0, T1>,
		_ c2: _NonMutatingConversions.AnyConversion<T1, T2>,
		_ c3: _NonMutatingConversions.AnyConversion<T2, T3>,
		_ c4: _NonMutatingConversions.AnyConversion<T3, Member>
	) -> Self {
		c0
			.appending(c1)
			.appending(c2)
			.appending(c3)
			.appending(c4)
	}
}
