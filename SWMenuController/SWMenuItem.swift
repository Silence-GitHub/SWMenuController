//
//  SWMenuItem.swift
//  SWMenuController
//
//  Created by Kaibo Lu on 2017/4/28.
//  Copyright © 2017年 Kaibo Lu. All rights reserved.
//

import UIKit

class SWMenuItem: NSObject {

    var title: String
    var action: Selector
    
    init(title: String, action: Selector) {
        self.title = title
        self.action = action
        super.init()
    }
}
