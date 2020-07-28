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
        print("tohome")
        NotificationCenter.default.post(name: Notification.Name("toHomeNoti"), object: nil)
    }
    
    @IBAction func connectionsButton(_ sender: UIButton)
    {
        print("toconnections")
        NotificationCenter.default.post(name: Notification.Name("toConnectionsNoti"), object: nil)
    }
    
    @IBAction func exploreButton(_ sender: UIButton)
    {
        print("toexplore")
        NotificationCenter.default.post(name: Notification.Name("toExploreNoti"), object: nil)
    }
    
    @IBAction func profileButton(_ sender: UIButton)
    {
        print("toprofile")
        NotificationCenter.default.post(name: Notification.Name("toProfileNoti"), object: nil)
    }
}
