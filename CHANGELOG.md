# Change Log

All notable changes to this project will be documented in this file.

## [2.8.0](https://github.com/maxsokolov/TableKit/releases/tag/2.8.0)
Released on 2018-09-30.
- Swift 4.2 support.

## [2.5.0](https://github.com/maxsokolov/TableKit/releases/tag/2.5.0)
Released on 2017-09-24.
- Swift 4.0 support.

## [2.3.0](https://github.com/maxsokolov/TableKit/releases/tag/2.3.0)
Released on 2016-11-16.
- `shouldUsePrototypeCellHeightCalculation` moved to `TableDirector(tableView: tableView, shouldUsePrototypeCellHeightCalculation: true)`
- Prototype cell height calculation bugfixes

## [2.1.0](https://github.com/maxsokolov/TableKit/releases/tag/2.1.0)
Released on 2016-10-19.
- `action` method was deprecated on TableRow. Use `on` instead.
- Support multiple actions with same type on row.
- You could now build your own cell height calculating strategy. See [TablePrototypeCellHeightCalculator](Sources/TablePrototypeCellHeightCalculator.swift).
- Default distance between sections changed to `UITableViewAutomaticDimension`. You can customize it, see [TableSection](Sources/TableSection.swift)

## [2.0.0](https://github.com/maxsokolov/TableKit/releases/tag/2.0.0)
Released on 2016-10-06. Breaking changes in 2.0.0:
<br/>The signatures of `TableRow` and `TableRowAction` classes were changed from
```swift
let action = TableRowAction<String, StringTableViewCell>(.click) { (data) in
}

let row = TableRow<String, StringTableViewCell>(item: "some string", actions: [action])
```
to
```swift
let action = TableRowAction<StringTableViewCell>(.click) { (data) in
}

let row = TableRow<StringTableViewCell>(item: "some string", actions: [action])
```
This is the great improvement that comes from the community. Thanks a lot!

## [1.3.0](https://github.com/maxsokolov/TableKit/releases/tag/1.3.0)
Released on 2016-09-04. Swift 3.0 support.

## [0.1.0](https://github.com/maxsokolov/TableKit/releases/tag/0.1.0)
Released on 2015-11-15. Initial release called Tablet.