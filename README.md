# tablet

Tablet is a super lightweight yet powerful library that handles a complexity of UITableView's datasource and delegate.

## Requirements

- iOS 7.0+
- Xcode 7.0+

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

### Additional cell actions

```swift

let rowBuilder = TableRowBuilder<User, UITableViewCell>(items: [user1, user2, user3], id: "reusable_id")
	.action(.configure) { data in

	}
	.action(.click) { data in
		
	}
	.action(.willDisplay) { data in
		
	}
```