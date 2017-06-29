//
//  SideBarMenu.swift
//  TimeOfLife
//
//  Created by 王志輝 on 2017/6/25.
//  Copyright © 2017年 Woody. All rights reserved.
//

import Foundation

extension UIViewController {
    
    func addSideBarMenu(leftMenuButton: UIBarButtonItem?, rightBarButton: UIBarButtonItem? = nil) {
        if revealViewController() != nil {
            if let menuButton = leftMenuButton {
                menuButton.target = revealViewController()
                menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
                
            }
            if let extraButton = rightBarButton {
                revealViewController().rearViewRevealWidth = 150
                extraButton.target = revealViewController()
                extraButton.action = #selector(SWRevealViewController.rightRevealToggle(_:))
            }
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
}
