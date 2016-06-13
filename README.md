#TableKit

<p align="left">
<a href="https://travis-ci.org/maxsokolov/TableKit"><img src="https://api.travis-ci.org/maxsokolov/TableKit.svg" alt="Build Status" /></a>
<a href="https://developer.apple.com/swift"><img src="https://img.shields.io/badge/Swift_2.2-compatible-4BC51D.svg?style=flat" alt="Swift 2.2 compatible" /></a>
<img src="https://img.shields.io/badge/platform-iOS-blue.svg?style=flat" alt="Platform iOS" />
<a href="https://cocoapods.org/pods/tablekit"><img src="https://img.shields.io/badge/pod-0.7.0-blue.svg" alt="CocoaPods compatible" /></a>
<a href="https://raw.githubusercontent.com/maxsokolov/tablekit/master/LICENSE"><img src="http://img.shields.io/badge/license-MIT-blue.svg?style=flat" alt="License: MIT" /></a>
</p>

TableKit is a super lightweight yet powerful generic library that allows you to build complex table views in a declarative type-safe manner.
It hides a complexity of `UITableViewDataSource` and `UITableViewDelegate` methods behind the scene, so your code will be look clean, easy to read and nice to maintain.

## Features

- [x] Type-safe cells based on generics
- [x] The easiest way to map your models or view models to cells
- [x] Correctly handles autolayout cells with multiline labels
- [x] Chainable cell actions (select/deselect etc.)
- [x] Support cells created from code, xib, or storyboard
- [x] Automatic xib/classes registration
- [x] No need to subclass
- [x] Extensibility
- [x] Tests

## Usage

Create your rows:
```swift
let row1 = TableRow<String, StringTableViewCell>(item: "1")
let row2 = TableRow<String, IntTableViewCell>(item: 2)
let row3 = TableRow<String, FloatTableViewCell>(item: 3.0)
```
Put rows into section:
```swift
let section = TableSection(rows: [row1, row2, row3])
```
And setup your table:
```swift
let tableDirector = TableDirector(tableView: tableView)
tableDirector += section
```
Done. Your table is ready. You may want to look at your cell. It has to conform to `ConfigurableCell` protocol:
```swift
class StringTableViewCell: UITableViewCell, ConfigurableCell {

	typealias T = String

	func configure(string: T) {
		titleLabel.text = string
	}

	static func estimatedHeight() -> CGFloat {
        return 44
    }
}
```
You could have as many rows and sections as you need.

## Row actions

It nice to have some actions that related to your cells:
```swift
let action = TableRowAction<String, StringTableViewCell>(.click) { (data) in

}

let row = TableRow<String, StringTableViewCell>(item: "some", actions: [action])
```
Or, using nice chaining approach:
```swift
let row = TableRow<String, StringTableViewCell>(item: "some")

row
	.addAction(TableRowAction(.click) { (data) in
	
	})
	.addAction(TableRowAction(.shouldHighlight) { (data) -> Bool in
		return false
	})
```

## Batch rows
You could have a situation when you need a lot of cells with the same type. In that case it's better to use `TableRowBuilder`:
```swift
let builder = TableRowBuilder<String, StringTableViewCell> {

	// do some additional setup here
	$0.items = ["1", "2", "3"]
	$0.actions = [action]
}

section.append(builder: builder)
```
Or if you don't need an additional setup for your data, just use standart init:
```swift
let builder = TableRowBuilder<String, StringTableViewCell>(items: ["1", "2", "3"], actions: [actions])

section.append(builder: builder)
```

## Installation

#### CocoaPods
To integrate TableKit into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'
use_frameworks!

pod 'TableKit'
```
#### Carthage
Add the line `github "maxsokolov/tablekit"` to your `Cartfile`

## Requirements

- iOS 8.0+
- Xcode 7.0+

## License

TableKit is available under the MIT license. See LICENSE for details.