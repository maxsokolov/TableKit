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

/**
    Responsible for building a certain table view section.
    Can host several row builders.
*/
public class TableSectionBuilder {
    
    weak var tableDirector: TableDirector? {
        didSet {
            guard let director = tableDirector else { return }
            builders.forEach { $0.willUpdateDirector(director) }
        }
    }

    private var builders = [RowBuilder]()

    public var headerTitle: String?
    public var footerTitle: String?

    public private(set) var headerView: UIView?
    public private(set) var footerView: UIView?

    /// A total number of rows in section of each row builder.
    public var numberOfRowsInSection: Int {
        return builders.reduce(0) { $0 + $1.numberOfRows }
    }
    
    public init(rows: [RowBuilder]? = nil) {
     
        if let initialRows = rows {
            builders.appendContentsOf(initialRows)
        }
    }

    public convenience init(headerTitle: String?, footerTitle: String?, rows: [RowBuilder]?) {
        self.init(rows: rows)
        
        self.headerTitle = headerTitle
        self.footerTitle = footerTitle
    }

    public convenience init(headerView: UIView?, footerView: UIView?, rows: [RowBuilder]?) {
        self.init(rows: rows)
        
        self.headerView = headerView
        self.footerView = footerView
    }

    // MARK: - Public -

    public func clear() {
        builders.removeAll()
    }
    
    public func append(row row: RowBuilder) {
        append(rows: [row])
    }
    
    public func append(rows rows: [RowBuilder]) {
        
        if let director = tableDirector { rows.forEach { $0.willUpdateDirector(director) } }
        builders.appendContentsOf(rows)
    }

    // MARK: - Internal -
    
    func builderAtIndex(index: Int) -> (RowBuilder, Int)? {
        
        var builderIndex = index
        for builder in builders {
            if builderIndex < builder.numberOfRows {
                return (builder, builderIndex)
            }
            builderIndex -= builder.numberOfRows
        }
        
        return nil
    }
}

public func +=(left: TableSectionBuilder, right: RowBuilder) {
    left.append(row: right)
}

public func +=(left: TableSectionBuilder, right: [RowBuilder]) {
    left.append(rows: right)
}