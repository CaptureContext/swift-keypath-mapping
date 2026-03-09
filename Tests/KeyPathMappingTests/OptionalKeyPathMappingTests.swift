import Testing
@testable import KeyPathMapping

#if swift(<6.1) || PredefinedConversions
@Suite
struct OptionalKeyPathMappingTests {
	@Test
	func testOptional() async throws {
		let sut: Int = 0

		#expect(type(of: sut[mapPath: \.optional]) == Int?.self)
		#expect(sut == sut[convert: .optional])
	}

	@Test
	func testUnwrapping() async throws {
		do { // non-aggessive
			var sut: Int? = nil

			// getter gets unwrapped
			#expect(sut[convert: .unwrapped(with: 0)] == 0)
			#expect(sut[convert: .unwrapped(with: 0, aggressive: false)] == 0)

			// won't update nil value
			sut[convert: .unwrapped(with: 0, aggressive: false)] += 1
			#expect(sut == nil)

			// won't update nil value
			sut[convert: .unwrapped(with: 0, aggressive: false)] = 1
			#expect(sut == nil)

			// won't update nil value
			sut[convert: .unwrapped(with: 0)] = 1
			#expect(sut == nil)
		}

		do { // aggessive
			var sut: Int? = nil

			// getter gets unwrapped
			#expect(sut[convert: .unwrapped(with: 0)] == 0)
			#expect(sut[convert: .unwrapped(with: 0, aggressive: true)] == 0)

			// will update nil value
			sut[convert: .unwrapped(with: 0, aggressive: true)] += 1
			#expect(sut == 1)

			// will update nil value
			sut[convert: .unwrapped(with: 0, aggressive: true)] = 2
			#expect(sut == 2)
		}
	}
}
#endif
