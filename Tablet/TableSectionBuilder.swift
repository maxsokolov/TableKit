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
import Foundation

/**
    Responsible for building a certain table view section.
*/
public class TableSectionBuilder {

    private var builders = [RowBuilder]()
    
    public var headerTitle: String?
    public var footerTitle: String?
    
    public var headerView: UIView?
    public var headerHeight: CGFloat = UITableViewAutomaticDimension
    
    public var footerView: UIView?
    public var footerHeight: CGFloat = UITableViewAutomaticDimension
    
    /// A total number of rows in section of each row builder.
    public var numberOfRowsInSection: Int {

        return builders.reduce(0) { $0 + $1.numberOfRows }
    }
    
    public init(headerTitle: String? = nil, footerTitle: String? = nil, rowBuilders: [RowBuilder]? = nil) {
        
        self.headerTitle = headerTitle
        self.footerTitle = footerTitle
        
        if let initialRows = rowBuilders {
            self.builders.appendContentsOf(initialRows)
        }
    }
    
    public init(headerView: UIView? = nil, headerHeight: CGFloat = UITableViewAutomaticDimension, footerView: UIView? = nil, footerHeight: CGFloat = UITableViewAutomaticDimension) {
        
        self.headerView = headerView
        self.headerHeight = headerHeight
        
        self.footerView = footerView
        self.footerHeight = footerHeight
    }
    
    internal func builderAtIndex(var index: Int) -> (RowBuilder, Int)? {
        
        for builder in builders {
            if index < builder.numberOfRows {
                return (builder, index)
            }
            index -= builder.numberOfRows
        }
        
        return nil
    }
}