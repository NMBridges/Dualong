//
//  ProfileViewController.swift
//  Dualong
//
//  Created by Nolan Bridges on 7/27/20.
//  Copyright © 2020 NiMBLe Interactive. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController
{

    @IBOutlet weak var imageRef: UIImageView!
    
    @IBOutlet weak var usernameRef: UILabel!
    
    @IBOutlet weak var nameRef: UILabel!
    
    @IBOutlet weak var roleRef: UILabel!
    
    var epVC: ProfileEditViewController = ProfileEditViewController()
    let viewWid = UIScreen.main.bounds.width
    let viewHei = UIScreen.main.bounds.height
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateProfInfo(notification:)), name: Notification.Name("updateProf"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(closeProfEdit(notification:)), name: Notification.Name("toHomeNoti"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(closeProfEdit(notification:)), name: Notification.Name("toConnectionsNoti"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(closeProfEdit(notification:)), name: Notification.Name("toExploreNoti"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(closeProfEdit(notification:)), name: Notification.Name("toProfileNoti"), object: nil)
    }
    
    @objc func updateProfInfo(notification: NSNotification)
    {
        epVC = (storyboard?.instantiateViewController(identifier: "ProfileEdit"))!
        epVC.view.frame = CGRect(x: viewWid, y: 0, width: viewWid, height: viewHei)
        self.view.addSubview(epVC.view)
        epVC.view.isHidden = true
        
        usernameRef.text = username
        nameRef.text = name
        roleRef.text = role
    }
    
    @objc func closeProfEdit(notification: NSNotification)
    {
        epVC.view.removeFromSuperview()
    }

    @IBAction func editProfPressed(_ sender: UIButton)
    {
        epVC.view.isHidden = false
        
        NotificationCenter.default.post(name: Notification.Name("editProf"), object: nil)
        
        UIView.animate(withDuration: 0.3)
        {
            self.epVC.view.frame = CGRect(x: 0, y: 0, width: self.viewWid, height: self.viewHei)
        }
    }
    

}

extension Notification.Name
{
    static let updateProf = Notification.Name("updateProf")
    static let editProf = Notification.Name("editProf")
}
