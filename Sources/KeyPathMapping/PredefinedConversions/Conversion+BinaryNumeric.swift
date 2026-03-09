#if swift(<6.1) || PredefinedConversions
extension _MutatingConversions.AnyConversion
where Root: BinaryFloatingPoint {
	/// Converts between floating-point numeric types.
	///
	/// ```swift
	/// var value: Double = 1.5
	/// let mapped = value[convert: .to(Float.self)]
	/// ```
	///
	/// - Parameters:
	///   - type: The target numeric type.
	public static func to(_ type: Member.Type = Member.self) -> Self
	where Member: BinaryFloatingPoint {
		.inline(
			extract: { Member($0) },
			embed: { Root($0) }
		)
	}

	/// Converts from a floating-point root to an integer member.
	///
	/// - Parameters:
	///   - type: The target numeric type.
	public static func to(_ type: Member.Type = Member.self) -> Self
	where Member: BinaryInteger {
		.inline(
			extract: { Member($0) },
			embed: { Root($0) }
		)
	}
}

extension _MutatingConversions.AnyConversion
where Root: BinaryInteger {
	/// Converts from an integer root to a floating-point member.
	///
	/// - Parameters:
	///   - type: The target numeric type.
	public static func to(_ type: Member.Type = Member.self) -> Self
	where Member: BinaryFloatingPoint {
		.inline(
			extract: { Member($0) },
			embed: { Root($0) }
		)
	}

	/// Converts between integer numeric types.
	///
	/// ```swift
	/// var value: Int = 42
	/// value[convert: .to(Int8.self)] = 12
	/// value // 12
	/// ```
	///
	/// - Parameters:
	///   - type: The target numeric type.
	public static func to(_ type: Member.Type = Member.self) -> Self
	where Member: BinaryInteger {
		.inline(
			extract: { Member($0) },
			embed: { Root($0) }
		)
	}
}
#endif
