//
//  TableDirectorExtensions.swift
//  TabletDemo
//
//  Created by Max Sokolov on 20/01/16.
//  Copyright © 2016 Tablet. All rights reserved.
//

import Foundation
import UIKit

extension TableDirector {

    public func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        
        invokeAction(.custom(""), cell: nil, indexPath: nil)
    }
}