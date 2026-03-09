# swift-keypath-mapping

[![CI](https://github.com/capturecontext/swift-keypath-mapping/actions/workflows/ci.yml/badge.svg)](https://github.com/capturecontext/swift-keypath-mapping/actions/workflows/ci.yml) [![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2FCaptureContext%2Fswift-keypath-mapping%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/capturecontext/swift-keypath-mapping) [![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2FCaptureContext%2Fswift-keypath-mapping%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/CaptureContext/swift-keypath-mapping)

Composable keypath mapping for Swift values. This package centers around `KeyPathMapper`, `KeyPathMappable`, and reusable conversions for optionals, collections, and numeric types. If you need key paths for enums, take a look at [`pointfreeco/swift-case-paths`](https://github.com/pointfreeco/swift-case-paths).

## Table of contents

- [Motivation](#motivation)
- [The Problem](#the-problem)
- [Usage](#usage)
  - [Custom Conversions](#custom-conversions)
  - [Getters And Setters](#getters-and-setters)
  - [Predefined Conversions](#predefined-conversions)
- [Installation](#installation)
- [License](#license)

## Motivation

Swift key paths are powerful, but their composability breaks down in two common scenarios:
- when values need to be *derived* while preserving identity (e.g. SwiftUI bindings),
- and when optionality prevents paths from being composed or written to.

This package provides focused utilities that address these limitations while staying within Swift’s type system.

## The Problem

#### 1. Derived bindings lose identity

> [!NOTE]
>
> [**Why it's a bad idea to use Binding.init(get:set:)**](https://chris.eidhof.nl/post/binding-with-get-set)
>
> _Link source: https://t.me/contravariance_

In SwiftUI, it’s common to derive a value from state:

```swift
struct Example: View {
  @State 
  private var value: Float = 0

  var body: some View {
    Slider(value: Binding(
      get: { Double(value) },
      set: { value = Float($0) }
    ))
  }
}
```

This works functionally, but it breaks SwiftUI’s diffing model.

Bindings created with `Binding(get:set:)` are opaque and not `Hashable`, which prevents SwiftUI from reliably detecting derived changes.

A common workaround is to define computed properties on types:

```swift
extension BinaryFloatingPoint {
  var double: Double {
    get { Double(self) }
    set { self = .init(newValue) }
  }
}
```

Such extensions lead to one of the following trade-offs:
- `private extension` makes such helpers non-reusable
- `public extension` causes namespace pollution for extended type

Swift has no built-in concept for expressing such transformations *outside* the type they operate on.


#### 2. Optional key paths cannot be composed freely

Swift supports optional chaining in key paths:

```swift
let kp: KeyPath<Root, Int?> = \Root.optionalProperty?.value
```

However, once optionality is involved, many useful operations become unavailable.

For example, combining key paths manually is not possible:

```swift
let kp1: KeyPath<Root, Property?> = \Root.optionalProperty
let kp2: KeyPath<Property, Int> = \Property.value

// ❌ Not available in Swift
let combined = kp1.appending(path: kp2)
```

Even though this assignment is valid at runtime:

```swift
root.optionalProperty?.value = 0
```

#### 3. Optionality breaks writability

Optional chaining also prevents writable key paths from being formed:

```swift
// ❌ Cannot convert KeyPath<Root, Int?> to WritableKeyPath<Root, Int?>
let kp: WritableKeyPath<Root, Int?> = \Root.optionalProperty?.value
```

As a result, APIs that rely on WritableKeyPath cannot be used, even when the underlying mutation is safe and well-defined.

There is no standard way to:

- lift a non-optional key path into an optional context,
- unwrap an optional key path with a default value,
- or restore writability across optional boundaries.

## Usage

`KeyPathMapper` is the namespace for declaring reusable mappings.

Mappings can be applied to `KeyPathMappable` types. Custom types can conform to `KeyPathMappable` to enable mapping APIs directly. Helpers for some standard types are available out of the box:

- `Optional`
- `Result`
- `Array`
- `Dictionary`
- `Set`
- `Equatable`

Mappings are applied using

- `[mapPath:]` - Mapping using KeyPaths through `KeyPathMapper` type
-  `[map:]` - Application of `ReadonlyConversion`
-  `[getter:]` - Application of `Getter` transform
-  `[setter:]` - Application of `Setter` transform (requires `Root` and `Member` to be equivalent)
-  `[getter:setter:]` - Application of `Getter` and `Setter` transforms
- `[convert:]` - Application of `Mutating`/`NonMutating` conversions

### Custom Conversions

The primary way to declare a reusable conversion is by extending one of the conversion namespaces:

```swift
import KeyPathMapping

extension KeyPathMapper.MutatingConversionTo
where Root: BinaryFloatingPoint {
  static func to<T: BinaryFloatingPoint>(_ type: T.Type) -> Self
  where Member == T {
    .inline(
      extract: { T($0) },
      embed: { Root($0) }
    )
  }
}
```

The same pattern works for read-only and nonmutating conversions:

```swift
import KeyPathMapping

extension KeyPathMapper.ReadonlyConversionTo
where Member == Bool {
	func contains(_ element: Root.Element) -> Self
	where Root: SetAlgebra {
		.inline(extract: { $0.contains(element) })
	}
}
```

And then apply them through the mapper:

```swift
import KeyPathMapping

struct ExampleView: View {
  @State
  private var value: Float = 0
  
  var body: some View {
    // OtherView accepts Binding<Double>.
    OtherView(value: $value[
      convert: .to(Double.self)
    ])
  }
}
```

### Getters And Setters

Getters and setters are useful when you want custom read/write behavior without defining a full conversion type.

This is especially handy for attaching side effects to writes, for example adding haptic feedback to a SwiftUI binding:

```swift
import KeyPathMapping
import SwiftUI

struct ExampleView: View {
  @State
  private var value: Double = 0
  
  var body: some View {
    Slider(
      value: $value[
        setter: .onDidSet { newValue in
          if newValue > 0.8 {
            Haptics.shared.impact()
          }
        }
      ]
    )
  }
}
```

There are a few useful setter helpers for root-preserving writes:

```swift
// Replace the root and run hooks around the write.
[setter: .perform(onWillSet: { _ in }, onDidSet: { _ in })]

// Run a side effect before writing.
[setter: .onWillSet { newValue in }]

// Run a side effect after writing.
[setter: .onDidSet { newValue in }]
```

Getters and setters can also be paired directly:

```swift
// Read one shape, write through another behavior.
[getter: .inline { ... }), setter: .inline { ... })]
```

### Predefined Conversions

The package also ships with a focused set of predefined conversions:

#### Common

```swift
// Lifts a value into an optional.
.optional
```

#### Collection

```swift
// Access an element by index safely.
.safeIndex(<#index#>)

// Access an element by index directly.
.unsafeIndex(<#index#>)
```

#### Optional

```swift
// Unwrap an optional with a default value.
// Writes are ignored for nil roots by default.
// Use `agressive` to allow nil-replacing
.unwrapped(with: <#defaultValue#>, aggressive: <#Bool#> = false)
```

#### BinaryNumeric

```swift
// Convert the value to the specified numeric type.
.to(<#BinaryNumericType#>.self)
```

> [!Important]
>
> _From `Swift 6.1` you'll need to explicitly specify `PredefinedConversions` trait to include predefined conversions into your build._

## Installation

### Basic

You can add `swift-keypath-mapping` to an Xcode project by adding it as a package dependency.

1. From the **File** menu, select **Swift Packages › Add Package Dependency…**
2. Enter [`"https://github.com/capturecontext/swift-keypath-mapping"`](https://github.com/capturecontext/swift-keypath-mapping) into the package repository URL text field
3. Choose products you need to link to your project.

### Recommended

If you use SwiftPM for your project structure, add `swift-keypath-mapping` dependency to your package file

```swift
.package(
  url: "https://github.com/capturecontext/swift-keypath-mapping.git",
  .upToNextMinor(from: "0.0.1"),
  traits: ["PredefinedConversions"] // optional
)
```

Do not forget about target dependencies

```swift
.product(
  name: "KeyPathMapping",
  package: "swift-keypath-mapping"
)
```

## License

This library is released under the MIT license. See [LICENSE](LICENSE) for details.
