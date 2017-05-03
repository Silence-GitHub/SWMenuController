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
        
//        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Menu", style: .plain, target: self, action: #selector(showMenu))
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewTapped(_:))))
    }
    
    @objc private func viewTapped(_ tap: UITapGestureRecognizer) {
        let loc = tap.location(in: tap.view)
        
        let menu = SWMenuController()
        let item = SWMenuItem(title: "Copy", action: #selector(menuItemAction))
        let item2 = SWMenuItem(title: "Paste", action: #selector(menuItemAction))
        let item3 = SWMenuItem(title: "Select", action: #selector(menuItemAction))
        let item4 = SWMenuItem(title: "Select all", action: #selector(menuItemAction))
        let item5 = SWMenuItem(title: "Look up", action: #selector(menuItemAction))
        let item6 = SWMenuItem(title: "Search", action: #selector(menuItemAction))
        let item7 = SWMenuItem(title: "Delete", action: #selector(menuItemAction))
        menu.menuItems = [item, item2, item3, item4, item5, item6, item7]
        menu.setTargetRect(CGRect(x: loc.x - 10, y: loc.y, width: 20, height: 10), in: view)
        menu.setMenuVisible(true, animated: true)
    }

    func menuItemAction() {
        
    }


}

