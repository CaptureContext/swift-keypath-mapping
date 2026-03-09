extension Equatable {
	@usableFromInline
	func _swift_keypath_mapper_isEqual(
		to other: any Equatable
	) -> Bool {
		guard let other = other as? Self else { return false }
		return self == other
	}
}
