![Tablet](https://raw.githubusercontent.com/maxsokolov/tablet/assets/tablet.png)

Tablet is a super lightweight yet powerful generic library that handles a complexity of UITableView's datasource and delegate methods in a Swift environment. Tablet's goal is to provide an easiest way to create complex table views. With Tablet you don't have to write a messy code of switch or if statements when you deal with bunch of different cells in different sections. 

That's almost all you need in your controller to build a bunch of cells in a section:
```swift
TableConfigurableRowBuilder<String, MyTableViewCell>(items: ["1", "2", "3", "4", "5"], estimatedRowHeight: 42)
```
Tablet respects cells reusability feature and it's type-safe. See the Usage section to learn more.

## Requirements

- iOS 8.0+
- Xcode 7.1+

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
	.action(.configure) { data in

		data.cell?.textLabel?.text = data.item.username
		data.cell?.detailTextLabel?.text = data.item.isActive ? "Active" : "Inactive"
	}

let sectionBuilder = TableSectionBuilder(headerTitle: "Users", rowBuilders: [rowBuilder])

let director = TableDirector(tableView: tableView)
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

let rowBuilder = TableConfigurableRowBuilder<User, MyTableViewCell>()
rowBuilder.appendItems(users)

tableDirector.appendSection(TableSectionBuilder(rowBuilders: [rowBuilder]))
```

### Cell actions

Tablet provides a chaining approach to handle actions from your cells:

```swift
import Tablet

let rowBuilder = TableRowBuilder<User, UITableViewCell>(items: [user1, user2, user3], id: "reusable_id")
	.action(.configure) { data in

	}
	.action(.click) { data in
		
	}
	.action(.willDisplay) { data in
		
	}
```

### Custom cell actions
```swift
import Tablet

class UserTableViewCell : UITableViewCell {

	@IBAction func buttonClicked(sender: UIButton) {

		Action(key: "action_key", sender: self, userInfo: nil).trigger()
	}
}
```
And receive this actions with your row builder:
```swift
import Tablet

let rowBuilder = TableRowBuilder<User, UserTableViewCell>(items: users, id: "reusable_id")
	.action(.click) { data in
		
	}
	.action(.willDisplay) { data in
		
	}
	.action("action_key") { data in
		
	}
```

## License

Tablet is available under the MIT license. See LICENSE for details.