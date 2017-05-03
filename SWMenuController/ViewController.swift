//
//  ViewController.swift
//  SWMenuController
//
//  Created by Kaibo Lu on 2017/4/28.
//  Copyright © 2017年 Kaibo Lu. All rights reserved.
//

import UIKit

class ViewController: UIViewController, SWMenuControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewTapped(_:))))
    }
    
    @objc private func viewTapped(_ tap: UITapGestureRecognizer) {
        let loc = tap.location(in: tap.view)
        
        let menu = SWMenuController()
        menu.delegate = self
        menu.menuItems = ["Copy", "Paste", "Select", "Select all", "Look up", "Search", "Delete"]
        menu.setTargetRect(CGRect(x: loc.x - 10, y: loc.y, width: 20, height: 10), in: view)
        menu.setMenuVisible(true, animated: true)
    }

    // MARK: - SWMenuControllerDelegate

    func menuController(_ menu: SWMenuController, didSelected index: Int) {
        print(menu.menuItems[index])
    }

}

