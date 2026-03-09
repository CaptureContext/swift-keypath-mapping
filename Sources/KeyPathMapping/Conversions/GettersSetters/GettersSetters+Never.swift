extension _Getters {
	public struct Never<Root, Member>: Getter {
		public static func == (lhs: Self, rhs: Self) -> Bool {
			(lhs.message, lhs.file.description, lhs.line)
			== (rhs.message, rhs.file.description, rhs.line)
		}
		
		@usableFromInline
		let message: String?

		@usableFromInline
		let file: StaticString

		@usableFromInline
		let line: UInt

		public init(
			message: String? = nil,
			file: StaticString = #file,
			line: UInt = #line
		) {
			self.message = message
			self.file = file
			self.line = line
		}

		@inlinable
		public func extract(from root: Root) -> Member {
			fatalError(
				message ?? """
				This getter should've never been called.
				""",
				file: file,
				line: line
			)
		}

		@inlinable
		public func hash(into hasher: inout Hasher) {
			message.hash(into: &hasher)
			file.description.hash(into: &hasher)
			line.hash(into: &hasher)
		}
	}
}

extension _Getters.AnyGetter {
	@inlinable
	public static func never(
		message: String? = nil,
		file: StaticString = #file,
		line: UInt = #line
	) -> Self {
		return .init(_Getters.Never(
			message: message,
			file: file,
			line: line
		))
	}
}

extension _MutatingSetters {
	public struct Never<Root, Member>: Setter {
		public static func == (lhs: Self, rhs: Self) -> Bool {
			(lhs.message, lhs.file.description, lhs.line)
			== (rhs.message, rhs.file.description, rhs.line)
		}

		@usableFromInline
		let message: String?

		@usableFromInline
		let file: StaticString

		@usableFromInline
		let line: UInt

		public init(
			message: String? = nil,
			file: StaticString = #file,
			line: UInt = #line
		) {
			self.message = message
			self.file = file
			self.line = line
		}

		@inlinable
		public func embed(_ member: Member, in root: inout Root) {
			fatalError(
				message ?? """
				This setter should've never been called.
				""",
				file: file,
				line: line
			)
		}

		@inlinable
		public func hash(into hasher: inout Hasher) {
			message.hash(into: &hasher)
			file.description.hash(into: &hasher)
			line.hash(into: &hasher)
		}
	}
}

extension _MutatingSetters.AnySetter {
	@inlinable
	public static func never(
		message: String? = nil,
		file: StaticString = #file,
		line: UInt = #line
	) -> Self {
		return .init(_MutatingSetters.Never(
			message: message,
			file: file,
			line: line
		))
	}
}

extension _NonMutatingSetters {
	public struct Never<Root, Member>: Setter {
		public static func == (lhs: Self, rhs: Self) -> Bool {
			(lhs.message, lhs.file.description, lhs.line)
			== (rhs.message, rhs.file.description, rhs.line)
		}

		@usableFromInline
		let message: String?

		@usableFromInline
		let file: StaticString

		@usableFromInline
		let line: UInt

		public init(
			message: String? = nil,
			file: StaticString = #file,
			line: UInt = #line
		) {
			self.message = message
			self.file = file
			self.line = line
		}

		@inlinable
		public func embed(_ member: Member, in root: Root) {
			fatalError(
				message ?? """
				This setter should've never been called.
				""",
				file: file,
				line: line
			)
		}

		@inlinable
		public func hash(into hasher: inout Hasher) {
			message.hash(into: &hasher)
			file.description.hash(into: &hasher)
			line.hash(into: &hasher)
		}
	}
}

extension _NonMutatingSetters.AnySetter {
	@inlinable
	public static func never(
		message: String? = nil,
		file: StaticString = #file,
		line: UInt = #line
	) -> Self {
		return .init(_NonMutatingSetters.Never(
			message: message,
			file: file,
			line: line
		))
	}
}
