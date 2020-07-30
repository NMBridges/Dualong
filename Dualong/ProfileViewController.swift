//
//  ProfileViewController.swift
//  Dualong
//
//  Created by Nolan Bridges on 7/27/20.
//  Copyright © 2020 NiMBLe Interactive. All rights reserved.
//

import UIKit
import FirebaseStorage

var ownProfPic: UIImage! = UIImage(named: "defaultProfileImageSolid")

class ProfileViewController: UIViewController
{
    
    @IBOutlet weak var imageRef: UIImageView!
    
    @IBOutlet weak var usernameRef: UILabel!
    
    @IBOutlet weak var nameRef: UILabel!
    
    @IBOutlet weak var roleRef: UILabel!
    
    let st = Storage.storage().reference()
    
    var epVC: ProfileEditViewController = ProfileEditViewController()
    let viewWid = UIScreen.main.bounds.width
    let viewHei = UIScreen.main.bounds.height
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let profcloseTap = UITapGestureRecognizer(target: self, action: #selector(closeMenuTab))
        profcloseTap.cancelsTouchesInView = false
        view.addGestureRecognizer(profcloseTap)
        
        epVC = (storyboard?.instantiateViewController(identifier: "ProfileEdit"))!
        epVC.view.frame = CGRect(x: viewWid, y: 0, width: viewWid, height: viewHei)
        self.view.addSubview(epVC.view)
        epVC.view.isHidden = true
        
        imageRef.layer.borderWidth = 1
        imageRef.layer.masksToBounds = false
        imageRef.layer.borderColor = UIColor.white.cgColor
        imageRef.layer.cornerRadius = imageRef.frame.height / 2.0
        imageRef.clipsToBounds = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateProfInfo(notification:)), name: Notification.Name("updateProf"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(closeProfEdit(notification:)), name: Notification.Name("toHomeNoti"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(closeProfEdit(notification:)), name: Notification.Name("toConnectionsNoti"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(closeProfEdit(notification:)), name: Notification.Name("toExploreNoti"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(closeProfEdit(notification:)), name: Notification.Name("toProfileNoti"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(closeProfEdit(notification:)), name: Notification.Name("closeProfEdit"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(animateOffEditProf(notification:)), name: Notification.Name("animateOffEditProf"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(profImageLoaded(notification:)), name: Notification.Name("profImageLoaded"), object: nil)
    }
    
    @objc func updateProfInfo(notification: NSNotification)
    {
        actuallyUpdateProfInfoAndUpdateScene()
    }
    
    func actuallyUpdateProfInfoAndUpdateScene()
    {
        imageRef.image = ownProfPic
        usernameRef.text = username
        nameRef.text = name
        roleRef.text = role
        currScene = "Profile"
    }
    
    @objc func closeProfEdit(notification: NSNotification)
    {
        //epVC.view.removeFromSuperview()
        epVC.view.isHidden = true
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
    
    @objc func animateOffEditProf(notification: NSNotification)
    {
        actuallyUpdateProfInfoAndUpdateScene()
        UIView.animate(withDuration: 0.3, animations:
        {
            self.epVC.view.frame = CGRect(x: self.viewWid, y: 0, width: self.viewWid, height: self.viewHei)
        }) { _ in
            NotificationCenter.default.post(name: Notification.Name("closeProfEdit"), object: nil)
        }
    }
    
    @objc func profImageLoaded(notification: NSNotification)
    {
        imageRef.image = ownProfPic
    }
    
    @objc func closeMenuTab()
    {
        if(menuToggle)
        {
            NotificationCenter.default.post(name: Notification.Name("closeMenuTab"), object: nil)
        }
    }

}

extension Notification.Name
{
    static let updateProf = Notification.Name("updateProf")
    static let editProf = Notification.Name("editProf")
    static let closeProfEdit = Notification.Name("closeProfEdit")
    static let animateOffEditProf = Notification.Name("animateOffEditProf")
    static let profImageLoaded = Notification.Name("profImageLoaded")
    static let uploadBar = Notification.Name("uploadBar")
    static let uploadBarComplete = Notification.Name("uploadBarComplete")
    static let uploadBarStart = Notification.Name("uploadBarStart")
}
