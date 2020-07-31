//
//  MenuViewController.swift
//  Dualong
//
//  Created by Nolan Bridges on 7/26/20.
//  Copyright © 2020 NiMBLe Interactive. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController
{
    var isMe: Bool = true

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        if(isMe)
        {
            NotificationCenter.default.addObserver(self, selector: #selector(loggingOut(notification:)), name: Notification.Name("logOut"), object: nil)
        }
    }
    
    @IBAction func homeButton(_ sender: UIButton)
    {
        if(isMe)
        {
            currScene = "Home"
            NotificationCenter.default.post(name: Notification.Name("toHomeNoti"), object: nil)
        }
    }
    
    @IBAction func connectionsButton(_ sender: UIButton)
    {
        if(isMe)
        {
            currScene = "Connections"
            NotificationCenter.default.post(name: Notification.Name("toConnectionsNoti"), object: nil)
        }
    }
    
    @IBAction func exploreButton(_ sender: UIButton)
    {
        if(isMe)
        {
            
            if(currScene != "Explore")
            {
                NotificationCenter.default.post(name: Notification.Name("reloadStackView"), object: nil)
            } else
            {
                NotificationCenter.default.post(name: Notification.Name("expTurnOffLoading"), object: nil)
            }
            currScene = "Explore"
            NotificationCenter.default.post(name: Notification.Name("toExploreNoti"), object: nil)
        }
    }
    
    @IBAction func profileButton(_ sender: UIButton)
    {
        if(isMe)
        {
            currScene = "Profile"
            NotificationCenter.default.post(name: Notification.Name("toProfileNoti"), object: nil)
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
