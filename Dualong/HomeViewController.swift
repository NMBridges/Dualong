//
//  HomeViewController.swift
//  Dualong
//
//  Created by Nolan Bridges on 7/25/20.
//  Copyright © 2020 NiMBLe Interactive. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController
{

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        print("home loaded")
        let homecloseTap = UITapGestureRecognizer(target: self, action: #selector(closeMenu))
        homecloseTap.cancelsTouchesInView = false
        view.addGestureRecognizer(homecloseTap)
        
        NotificationCenter.default.addObserver(self, selector: #selector(loggingOut(notification:)), name: Notification.Name("logOut"), object: nil)
        
    }

    
    @objc func closeMenu()
    {
        if(menuToggle)
        {
            NotificationCenter.default.post(name: Notification.Name("closeMenuTab"), object: nil)
        }
    }
    
    @objc func loggingOut(notification: NSNotification)
    {
        
    }
}
