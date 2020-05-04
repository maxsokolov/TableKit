# TableKit

<p align="left">
	<a href="https://travis-ci.org/maxsokolov/TableKit"><img src="https://api.travis-ci.org/maxsokolov/TableKit.svg" alt="Build Status" /></a>
	<a href="https://developer.apple.com/swift"><img src="https://img.shields.io/badge/Swift_5.1-compatible-4BC51D.svg?style=flat" alt="Swift 5.1 compatible" /></a>
	<a href="https://github.com/Carthage/Carthage"><img src="https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat" alt="Carthage compatible" /></a>
	<a href="https://cocoapods.org/pods/tablekit"><img src="https://img.shields.io/badge/pod-2.11.0-blue.svg" alt="CocoaPods compatible" /></a>
	<img src="https://img.shields.io/badge/platform-iOS-blue.svg?style=flat" alt="Platform iOS" />
	<a href="https://raw.githubusercontent.com/maxsokolov/tablekit/master/LICENSE"><img src="http://img.shields.io/badge/license-MIT-blue.svg?style=flat" alt="License: MIT" /></a>
</p>

TableKit is a super lightweight yet powerful generic library that allows you to build complex table views in a declarative type-safe manner.
It hides a complexity of `UITableViewDataSource` and `UITableViewDelegate` methods behind the scene, so your code will be look clean, easy to read and nice to maintain.

# Features

- [x] Type-safe generic cells
- [x] Functional programming style friendly
- [x] The easiest way to map your models or view models to cells
- [x] Automatic cell registration*
- [x] Correctly handles autolayout cells with multiline labels
- [x] Chainable cell actions (select/deselect etc.)
- [x] Support cells created from code, xib, or storyboard
- [x] Support different cells height calculation strategies
- [x] Support portrait and landscape orientations
- [x] No need to subclass
- [x] Extensibility

# Getting Started

An [example app](Demo) is included demonstrating TableKit's functionality.

## Basic usage

Create your rows:
```swift
import TableKit

let row1 = TableRow<StringTableViewCell>(item: "1")
let row2 = TableRow<IntTableViewCell>(item: 2)
let row3 = TableRow<UserTableViewCell>(item: User(name: "John Doe", rating: 5))
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
Done. Your table is ready. Your cells have to conform to `ConfigurableCell` protocol:
```swift
class StringTableViewCell: UITableViewCell, ConfigurableCell {

    func configure(with string: String) {
		
        textLabel?.text = string
    }
}

class UserTableViewCell: UITableViewCell, ConfigurableCell {

    static var estimatedHeight: CGFloat? {
        return 100
    }

    // is not required to be implemented
    // by default reuse id is equal to cell's class name
    static var reuseIdentifier: String {
        return "my id"
    }

    func configure(with user: User) {
		
        textLabel?.text = user.name
        detailTextLabel?.text = "Rating: \(user.rating)"
    }
}
```
You could have as many rows and sections as you need.

## Row actions

It nice to have some actions that related to your cells:
```swift
let action = TableRowAction<StringTableViewCell>(.click) { (options) in

    // you could access any useful information that relates to the action

    // options.cell - StringTableViewCell?
    // options.item - String
    // options.indexPath - IndexPath
    // options.userInfo - [AnyHashable: Any]?
}

let row = TableRow<StringTableViewCell>(item: "some", actions: [action])
```
Or, using nice chaining approach:
```swift
let row = TableRow<StringTableViewCell>(item: "some")
    .on(.click) { (options) in
	
    }
    .on(.shouldHighlight) { (options) -> Bool in
        return false
    }
```
You could find all available actions [here](Sources/TableRowAction.swift).

## Custom row actions

You are able to define your own actions:
```swift
struct MyActions {
    
    static let ButtonClicked = "ButtonClicked"
}

class MyTableViewCell: UITableViewCell, ConfigurableCell {

    @IBAction func myButtonClicked(sender: UIButton) {
	
        TableCellAction(key: MyActions.ButtonClicked, sender: self).invoke()
    }
}
```
And handle them accordingly:
```swift
let myAction = TableRowAction<MyTableViewCell>(.custom(MyActions.ButtonClicked)) { (options) in

}
```
## Multiple actions with same type

It's also possible to use multiple actions with same type:
```swift
let click1 = TableRowAction<StringTableViewCell>(.click) { (options) in }
click1.id = "click1" // optional

let click2 = TableRowAction<StringTableViewCell>(.click) { (options) in }
click2.id = "click2" // optional

let row = TableRow<StringTableViewCell>(item: "some", actions: [click1, click2])
```
Could be useful in case if you want to separate your logic somehow. Actions will be invoked in order which they were attached.
> If you define multiple actions with same type which also return a value, only last return value will be used for table view.

You could also remove any action by id:
```swift
row.removeAction(forActionId: "action_id")
```

# Advanced

## Cell height calculating strategy
By default TableKit relies on <a href="https://developer.apple.com/library/ios/documentation/UserExperience/Conceptual/AutolayoutPG/WorkingwithSelf-SizingTableViewCells.html" target="_blank">self-sizing cells</a>. In that case you have to provide an estimated height for your cells:
```swift
class StringTableViewCell: UITableViewCell, ConfigurableCell {

    // ...

    static var estimatedHeight: CGFloat? {
        return 255
    }
}
```
It's enough for most cases. But you may be not happy with this. So you could use a prototype cell to calculate cells heights. To enable this feature simply use this property:
```swift
let tableDirector = TableDirector(tableView: tableView, shouldUsePrototypeCellHeightCalculation: true)
```
It does all dirty work with prototypes for you [behind the scene](Sources/TablePrototypeCellHeightCalculator.swift), so you don't have to worry about anything except of your cell configuration:
```swift
class ImageTableViewCell: UITableViewCell, ConfigurableCell {

    func configure(with url: NSURL) {
		
        loadImageAsync(url: url, imageView: imageView)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.layoutIfNeeded()
        multilineLabel.preferredMaxLayoutWidth = multilineLabel.bounds.size.width
    }
}
```
You have to additionally set `preferredMaxLayoutWidth` for all your multiline labels.

## Functional programming
It's never been so easy to deal with table views.
```swift
let users = /* some users array */

let click = TableRowAction<UserTableViewCell>(.click) {

}

let rows = users.filter({ $0.state == .active }).map({ TableRow<UserTableViewCell>(item: $0.name, actions: [click]) })

tableDirector += rows
```
Done, your table is ready.
## Automatic cell registration

TableKit can register your cells in a table view automatically. In case if your reusable cell id matches cell's xib name:

```ruby
MyTableViewCell.swift
MyTableViewCell.xib

```
You can also turn off this behaviour:
```swift
let tableDirector = TableDirector(tableView: tableView, shouldUseAutomaticCellRegistration: false)
```
and register your cell manually.

# Installation

## CocoaPods
To integrate TableKit into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
pod 'TableKit'
```
## Carthage
Add the line `github "maxsokolov/tablekit"` to your `Cartfile`.
## Manual
Clone the repo and drag files from `Sources` folder into your Xcode project.

# Requirements

- iOS 8.0
- Xcode 9.0

# Changelog

Keep an eye on [changes](CHANGELOG.md).

# License

TableKit is available under the MIT license. See LICENSE for details.
