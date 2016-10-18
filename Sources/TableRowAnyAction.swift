//
//  TableRowAnyAction.swift
//  TableKit
//
//  Created by Max Sokolov on 18/10/16.
//  Copyright © 2016 Max Sokolov. All rights reserved.
//

import UIKit

open class TableRowAnyActionOptions {
    
    
}

open class TableRowAnyAction {
    
    open var id: String?
    open let type: TableRowActionType
    
    init(_ type: TableRowActionType, handler: @escaping () -> ()) {
        
        self.type = type
    }
    
    func invoke(cell: UITableViewCell?, item: Any, path: IndexPath, userInfo: [AnyHashable: Any]?) -> Any? {

        return nil
    }
}
