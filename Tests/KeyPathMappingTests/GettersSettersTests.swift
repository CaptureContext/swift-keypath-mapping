import Testing
@testable import KeyPathMapping

@Suite
struct GettersSettersTests {
	@Test
	func performRunsHooksAroundWrite() async throws {
		var sut = 0
		var events: [String] = []

		sut[setter: .perform(
			onWillSet: { newValue in events.append("will:\(newValue)") },
			onDidSet: { newValue in events.append("did:\(newValue)") }
		)] = 5

		#expect(sut == 5)
		#expect(events == ["will:5", "did:5"])
	}

	@Test
	func performWithRootCallbacksObservesRootLifecycle() async throws {
		var sut = 1
		var events: [String] = []

		sut[setter: .perform(
			onWillSet: { root, newValue in events.append("will:\(root)->\(newValue)") },
			onDidSet: { root, newValue in events.append("did:\(root)->\(newValue)") }
		)] = 3

		#expect(sut == 3)
		#expect(events == ["will:1->3", "did:3->3"])
	}

	@Test
	func onWillSetRunsBeforeWrite() async throws {
		var sut = 10
		var observed: [(Int, Int)] = []

		sut[setter: .onWillSet { root, newValue in
			observed.append((root, newValue))
		}] = 20

		#expect(sut == 20)
		#expect(observed.count == 1)
		#expect(observed[0].0 == 10)
		#expect(observed[0].1 == 20)
	}

	@Test
	func onDidSetRunsAfterWrite() async throws {
		var sut = 10
		var observed: [(Int, Int)] = []

		sut[setter: .onDidSet { root, newValue in
			observed.append((root, newValue))
		}] = 20

		#expect(sut == 20)
		#expect(observed.count == 1)
		#expect(observed[0].0 == 20)
		#expect(observed[0].1 == 20)
	}
}
