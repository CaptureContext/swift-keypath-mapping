// MARK: - Namespaces

public enum _ReadonlyConversions {}
public enum _MutatingConversions {}
public enum _NonMutatingConversions {}

// MARK: - Protocols

extension _ReadonlyConversions {
	public protocol ConversionProtocol<
		Root,
		Member
	>: _Getters.Getter {
		associatedtype Root
		associatedtype Member
	}
}

extension _MutatingConversions {
	public protocol ConversionProtocol<
		Root,
		Member
	>: _Getters.Getter, _MutatingSetters.Setter {
		associatedtype Root
		associatedtype Member
	}
}

extension _NonMutatingConversions {
	public protocol ConversionProtocol<
		Root,
		Member
	>: _Getters.Getter, _NonMutatingSetters.Setter {
		associatedtype Root
		associatedtype Member
	}
}
