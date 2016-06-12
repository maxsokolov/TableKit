#TableKit

<p align="left">
<a href="https://travis-ci.org/maxsokolov/TableKit"><img src="https://api.travis-ci.org/maxsokolov/TableKit.svg" alt="Build Status" /></a>
<a href="https://developer.apple.com/swift"><img src="https://img.shields.io/badge/Swift_2.2-compatible-4BC51D.svg?style=flat" alt="Swift 2.2 compatible" /></a>
<img src="https://img.shields.io/badge/platform-iOS-blue.svg?style=flat" alt="Platform iOS" />
<a href="https://cocoapods.org/pods/tablekit"><img src="https://img.shields.io/badge/pod-0.7.0-blue.svg" alt="CocoaPods compatible" /></a>
<a href="https://raw.githubusercontent.com/maxsokolov/tablekit/master/LICENSE"><img src="http://img.shields.io/badge/license-MIT-blue.svg?style=flat" alt="License: MIT" /></a>
</p>

TableKit is a super lightweight yet powerful generic library that handles a complexity of UITableView's datasource and delegate methods in a Swifty way. TableKit's goal is to provide the easiest way to create complex table views. With TableKit you don't have to write a messy code of `switch` or `if` statements when you deal with bunch of different cells in different sections.

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
let s = TableSection(rows: [row1, row2, row3])
```
And configure your table:
```swift
let tableDirector = TableDirector(tableView: tableView)
tableDirector += section
```
Done. Your table is ready. You may want to look at your cell. It has to conform to ConfigurableCell protocol:
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


## License

TableKit is available under the MIT license. See LICENSE for details.