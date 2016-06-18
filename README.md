#TableKit

<p align="left">
	<a href="https://travis-ci.org/maxsokolov/TableKit"><img src="https://api.travis-ci.org/maxsokolov/TableKit.svg" alt="Build Status" /></a>
	<a href="https://developer.apple.com/swift"><img src="https://img.shields.io/badge/Swift_2.2-compatible-4BC51D.svg?style=flat" alt="Swift 2.2 compatible" /></a>
	<a href="https://github.com/Carthage/Carthage"><img src="https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat" alt="Carthage compatible" /></a>
	<a href="https://cocoapods.org/pods/tablekit"><img src="https://img.shields.io/badge/pod-0.7.0-blue.svg" alt="CocoaPods compatible" /></a>
	<img src="https://img.shields.io/badge/platform-iOS-blue.svg?style=flat" alt="Platform iOS" />
	<a href="https://raw.githubusercontent.com/maxsokolov/tablekit/master/LICENSE"><img src="http://img.shields.io/badge/license-MIT-blue.svg?style=flat" alt="License: MIT" /></a>
</p>

TableKit is a super lightweight yet powerful generic library that allows you to build complex table views in a declarative type-safe manner.
It hides a complexity of `UITableViewDataSource` and `UITableViewDelegate` methods behind the scene, so your code will be look clean, easy to read and nice to maintain.

## Features

- [x] Type-safe generic cells
- [x] Functional programming style friendly
- [x] The easiest way to map your models or view models to cells
- [x] Correctly handles autolayout cells with multiline labels
- [x] Chainable cell actions (select/deselect etc.)
- [x] Support cells created from code, xib, or storyboard
- [x] Support different cells height calculation strategies
- [x] Support portrait and landscape orientations
- [x] No need to subclass
- [x] Extensibility

## Getting Started

An example app is included demonstrating TableKit's functionality.

#### Basic usage

Create your rows:
```swift
let row1 = TableRow<String, StringTableViewCell>(item: "1")
let row2 = TableRow<Int, IntTableViewCell>(item: 2)
let row3 = TableRow<Float, FloatTableViewCell>(item: 3.0)
```
Put rows into section:
```swift
let section = TableSection(rows: [row1, row2, row3])
```
And setup your table:
```swift
let tableDirector = TableDirector(tableView: tableView)
tableDirector.register(StringTableViewCell.self, IntTableViewCell.self, FloatTableViewCell.self)
tableDirector += section
```
Done. Your table is ready. You may want to look at your cell. It has to conform to `ConfigurableCell` protocol:
```swift
class StringTableViewCell: UITableViewCell, ConfigurableCell {

	typealias T = String

	func configure(string: T, isPrototype: Bool) {
		titleLabel.text = string
	}

	static func estimatedHeight() -> CGFloat {
        return 44
    }
}
```
You could have as many rows and sections as you need.

#### Row actions

It nice to have some actions that related to your cells:
```swift
let action = TableRowAction<String, StringTableViewCell>(.click) { (data) in

	// you could access any useful information that relates to the action

	// data.cell - StringTableViewCell?
	// data.item - String
	// data.path - NSIndexPath
}

let row = TableRow<String, StringTableViewCell>(item: "some", actions: [action])
```
Or, using nice chaining approach:
```swift
let row = TableRow<String, StringTableViewCell>(item: "some")
	.action(TableRowAction(.click) { (data) in
	
	})
	.action(TableRowAction(.shouldHighlight) { (data) -> Bool in
		return false
	})
```
You could find all available actions <a href="https://github.com/maxsokolov/TableKit/blob/master/Sources/TableRowAction.swift" target="_blank">here</a>.

#### Batch rows
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

## Advanced

#### Cell height calculating strategy
By default TableKit relies on <a href="https://developer.apple.com/library/ios/documentation/UserExperience/Conceptual/AutolayoutPG/WorkingwithSelf-SizingTableViewCells.html" target="_blank">self-sizing cells</a>. In that case you have to provide an estimated height for your cells:
```swift
class StringTableViewCell: UITableViewCell, ConfigurableCell {

	// ...

	static func estimatedHeight() -> CGFloat {
        return 44
    }
}
```
It's enough for most cases. But you may be not happy with this. So you could use a prototype cell to calculate cell's heights. To enable this feature simply use this property:
```swift
tableDirector.shouldUsePrototypeCellHeightCalculation = true
```
It does all dirty work with prototypes for you <a href="https://github.com/maxsokolov/TableKit/blob/master/Sources/HeightStrategy.swift" target="_blank">behind the scene</a>, so you don't have to worry about anything except of your cell configuration:
```swift
class ImageTableViewCell: UITableViewCell, ConfigurableCell {

	func configure(url: NSURL, isPrototype: Bool) {
		
		if !isPrototype {
			loadImageAsync(url: url, imageView: imageView)
		}
	}

	override func layoutSubviews() {
		super.layoutSubviews()
        
		contentView.layoutIfNeeded()
		multilineLabel.preferredMaxLayoutWidth = multilineLabel.bounds.size.width
    }
}
```
First of all you have to set `preferredMaxLayoutWidth` for all your multiline labels. And check if a configuring cell is a prototype cell. If it is, you don't have to do any additional work that not actually affect cell's height. For example you don't have to load remote image for a prototype cell.

#### Functional programming
It's never been so easy to deal with table views.
```swift
let users = /* some users array */

tableDirector += users.filter({ $0.state == .active }).map({ TableRow<String, UserTableViewCell>(item: $0.username) })
```
Done, your table is ready. It's just awesome!

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
Add the line `github "maxsokolov/tablekit"` to your `Cartfile`.
#### Manual
Clone the repo and drag files from `Sources` folder into your Xcode project.

## Requirements

- iOS 8.0+
- Xcode 7.0+

## License

TableKit is available under the MIT license. See LICENSE for details.