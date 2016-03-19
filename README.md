![Tablet](https://raw.githubusercontent.com/maxsokolov/tablet/assets/tablet.png)

<p align="left">
<a href="https://travis-ci.org/maxsokolov/tablet"><img src="https://travis-ci.org/maxsokolov/tablet.svg" alt="Build Status" /></a>
<a href="https://developer.apple.com/swift"><img src="https://img.shields.io/badge/Swift2-compatible-4BC51D.svg?style=flat" alt="Swift 2 compatible" /></a>
<img src="https://img.shields.io/badge/platform-iOS-blue.svg?style=flat" alt="Platform iOS" />
<a href="https://cocoapods.org/pods/tablet"><img src="https://img.shields.io/badge/pod-0.3.0-blue.svg" alt="CocoaPods compatible" /></a>
<a href="https://raw.githubusercontent.com/maxsokolov/tablet/master/LICENSE"><img src="http://img.shields.io/badge/license-MIT-blue.svg?style=flat" alt="License: MIT" /></a>
</p>

Tablet is a super lightweight yet powerful generic library that handles a complexity of UITableView's datasource and delegate methods in a Swift environment. Tablet's goal is to provide an easiest way to create complex table views. With Tablet you don't have to write a messy code of `switch` or `if` statements when you deal with bunch of different cells in different sections. 

That's almost all you need in your controller to build a bunch of cells in a section:
```swift
TableConfigurableRowBuilder<String, MyTableViewCell>(items: ["1", "2", "3", "4", "5"], estimatedRowHeight: 42)
```
Tablet respects cells reusability feature and it's type-safe. See the Usage section to learn more.

## Requirements

- iOS 8.0+
- Xcode 7.0+

## Installation

### CocoaPods
To integrate Tablet into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'
use_frameworks!

pod 'Tablet'
```

Then, run the following command:

```bash
$ pod install
```

## Usage

### Very basic

You may want to setup a very basic table view, without any custom cells. In that case simply use the `TableRowBuilder`.

```swift
import Tablet

let rowBuilder = TableRowBuilder<User, UITableViewCell>(items: [user1, user2, user3], id: "reusable_id")
	.action(.configure) { data -> Void in

		data.cell?.textLabel?.text = data.item.username
		data.cell?.detailTextLabel?.text = data.item.isActive ? "Active" : "Inactive"
	}

let sectionBuilder = TableSectionBuilder(headerTitle: "Users", rowBuilders: [rowBuilder])

director = TableDirector(tableView: tableView)
director.appendSections(sectionBuilder)
```

### Type-safe configurable cells

Let's say you want to put your cell configuration logic into cell itself. Say you want to pass your view model (or even model) to your cell.
You could easily do this using the `TableConfigurableRowBuilder`. Your cell should respect the `ConfigurableCell` protocol as you may see in example below:

```swift
import Tablet

class MyTableViewCell : UITableViewCell, ConfigurableCell {

	typealias Item = User

	static func reusableIdentifier() -> String {
		return "reusable_id"
	}

	func configureWithItem(item: Item) { // item is user here

		textLabel?.text = item.username
		detailTextLabel?.text = item.isActive ? "Active" : "Inactive"
	}
}
```
Once you've implemented the protocol, simply use the `TableConfigurableRowBuilder` to build cells:

```swift
import Tablet

let rowBuilder = TableConfigurableRowBuilder<User, MyTableViewCell>(estimatedRowHeight: 42)
rowBuilder.appendItems(users)

director = TableDirector(tableView: tableView)
tableDirector.appendSection(TableSectionBuilder(rowBuilders: [rowBuilder]))
```

### Cell actions

Tablet provides a chaining approach to handle actions from your cells:

```swift
import Tablet

let rowBuilder = TableRowBuilder<User, MyTableViewCell>(items: [user1, user2, user3], id: "reusable_id")
	.action(.configure) { data -> Void in

	}
	.action(.click) { data -> Void in

	}
	.action(.shouldHighlight) { data -> ReturnValue in

		return false
	}
```

### Custom cell actions
```swift
import Tablet

let kMyAction = "action_key"

class MyTableViewCell : UITableViewCell {

	@IBAction func buttonClicked(sender: UIButton) {

		Action(key: kMyAction, sender: self, userInfo: nil).invoke()
	}
}
```
And receive this actions with your row builder:
```swift
import Tablet

let rowBuilder = TableConfigurableRowBuilder<User, MyTableViewCell>(items: users, id: "reusable_id", estimatedRowHeight: 42)
	.action(.click) { data -> Void in
		
	}
	.action(.willDisplay) { data -> Void in
		
	}
	.action(kMyAction) { data -> Void in
		
	}
```

## Extensibility

If you find that Tablet is not provide an action you need, for example you need UITableViewDelegate's `didEndDisplayingCell` method and it's not out of the box,
simply provide an extension for `TableDirector` as follow:
```swift
import Tablet

let kTableDirectorDidEndDisplayingCell = "enddisplaycell"

extension TableDirector {

	public func tableView(tableView: UITableView, didEndDisplayingCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {

		invokeAction(.custom(kTableDirectorDidEndDisplayingCell), cell: cell, indexPath: indexPath)
	}
}
```
Catch your action with row builder:
```swift
let rowBuilder = TableConfigurableRowBuilder<User, MyTableViewCell>(items: users, estimatedRowHeight: 42)
	.action(kTableDirectorDidEndDisplayingCell) { data -> Void in

	}
```
You could also invoke an action that returns a value.

## License

Tablet is available under the MIT license. See LICENSE for details.