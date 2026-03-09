import Foundation

extension KeyPathMapper where Value: Collection {
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
	@inlinable
	public subscript(unsafeIndex index: Value.Index) -> KeyPathMapper<Value.Element> {
		get { .init(self.value[index]) }
	}

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
	@inlinable
	public subscript(safeIndex index: Value.Index) -> KeyPathMapper<Value.Element?> {
		get {
			guard self.value.indices.contains(index)
			else { return .init(nil) }

			return .init(self.value[index])
		}
	}
}

extension KeyPathMapper where Value: MutableCollection {
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
	@inlinable
	public subscript(unsafeIndex index: Value.Index) -> KeyPathMapper<Value.Element> {
		get { .init(self.value[index]) }
		set { self.value[index] = newValue.value }
	}

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
	@inlinable
	public subscript(safeIndex index: Value.Index) -> KeyPathMapper<Value.Element?> {
		get {
			guard self.value.indices.contains(index)
			else { return .init(nil) }

			return .init(self.value[index])
		}
		set {
			guard
				let value = newValue.value,
				self.value.indices.contains(index)
			else { return }

			self.value[index] = value
		}
	}
}
