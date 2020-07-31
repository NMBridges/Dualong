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
    var isMe: Bool = true

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        if(isMe)
        {
            let conncloseTap = UITapGestureRecognizer(target: self, action: #selector(closeMenu))
            conncloseTap.cancelsTouchesInView = false
            view.addGestureRecognizer(conncloseTap)
            
            
            NotificationCenter.default.addObserver(self, selector: #selector(loggingOut(notification:)), name: Notification.Name("logOut"), object: nil)
        }
        
    }
    
    @objc func closeMenu()
    {
        if(menuToggle && isMe)
        {
            NotificationCenter.default.post(name: Notification.Name("closeMenuTab"), object: nil)
        }
    }

    @objc func loggingOut(notification: NSNotification)
    {
        if(isMe)
        {
            isMe = false
        }
    }
    

}
