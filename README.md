![Tablet](https://raw.githubusercontent.com/maxsokolov/tablet/develop/Tablet/Tablet.png)

Tablet is a super lightweight yet powerful library that handles a complexity of UITableView's datasource and delegate.

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

```swift
import Tablet

let rowBuilder = TableRowBuilder<User, UITableViewCell>(items: [user1, user2, user3], id: "reusable_id")
	.action(.configure) { data in

		data.cell.textLabel?.text = data.item.title
		data.cell.detailTextLabel?.text = data.item.isActive ? "Active" : "Inactive"
	}

let sectionBuilder = TableSectionBuilder(headerTitle: "Users", rowBuilders: [rowBuilder])

let director = TableDirector(tableView: tableView)
director.appendSections(sectionBuilder)
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

### Configurable cells

Let's say you want to put your cell configuration logic into cell itself. Say you want to pass your view model (or even model) to your cell.
To provide this behaviour simply follow:

```swift
import Tablet

class UserTableViewCell : UITableViewCell, ConfigurableCell {

    typealias Item = User
    
    static func reusableIdentifier() -> String {
        return "reusable_id"
    }

    func configureWithItem(item: Item) { // item is user here

    	textLabel?.text = item.title
		detailTextLabel?.text = item.isActive ? "Active" : "Inactive"
    }
}
```
Once you follow the protocol, simply use TableConfigurableRowBuilder to build cells:

```swift
import Tablet

let rowBuilder = TableConfigurableRowBuilder<User, UserTableViewCell>()
rowBuilder.appendItems(users)

tableDirector.appendSection(TableSectionBuilder(rowBuilders: [rowBuilder]))
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