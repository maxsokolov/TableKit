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

public protocol ReusableCell {
    
    static func reusableIdentifier() -> String
    static func nib() -> UINib?
}

public protocol ConfigurableCell: ReusableCell {

    associatedtype T

    static func estimatedHeight() -> CGFloat
    static func defaultHeight() -> CGFloat?
    func configure(_: T, isPrototype: Bool)
}

public extension ReusableCell where Self: UITableViewCell {
    
    static func reusableIdentifier() -> String {
        return String(self)
    }
    
    static func nib() -> UINib? {
        return nil
    }
}

public extension ConfigurableCell where Self: UITableViewCell {

    static func estimatedHeight() -> CGFloat {
        return UITableViewAutomaticDimension
    }

    static func defaultHeight() -> CGFloat? {
        return nil
    }
}