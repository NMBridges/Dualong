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
    
    @IBOutlet weak var titleRef: UILabel!
    
    let db = Database.database().reference()
    let st = Storage.storage().reference()
    
    let xWid = UIScreen.main.bounds.width
    let yHei = UIScreen.main.bounds.height
    var isMe: Bool = true
    var continueLoad: Bool = true
    
    var buttList: [UIButton]! = []
    
    var loadCircle = UIView()
    var circle = UIBezierPath()
    var displayLink: CADisplayLink!
    var shapeLayer: CAShapeLayer!
    var time = CACurrentMediaTime()
    var ogtime = CACurrentMediaTime()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        
        if(isMe)
        {
            let closeTap = UITapGestureRecognizer(target: self, action: #selector(closeMenus))
            closeTap.cancelsTouchesInView = false
            view.addGestureRecognizer(closeTap)
            
            searchBarRef.delegate = self
            
            searchBarRef.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
            
            setupLoadCircle()
            displayLink = CADisplayLink(target: self, selector: #selector(loadAnimations))
            displayLink.add(to: RunLoop.main, forMode: .default)
            
            
            // MAKE SCROLL VIEW START SLIGHTLY LOWER, ALSO ADJUST WHEN SCROLL UP/DOWN
            
            
            
            
            
            
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(createStackView(notification:)), name: Notification.Name("reloadStackView"), object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(loggingOut(notification:)), name: Notification.Name("logOut"), object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(toExplore(notification:)), name: Notification.Name("toExploreNoti"), object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(cancelLoading(notification:)), name: Notification.Name("expTurnOffLoading"), object: nil)
            
        }
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
                                    newView.backgroundColor = UIColor(displayP3Red: 86.0 / 255.0, green: 84.0 / 255.0, blue: 213.0 / 255.0, alpha: 1)
                                    
                                    newButton.frame = CGRect(x: 0, y: 0, width: self.xWid, height: barHeight)
                                    newButton.setTitle("\(self.buttList.count - 1)", for: .normal)
                                    newButton.alpha = 0.1
                                    newButton.setTitleColor(newView.backgroundColor, for: .normal)
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
        stackView.subviews.forEach({vieww in
            stackView.removeArrangedSubview(vieww)
            vieww.removeFromSuperview()
        })
        buttList.removeAll()
        
        if(role == "Learner, Student, or Parent")
        {
            let _ = db.child("users").queryOrdered(byChild: "account_type").queryEqual(toValue: "Tutor or Teacher").observe(.value, with: { (snap) in
                 
                for child in snap.children
                {
                    let snap = child as! DataSnapshot
                    let dict = snap.value as! [String : Any]
                    let USERNAMe = dict["username"] as! String
                    if (dict["account_type"] as! String == "Tutor or Teacher")
                    {
                        self.createStackViewMember(passedUsername: USERNAMe)
                        self.loadCircle.isHidden = true
                    }
                }
                
            })
        } else if(role == "Tutor or Teacher")
        {
            let _ = db.child("users").queryOrdered(byChild: "account_type").queryEqual(toValue: "Learner, Student, or Parent").observe(.value, with: { (snap) in
                 
                for child in snap.children
                {
                    let snap = child as! DataSnapshot
                    let dict = snap.value as! [String : Any]
                    let USERNAMe = dict["username"] as! String
                    if (dict["account_type"] as! String == "Learner, Student, or Parent")
                    {
                        self.createStackViewMember(passedUsername: USERNAMe)
                        self.loadCircle.isHidden = true
                    }
                }
                
            })
        }
        
    }
    
    
    @objc func toExplore(notification: NSNotification)
    {
        if(isMe && continueLoad)
        {
            if(role == "Tutor or Teacher")
            {
                titleRef.text = "Explore Learners"
            } else if(role == "Learner, Student, or Parent")
            {
                titleRef.text = "Explore Tutors"
            } else
            {
                titleRef.text = "Explore"
            }
            loadCircle.isHidden = false
        } else if(!continueLoad)
        {
            continueLoad = true
        }
    }
    
    @objc func cancelLoading(notification: NSNotification)
    {
        continueLoad = false
        loadCircle.isHidden = true
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
    
    func setupLoadCircle()
    {
        ogtime = CACurrentMediaTime()
        circle = UIBezierPath(arcCenter: CGPoint(x: 50.0, y: 50.0), radius: 25, startAngle: 0, endAngle: 1.57, clockwise: true)
        shapeLayer = CAShapeLayer()
        loadCircle = UIView()
        shapeLayer.path = circle.cgPath
        shapeLayer.strokeColor = UIColor(displayP3Red: 1, green: 1, blue: 1, alpha: 1).cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = 3.0
        loadCircle.translatesAutoresizingMaskIntoConstraints = false
        loadCircle.isHidden = false
        self.view.addSubview(loadCircle)
        loadCircle.backgroundColor = UIColor.clear
        loadCircle.layer.insertSublayer(shapeLayer, at: 0)
        loadCircle.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        loadCircle.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        loadCircle.widthAnchor.constraint(equalToConstant: 100.0).isActive = true
        loadCircle.heightAnchor.constraint(equalToConstant: 100.0).isActive = true
    }
    
    @objc func loadAnimations()
    {
        if(isMe)
        {
            time = CACurrentMediaTime()
            let startAng: CGFloat = CGFloat((time - ogtime) * 12.0 + sin((time - ogtime) * 8.0) * 0.9)
            let endAng: CGFloat = CGFloat(((time - ogtime) * 12.0 + 1.5) + sin((time - ogtime) * 8.0 + 1.0) * 0.9)
            circle = UIBezierPath(arcCenter: CGPoint(x: 50.0, y: 50.0), radius: 25, startAngle: startAng, endAngle: endAng, clockwise: true)
            shapeLayer.path = circle.cgPath
        }
    }
    
    @objc func keyboardWillShow(notification: NSNotification)
    {
        if(menuToggle && isMe)
        {
            NotificationCenter.default.post(name: Notification.Name("closeMenuTab"), object: nil)
        }
        /*if(currScene == "Explore" && isMe)
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
        if(isMe)
        {
            /*if(currScene == "Explore")
            {
                self.view.frame.origin.y = 0
                self.view.layoutIfNeeded()
            }*/
        }
    }
    
    @objc func createStackView(notification: NSNotification)
    {
        if(isMe)
        {
            loadStackView()
        }
    }
    
    @objc func listItemSelected(_ sender: UIButton)
    {
        let number = Int(sender.title(for: .normal)!)! + 1
    }
    
    @objc func loggingOut(notification: NSNotification)
    {
        if(isMe)
        {
            isMe = false
        }
    }
    
    
}
