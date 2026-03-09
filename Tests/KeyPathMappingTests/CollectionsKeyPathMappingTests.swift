import Testing
@testable import KeyPathMapping

#if swift(<6.1) || PredefinedConversions
@Suite
struct CollectionsKeyPathMappingTests {
	@Test
	func unsafeIndex() async throws {
		var array: [Int] = [0, 1, 2, 3]

		do {
			let element = array[map: .unsafeIndex(0)]
			#expect(type(of: element) == Int.self)
			#expect(element == 0)
		}

		do {
			array[convert: .unsafeIndex(0)] = 1
			#expect(array == [1, 1, 2, 3])
		}
	}

	@Test
	func safeIndex() async throws {
		var array: [Int] = [0, 1, 2, 3]
		
		do {
			let element = array[map: .safeIndex(0)]
			#expect(type(of: element) == Int?.self)
			#expect(element == 0)
		}

		do {
			array[convert: .safeIndex(0)] = nil
			#expect(array == [0, 1, 2, 3])
		}

		do {
			array[convert: .safeIndex(-1)] = 1
			#expect(array == [0, 1, 2, 3])
		}

		do {
			array[convert: .safeIndex(0)] = 1
			#expect(array == [1, 1, 2, 3])
		}
	}
}
#endif
