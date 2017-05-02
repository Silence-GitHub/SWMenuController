//
//  ViewController.swift
//  SWMenuController
//
//  Created by Kaibo Lu on 2017/4/28.
//  Copyright © 2017年 Kaibo Lu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Menu", style: .plain, target: self, action: #selector(showMenu))
    }
    
    func showMenu() {
        let menu = SWMenuController()
        let item = SWMenuItem(title: "Copy", action: #selector(menuItemAction))
        let item2 = SWMenuItem(title: "Paste", action: #selector(menuItemAction))
        let item3 = SWMenuItem(title: "Select", action: #selector(menuItemAction))
        let item4 = SWMenuItem(title: "Select all", action: #selector(menuItemAction))
        let item5 = SWMenuItem(title: "Look up", action: #selector(menuItemAction))
        let item6 = SWMenuItem(title: "Search", action: #selector(menuItemAction))
        let item7 = SWMenuItem(title: "Delete", action: #selector(menuItemAction))
        menu.menuItems = [item, item2, item3, item4, item5, item6, item7]
        menu.setTargetRect(CGRect(x: 75, y: 100, width: 100, height: 100), in: view)
        menu.setMenuVisible(true, animated: true)
    }

    func menuItemAction() {
        
    }


}

