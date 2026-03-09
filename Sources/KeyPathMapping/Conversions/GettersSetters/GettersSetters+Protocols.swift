// MARK: - Namespaces

@available(iOS, deprecated: 9999, message: """
This namespace is not actually deprecated, but intended for internal use. \
Deprecation lowers autocomplete priority.
""")
@available(macOS, deprecated: 9999, message: """
This namespace is not actually deprecated, but intended for internal use. \
Deprecation lowers autocomplete priority.
""")
@available(tvOS, deprecated: 9999, message: """
This namespace is not actually deprecated, but intended for internal use. \
Deprecation lowers autocomplete priority.
""")
@available(watchOS, deprecated: 9999, message: """
This namespace is not actually deprecated, but intended for internal use. \
Deprecation lowers autocomplete priority.
""")
@available(visionOS, deprecated: 9999, message: """
This namespace is not actually deprecated, but intended for internal use. \
Deprecation lowers autocomplete priority.
""")
public enum _Getters {}

@available(iOS, deprecated: 9999, message: """
This namespace is not actually deprecated, but intended for internal use. \
Deprecation lowers autocomplete priority.
""")
@available(macOS, deprecated: 9999, message: """
This namespace is not actually deprecated, but intended for internal use. \
Deprecation lowers autocomplete priority.
""")
@available(tvOS, deprecated: 9999, message: """
This namespace is not actually deprecated, but intended for internal use. \
Deprecation lowers autocomplete priority.
""")
@available(watchOS, deprecated: 9999, message: """
This namespace is not actually deprecated, but intended for internal use. \
Deprecation lowers autocomplete priority.
""")
@available(visionOS, deprecated: 9999, message: """
This namespace is not actually deprecated, but intended for internal use. \
Deprecation lowers autocomplete priority.
""")
public enum _MutatingSetters {}

@available(iOS, deprecated: 9999, message: """
This namespace is not actually deprecated, but intended for internal use. \
Deprecation lowers autocomplete priority.
""")
@available(macOS, deprecated: 9999, message: """
This namespace is not actually deprecated, but intended for internal use. \
Deprecation lowers autocomplete priority.
""")
@available(tvOS, deprecated: 9999, message: """
This namespace is not actually deprecated, but intended for internal use. \
Deprecation lowers autocomplete priority.
""")
@available(watchOS, deprecated: 9999, message: """
This namespace is not actually deprecated, but intended for internal use. \
Deprecation lowers autocomplete priority.
""")
@available(visionOS, deprecated: 9999, message: """
This namespace is not actually deprecated, but intended for internal use. \
Deprecation lowers autocomplete priority.
""")
public enum _NonMutatingSetters {}

// MARK: - Protocols

extension _Getters {
	public protocol Getter<Root, Member>: Hashable {
		associatedtype Root
		associatedtype Member
		func extract(from root: Root) -> Member
	}
}

extension _MutatingSetters {
	public protocol Setter<Root, Member>: Hashable {
		associatedtype Root
		associatedtype Member
		func embed(_ member: Member, in root: inout Root)
	}
}

extension _NonMutatingSetters {
	public protocol Setter<Root, Member>: Hashable {
		associatedtype Root
		associatedtype Member
		func embed(_ member: Member, in root: Root)
	}
}
