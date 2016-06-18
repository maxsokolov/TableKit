//
//    Copyright (c) 2015 Max Sokolov https://twitter.com/max_sokolov
//
//    Permission is hereby granted, free of charge, to any person obtaining a copy of
//    this software and associated documentation files (the "Software"), to deal in
//    the Software without restriction, including without limitation the rights to
//    use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
//    the Software, and to permit persons to whom the Software is furnished to do so,
//    subject to the following conditions:
//
//    The above copyright notice and this permission notice shall be included in all
//    copies or substantial portions of the Software.
//
//    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
//    FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
//    COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
//    IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
//    CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

import UIKit

public protocol RowBuilder {

    func rows() -> [Row]?
}

public class TableRowBuilder<ItemType, CellType: ConfigurableCell where CellType.T == ItemType, CellType: UITableViewCell>: RowBuilder {

    public var items: [ItemType]?
    public var actions: [TableRowAction<ItemType, CellType>]?
    
    public init(handler: (TableRowBuilder) -> ()) {
        handler(self)
    }
    
    public init(items: [ItemType], actions: [TableRowAction<ItemType, CellType>]? = nil) {

        self.items = items
        self.actions = actions
    }
    
    // MARK: - RowBuilder -
    
    public func rows() -> [Row]? {
        return items?.map { TableRow<ItemType, CellType>(item: $0, actions: actions) }
    }
}

public extension TableSection {
    
    public func append(builder builder: RowBuilder) {

        if let rows = builder.rows() {
            append(rows: rows)
        }
    }
}