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
        
        let homecloseTap = UITapGestureRecognizer(target: self, action: #selector(closeMenu))
        homecloseTap.cancelsTouchesInView = false
        view.addGestureRecognizer(homecloseTap)
        
    }

    
    @objc func closeMenu()
    {
        if(menuToggle)
        {
            NotificationCenter.default.post(name: Notification.Name("closeMenuTab"), object: nil)
        }
    }
}
