extension _ReadonlyConversions {
	public struct Conversion<Getter: _Getters.Getter>: ConversionProtocol {
		public typealias Root = Getter.Root
		public typealias Member = Getter.Member

		@usableFromInline
		var getter: Getter

		public init(getter: Getter) {
			self.getter = getter
		}

		@inlinable
		public func extract(from root: Root) -> Member {
			getter.extract(from: root)
		}
	}
}

extension _MutatingConversions {
	public struct Conversion<
		Getter: _Getters.Getter,
		Setter: _MutatingSetters.Setter
	>: ConversionProtocol where
		Getter.Member == Setter.Member,
		Getter.Root == Setter.Root
	{
		public typealias Root = Getter.Root
		public typealias Member = Getter.Member

		@usableFromInline
		var getter: Getter

		@usableFromInline
		var setter: Setter

		public init(
			getter: Getter,
			setter: Setter,
		) {
			self.getter = getter
			self.setter = setter
		}

		@inlinable
		public func extract(from root: Root) -> Member {
			getter.extract(from: root)
		}

		@inlinable
		public func embed(_ member: Member, in root: inout Root) {
			setter.embed(member, in: &root)
		}
	}
}

extension _NonMutatingConversions {
	public struct Conversion<
		Getter: _Getters.Getter,
		Setter: _NonMutatingSetters.Setter
	>: ConversionProtocol where
		Getter.Member == Setter.Member,
		Getter.Root == Setter.Root
	{
		public typealias Root = Getter.Root
		public typealias Member = Getter.Member

		@usableFromInline
		var getter: Getter

		@usableFromInline
		var setter: Setter

		public init(
			getter: Getter,
			setter: Setter,
		) {
			self.getter = getter
			self.setter = setter
		}

		@inlinable
		public func extract(from root: Root) -> Member {
			getter.extract(from: root)
		}

		@inlinable
		public func embed(_ member: Member, in root: Root) {
			setter.embed(member, in: root)
		}
	}
}
