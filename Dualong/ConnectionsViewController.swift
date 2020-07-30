//
//  ConnectionsViewController.swift
//  Dualong
//
//  Created by Nolan Bridges on 7/25/20.
//  Copyright © 2020 NiMBLe Interactive. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ConnectionsViewController: UIViewController
{
    let db = Database.database().reference()

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let conncloseTap = UITapGestureRecognizer(target: self, action: #selector(closeMenu))
        conncloseTap.cancelsTouchesInView = false
        view.addGestureRecognizer(conncloseTap)
        
    }
    
    @objc func closeMenu()
    {
        if(menuToggle)
        {
            NotificationCenter.default.post(name: Notification.Name("closeMenuTab"), object: nil)
        }
    }

    

}
