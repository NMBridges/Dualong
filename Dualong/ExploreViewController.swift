//
//  ExploreViewController.swift
//  Dualong
//
//  Created by Nolan Bridges on 7/27/20.
//  Copyright © 2020 NiMBLe Interactive. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage

class ExploreViewController: UIViewController, UISearchBarDelegate
{

    @IBOutlet weak var scrollViewRef: UIScrollView!
    
    @IBOutlet weak var stackView: UIStackView!
    
    @IBOutlet weak var searchBarRef: UISearchBar!
    
    let db = Database.database().reference()
    let st = Storage.storage().reference()
    
    let xWid = UIScreen.main.bounds.width
    let yHei = UIScreen.main.bounds.height
    
    var buttList: [UIButton]! = []
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let closeTap = UITapGestureRecognizer(target: self, action: #selector(closeMenus))
        closeTap.cancelsTouchesInView = false
        view.addGestureRecognizer(closeTap)
        
        searchBarRef.delegate = self
        
        searchBarRef.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        
        
        
        
        // MAKE SCROLL VIEW START SLIGHTLY LOWER, ALSO ADJUST WHEN SCROLL UP/DOWN
        
        
        
        
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(createStackView(notification:)), name: Notification.Name("profImageLoaded"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(loggingOut(notification:)), name: Notification.Name("logOut"), object: nil)
    }
    
    func createStackViewMember(passedUsername: String)
    {
        let tUsername: String = passedUsername
        var tEmail: String = ""
        var tName: String = ""
        var tRole: String = ""
        var tImage: UIImage!
        let barHeight = CGFloat(100)
        let newView = UIView()
        let newButton = UIButton()
        var newImage: UIImageView! = UIImageView()
        let newName = UILabel()
        let newRole = UILabel()
        
        if(tUsername != "")
        {
            db.child("usernames/\(tUsername)").observeSingleEvent(of: .value)
            { (snapshot0) in
                if let helper0 = snapshot0.value as? String
                {
                    tEmail = helper0
                    self.db.child("users/\(tEmail)/name").observeSingleEvent(of: .value)
                    { (snapshot1) in
                        if let helper1 = snapshot1.value as? String
                        {
                            tName = helper1
                            self.db.child("users/\(tEmail)/account_type").observeSingleEvent(of: .value)
                            { (snapshot2) in
                                if let helper2 = snapshot2.value as? String
                                {
                                    tRole = helper2
                                    
                                    newView.heightAnchor.constraint(equalToConstant: barHeight).isActive = true
                                    newView.backgroundColor = UIColor.red
                                    
                                    newButton.setTitle("", for: .normal)
                                    newButton.frame = CGRect(x: 0, y: 0, width: self.xWid, height: barHeight)
                                    self.buttList.append(newButton)
                                    self.buttList[self.buttList.count - 1].addTarget(self, action: #selector(self.listItemSelected), for: UIControl.Event.touchUpInside)
                                    
                                    newName.text = tName
                                    newName.font = UIFont(name: "HelveticaNeue", size: 23.0)
                                    newName.textColor = UIColor.white
                                    newName.frame = CGRect(x: barHeight, y: 0, width: self.xWid - barHeight, height: barHeight * 0.7)
                                    newName.isUserInteractionEnabled = false
                                    
                                    newRole.text = tRole
                                    newRole.font = UIFont(name: "HelveticaNeue", size: 20.0)
                                    newRole.textColor = UIColor.white
                                    newRole.alpha = 0.5
                                    newRole.frame = CGRect(x: barHeight, y: barHeight * 0.3, width: self.xWid - barHeight, height: barHeight * 0.7)
                                    
                                    newImage = UIImageView(image: UIImage(named: "defaultProfileImageSolid"))
                                    newImage.layer.borderWidth = 1
                                    newImage.layer.masksToBounds = false
                                    newImage.frame = CGRect(x: barHeight * 0.1, y: barHeight * 0.1, width: barHeight * 0.8, height: barHeight * 0.8)
                                    newImage.layer.borderColor = UIColor.white.cgColor
                                    newImage.layer.cornerRadius = newImage.frame.height / 2.0
                                    newImage.clipsToBounds = true
                                    
                                    newView.addSubview(self.buttList[self.buttList.count - 1])
                                    newView.addSubview(newName)
                                    newView.addSubview(newRole)
                                    newView.addSubview(newImage)

                                    self.stackView.addArrangedSubview(newView)
                                    
                                    self.st.child("profilepics/\(tUsername).jpg").getData(maxSize: 4 * 1024 * 1024, completion: { (data, error) in
                                        if error != nil
                                        {
                                            print("error loading image \(error!)")
                                        }
                                        if let data = data
                                        {
                                            tImage = UIImage(data: data)!
                                            newImage.image = tImage
                                        }
                                    })
                                    
                                } else
                                {
                                    print("failure creating stack view member role")
                                    return
                                }
                            }
                        } else
                        {
                            print("failure creating stack view member name")
                            return
                        }
                    }
                } else
                {
                    print("failure creating stack view member email")
                    return
                }
            }
        }
    }
    
    func loadStackView()
    {
        
        if(role == "Learner, Student, or Parent")
        {
            let _ = db.child("users").queryOrdered(byChild: "account_type").queryEqual(toValue: "Tutor or Teacher").observe(.value, with: { (snap) in
                 
                for child in snap.children
                {
                    let snap = child as! DataSnapshot
                    let dict = snap.value as! [String : Any]
                    let USERNAMe = dict["username"] as! String
                    print(USERNAMe)
                    self.createStackViewMember(passedUsername: USERNAMe)
                }
                
            })
        }
        
        if(role == "Tutor or Teacher")
        {
            let _ = db.child("users").queryOrdered(byChild: "account_type").queryEqual(toValue: "Learner, Student, or Parent").observe(.value, with: { (snap) in
                 
                for child in snap.children
                {
                    let snap = child as! DataSnapshot
                    let dict = snap.value as! [String : Any]
                    let USERNAMe = dict["username"] as! String
                    print(USERNAMe)
                    self.createStackViewMember(passedUsername: USERNAMe)
                }
                
            })
        }
        
    }
    
    
    
    
    
    
    
    @objc func closeMenus()
    {
        if(currScene == "Explore")
        {
            view.endEditing(true)
        }
        if(menuToggle)
        {
            NotificationCenter.default.post(name: Notification.Name("closeMenuTab"), object: nil)
        }
    }
    
    @objc func keyboardWillShow(notification: NSNotification)
    {
        if(menuToggle)
        {
            NotificationCenter.default.post(name: Notification.Name("closeMenuTab"), object: nil)
        }
        /*if(currScene == "Explore")
        {
            if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            {
                self.view.frame.origin.y = -keyboardSize.height * 0.0
                self.view.layoutIfNeeded()
            }
        }*/
    }

    @objc func keyboardWillHide(notification: NSNotification)
    {
        /*if(currScene == "Explore")
        {
            self.view.frame.origin.y = 0
            self.view.layoutIfNeeded()
        }*/
    }
    
    @objc func createStackView(notification: NSNotification)
    {
        loadStackView()
    }
    
    @objc func listItemSelected(_ sender: UIButton)
    {
        
    }
    
    @objc func loggingOut(notification: NSNotification)
    {
        
    }
    
    
}
