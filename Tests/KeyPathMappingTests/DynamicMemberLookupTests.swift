import Testing
@testable import KeyPathMapping

#if swift(<6.1) || PredefinedConversions
@Suite
struct DynamicMemberLookupTests {
	@propertyWrapper
	@dynamicMemberLookup
	struct BindingAPI<Value> {
		var getter: () -> Value
		var setter: (Value) -> Void

		var wrappedValue: Value {
			get { getter() }
			nonmutating set { setter(newValue) }
		}

		private class Box {
			var value: Value
			init(_ value: Value) { self.value = value }
		}

		init(wrappedValue: Value) {
			let box = Box(wrappedValue)
			self.init(get: { box.value }, set: { box.value = $0 })
		}

		init(
			get getter: @escaping () -> Value,
			set setter: @escaping (Value) -> Void
		) {
			self.getter = getter
			self.setter = setter
		}

		var projectedValue: BindingAPI<Value> { self }

		subscript<LocalValue>(
			dynamicMember keyPath: WritableKeyPath<Value, LocalValue>
		) -> BindingAPI<LocalValue> {
			BindingAPI<LocalValue>(
				get: { self.getter()[keyPath: keyPath] },
				set: {
					self.wrappedValue[keyPath: keyPath] = $0
				}
			)
		}
	}

	struct ExampleSUT: KeyPathMappable {
		var nested: NestedType = .init()

		struct NestedType {
			var values: [Int] = [1, 2, 3]
		}
	}

	@Test
	func defaultTest() async throws {
		@BindingAPI
		var sut = ExampleSUT()

		// Basic dynamicMemberLookup
		let valuesBinding = $sut.nested.values

		// Conversions' dynamicMemberLookup + composition
		let firstIntValueBinding: BindingAPI<Int> = valuesBinding[
			convert: .concat(
				.safeIndex(0),
				.unwrapped(with: 0)
			)
		]

		// Conversions' dynamicMemberLookup
		let firstFloatValueBinding = firstIntValueBinding[convert: .to(Float.self)]

		// Conversions' helper method (declared at the bottom of the file)
		let firstDoubleValueBinding = firstIntValueBinding.applyConversion(.to(Double.self))

		#expect(sut.nested.values == [1, 2, 3])

		firstFloatValueBinding.wrappedValue = 0
		#expect(sut.nested.values == [0, 2, 3])

		firstIntValueBinding.wrappedValue = 1
		#expect(sut.nested.values == [1, 2, 3])

		firstDoubleValueBinding.wrappedValue = 2
		#expect(sut.nested.values == [2, 2, 3])
		#expect(firstIntValueBinding.wrappedValue == 2)
		#expect(firstFloatValueBinding.wrappedValue == 2)
	}
}

extension DynamicMemberLookupTests.BindingAPI where Value: Equatable {
	func applyConversion<T>(
		_ conversion: _MutatingConversions.AnyConversion<Value, T>
	) -> DynamicMemberLookupTests.BindingAPI<T> {
		self[convert: conversion]
	}
}
#endif
