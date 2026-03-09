import SwiftMarkerProtocols

extension KeyPathMapper where Value: _OptionalProtocol {
	@available(iOS, deprecated: 9999, message: """
	This subscript has a conversion equivalent that is preferred for autocomplete via this deprecation.
	""")
	@available(macOS, deprecated: 9999, message: """
	This subscript has a conversion equivalent that is preferred for autocomplete via this deprecation.
	""")
	@available(tvOS, deprecated: 9999, message: """
	This subscript has a conversion equivalent that is preferred for autocomplete via this deprecation.
	""")
	@available(watchOS, deprecated: 9999, message: """
	This subscript has a conversion equivalent that is preferred for autocomplete via this deprecation.
	""")
	@available(visionOS, deprecated: 9999, message: """
	This subscript has a conversion equivalent that is preferred for autocomplete via this deprecation.
	""")
	public subscript(
		unwrappedWith defaultValue: Value.Wrapped,
		aggressive aggressive: Bool = false
	) -> KeyPathMapper<Value.Wrapped> {
		get { .init(self.value._optional ?? defaultValue) }
		set {
			if aggressive || self.value._optional != nil {
				self.value._optional = newValue.value
			}
		}
	}
}
