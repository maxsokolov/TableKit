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

class TableCellRegisterer {

    private var registeredIds = Set<String>()
    private weak var tableView: UITableView?
    
    init(tableView: UITableView?) {
        self.tableView = tableView
    }
    
    func register(cellType: AnyClass, forCellReuseIdentifier reuseIdentifier: String) {
        
        if registeredIds.contains(reuseIdentifier) {
            return
        }
        
        // check if cell is already registered, probably cell has been registered by storyboard
        if tableView?.dequeueReusableCell(withIdentifier: reuseIdentifier) != nil {
            
            registeredIds.insert(reuseIdentifier)
            return
        }
        
        let bundle = Bundle(for: cellType)
        
        // we hope that cell's xib file has name that equals to cell's class name
        // in that case we could register nib
        if let _ = bundle.path(forResource: reuseIdentifier, ofType: "nib") {
            tableView?.register(UINib(nibName: reuseIdentifier, bundle: bundle), forCellReuseIdentifier: reuseIdentifier)
        // otherwise, register cell class
        } else {
            tableView?.register(cellType, forCellReuseIdentifier: reuseIdentifier)
        }
        
        registeredIds.insert(reuseIdentifier)
    }
}
