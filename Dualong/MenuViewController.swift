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

    override func viewDidLoad()
    {
        super.viewDidLoad()

        
    }
    
    @IBAction func homeButton(_ sender: UIButton)
    {
        currScene = "Home"
        NotificationCenter.default.post(name: Notification.Name("toHomeNoti"), object: nil)
    }
    
    @IBAction func connectionsButton(_ sender: UIButton)
    {
        currScene = "Connections"
        NotificationCenter.default.post(name: Notification.Name("toConnectionsNoti"), object: nil)
    }
    
    @IBAction func exploreButton(_ sender: UIButton)
    {
        currScene = "Explore"
        NotificationCenter.default.post(name: Notification.Name("toExploreNoti"), object: nil)
    }
    
    @IBAction func profileButton(_ sender: UIButton)
    {
        currScene = "Profile"
        NotificationCenter.default.post(name: Notification.Name("toProfileNoti"), object: nil)
    }
    
    @IBAction func logOutButton(_ sender: UIButton)
    {
        currScene = "Login"
        menuToggle = false
        NotificationCenter.default.post(name: Notification.Name("logOut"), object: nil)
    }
    
}
