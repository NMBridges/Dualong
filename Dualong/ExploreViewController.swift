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

var requests: [String]! = []

class ExploreViewController: UIViewController, UISearchBarDelegate, UITextViewDelegate, UIScrollViewDelegate, UIGestureRecognizerDelegate
{

    @IBOutlet weak var scrollViewRef: UIScrollView!
    
    @IBOutlet weak var stackView: UIStackView!
    
    @IBOutlet weak var searchBarRef: UISearchBar!
    
    @IBOutlet weak var titleRef: UILabel!
    
    @IBOutlet weak var requestButRef: UIButton!
    
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
    
    var addReqView: UIView! = UIView()
    var reqCVR: [NSLayoutConstraint]! = []
    var addRVBC: UIView! = UIView()
    var addRVTC: UIColor = UIColor(displayP3Red: 115.0 / 255.0, green: 105.0 / 255.0, blue: 220.0 / 255.0, alpha: 1.0)
    var addRVBOOL: Bool = false
    var closeRVBut: UIButton! = UIButton()
    var reqTextView: UITextView! = UITextView()
    var tvCVR: [NSLayoutConstraint]! = []
    var postReqButt: UIButton! = UIButton()
    var prqCV: [NSLayoutConstraint]! = []
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        
        if(isMe)
        {
            
            scrollViewRef.delegate = self
            scrollViewRef.isScrollEnabled = true
            
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
            NotificationCenter.default.addObserver(self, selector: #selector(closeRequest(notification:)), name: Notification.Name("closeRequest"), object: nil)
            
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
                                    newView.layer.cornerRadius = 15.0
                                    
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
    
    func createRequestStackViewMember(passedUsername: String, req: String)
    {
        let tUsername: String = passedUsername
        var tEmail: String = ""
        var tName: String = ""
        var tImage: UIImage!
        let barHeight = CGFloat(200)
        let newView = UIView()
        let newButton = UIButton()
        var newImage: UIImageView! = UIImageView()
        let newName = UILabel()
        let newReq = UILabel()
        
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
                            
                            newView.heightAnchor.constraint(equalToConstant: barHeight * 0.35 + req.heightWithConstrainedWidth(width: self.scrollViewRef.frame.width, font: UIFont(name: "HelveticaNeue", size: 20.0)!)).isActive = true
                            newView.backgroundColor = UIColor(displayP3Red: 86.0 / 255.0, green: 84.0 / 255.0, blue: 213.0 / 255.0, alpha: 1)
                            newView.layer.cornerRadius = 15.0
                            
                            newButton.frame = CGRect(x: 0, y: 0, width: self.xWid, height: barHeight)
                            newButton.setTitle("\(self.buttList.count - 1)", for: .normal)
                            newButton.alpha = 0.1
                            newButton.setTitleColor(newView.backgroundColor, for: .normal)
                            self.buttList.append(newButton)
                            self.buttList[self.buttList.count - 1].addTarget(self, action: #selector(self.listItemSelected), for: UIControl.Event.touchUpInside)
                            
                            if(tUsername == username)
                            {
                                newName.text = "Your Tutoring Requests"
                                newName.frame = CGRect(x: barHeight * 0.05, y: 0, width: self.xWid - barHeight, height: barHeight * 0.3)
                            } else
                            {
                                newName.text = tName
                                newName.frame = CGRect(x: barHeight * 0.3, y: 0, width: self.xWid - barHeight, height: barHeight * 0.3)
                            }
                            newName.font = UIFont(name: "HelveticaNeue-Bold", size: 25.0)
                            newName.textColor = UIColor.white
                            newName.isUserInteractionEnabled = false
                            
                            newReq.text = req
                            newReq.font = UIFont(name: "HelveticaNeue", size: 20.0)
                            newReq.textColor = UIColor.white
                            newReq.alpha = 0.5
                            newReq.lineBreakMode = .byWordWrapping
                            newReq.numberOfLines = 0
                            newReq.textAlignment = .left
                            newView.addSubview(newReq)
                            newReq.translatesAutoresizingMaskIntoConstraints = false
                            newReq.removeConstraints(newReq.constraints)
                            newReq.leadingAnchor.constraint(equalTo: newView.leadingAnchor, constant: barHeight * 0.05).isActive = true
                            newReq.trailingAnchor.constraint(equalTo: newView.trailingAnchor, constant: -barHeight * 0.05).isActive = true
                            newReq.topAnchor.constraint(equalTo: newView.topAnchor, constant: barHeight * 0.3).isActive = true
                            newReq.bottomAnchor.constraint(equalTo: newView.bottomAnchor, constant: -barHeight * 0.05).isActive = true
                            //newReq.widthAnchor.constraint(equalTo: newView.widthAnchor).isActive = true
                            
                            newImage = UIImageView(image: UIImage(named: "defaultProfileImageSolid"))
                            newImage.layer.borderWidth = 1
                            newImage.layer.masksToBounds = false
                            newImage.frame = CGRect(x: barHeight * 0.05, y: barHeight * 0.05, width: barHeight * 0.2, height: barHeight * 0.2)
                            newImage.layer.borderColor = UIColor.white.cgColor
                            newImage.layer.cornerRadius = newImage.frame.height / 2.0
                            newImage.clipsToBounds = true
                            
                            newView.addSubview(self.buttList[self.buttList.count - 1])
                            newView.addSubview(newName)
                            //newView.addSubview(newReq)
                            if(tUsername != username)
                            {
                                newView.addSubview(newImage)
                            }
                            
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
    
    @IBAction func addRequestButton(_ sender: UIButton)
    {
        if(isMe)
        {
            addRVBOOL = true
            addReqView = UIView()
            addReqView.isHidden = false
            self.view.addSubview(addReqView)
            addReqView.backgroundColor = addRVTC
            addReqView.backgroundColor?.withAlphaComponent(0.0)
            addReqView.alpha = 1.0
            addReqView.layer.cornerRadius = 15.0
            addReqView.layer.borderWidth = 1.0
            addReqView.layer.borderColor = UIColor.clear.cgColor
            addReqView.translatesAutoresizingMaskIntoConstraints = false
            addReqView.removeConstraints(addReqView.constraints)
            reqCVR.removeAll()
            reqCVR.append(addReqView.trailingAnchor.constraint(equalTo: requestButRef.trailingAnchor))
            reqCVR[0].isActive = true
            reqCVR.append(addReqView.topAnchor.constraint(equalTo: requestButRef.topAnchor))
            reqCVR[1].isActive = true
            reqCVR.append(addReqView.leadingAnchor.constraint(equalTo: requestButRef.trailingAnchor, constant: -30.0))
            reqCVR[2].isActive = true
            reqCVR.append(addReqView.bottomAnchor.constraint(equalTo: requestButRef.topAnchor, constant: 30.0))
            reqCVR[3].isActive = true
            reqCVR.append(addReqView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -5.0))
            reqCVR[4].isActive = false
            reqCVR.append(addReqView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 50))
            reqCVR[5].isActive = false
            reqCVR.append(addReqView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 5.0))
            reqCVR[6].isActive = false
            reqCVR.append(addReqView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 275 + UIScreen.main.bounds.width * 0.12))
            reqCVR[7].isActive = false
            
            addRVBC = UIView()
            addRVBC.isHidden = false
            addReqView.addSubview(addRVBC)
            addRVBC.alpha = 1.0
            addRVBC.backgroundColor = UIColor.systemIndigo
            addRVBC.translatesAutoresizingMaskIntoConstraints = false
            addRVBC.removeConstraints(addRVBC.constraints)
            addRVBC.trailingAnchor.constraint(equalTo: requestButRef.trailingAnchor).isActive = true
            addRVBC.leadingAnchor.constraint(equalTo: requestButRef.leadingAnchor).isActive = true
            addRVBC.topAnchor.constraint(equalTo: requestButRef.topAnchor).isActive = true
            addRVBC.bottomAnchor.constraint(equalTo: requestButRef.bottomAnchor).isActive = true
            
            closeRVBut = UIButton()
            closeRVBut.isHidden = false
            addReqView.addSubview(closeRVBut)
            closeRVBut.alpha = 1.0
            closeRVBut.translatesAutoresizingMaskIntoConstraints = false
            closeRVBut.removeConstraints(closeRVBut.constraints)
            closeRVBut.setTitle("", for: .normal)
            closeRVBut.trailingAnchor.constraint(equalTo: requestButRef.trailingAnchor).isActive = true
            closeRVBut.leadingAnchor.constraint(equalTo: requestButRef.leadingAnchor).isActive = true
            closeRVBut.topAnchor.constraint(equalTo: requestButRef.topAnchor).isActive = true
            closeRVBut.bottomAnchor.constraint(equalTo: requestButRef.bottomAnchor).isActive = true
            closeRVBut.setBackgroundImage(UIImage(systemName: "plus"), for: .normal)
            closeRVBut.tintColor = UIColor.white
            closeRVBut.transform = closeRVBut.transform.rotated(by: 0.0)
            closeRVBut.addTarget(self, action: #selector(closeRequestButton(_:)), for: UIControl.Event.touchUpInside)
            addReqView.bringSubviewToFront(closeRVBut)
            
            reqTextView = UITextView()
            reqTextView.isHidden = false
            addReqView.addSubview(reqTextView)
            reqTextView.alpha = 0.0
            reqTextView.translatesAutoresizingMaskIntoConstraints = false
            reqTextView.removeConstraints(reqTextView.constraints)
            reqTextView.text = "tutoring request details..."
            reqTextView.delegate = self
            reqTextView.backgroundColor = UIColor(displayP3Red: 120 / 255, green: 114 / 255, blue: 225 / 255, alpha: 1)
            reqTextView.textColor = UIColor.white
            reqTextView.font = UIFont(name: "HelveticaNeue", size: 17.0)
            tvCVR.removeAll()
            tvCVR.append(reqTextView.trailingAnchor.constraint(equalTo: addReqView.trailingAnchor, constant: -10.0))
            tvCVR[0].isActive = true
            tvCVR.append(reqTextView.topAnchor.constraint(equalTo: addReqView.topAnchor, constant: 10.0))
            tvCVR[1].isActive = true
            tvCVR.append(reqTextView.leadingAnchor.constraint(equalTo: addReqView.leadingAnchor, constant: 10.0))
            tvCVR[2].isActive = true
            tvCVR.append(reqTextView.bottomAnchor.constraint(equalTo: addReqView.bottomAnchor, constant: -10.0))
            tvCVR[3].isActive = true
            tvCVR.append(reqTextView.trailingAnchor.constraint(equalTo: addReqView.trailingAnchor, constant: -25.0))
            tvCVR[4].isActive = false
            tvCVR.append(reqTextView.topAnchor.constraint(equalTo: addReqView.topAnchor, constant: 55.0))
            tvCVR[5].isActive = false
            tvCVR.append(reqTextView.leadingAnchor.constraint(equalTo: addReqView.leadingAnchor, constant: 25.0))
            tvCVR[6].isActive = false
            tvCVR.append(reqTextView.bottomAnchor.constraint(equalTo: addReqView.topAnchor, constant: 175.0))
            tvCVR[7].isActive = false
            
            postReqButt = UIButton()
            postReqButt.isHidden = false
            addReqView.addSubview(postReqButt)
            postReqButt.alpha = 0.0
            postReqButt.translatesAutoresizingMaskIntoConstraints = false
            postReqButt.removeConstraints(postReqButt.constraints)
            postReqButt.setTitle("Post", for: .normal)
            postReqButt.titleLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: UIScreen.main.bounds.width * 0.05)
            postReqButt.backgroundColor = UIColor(displayP3Red: 120 / 255, green: 114 / 255, blue: 225 / 255, alpha: 1)
            prqCV.removeAll()
            prqCV.append(postReqButt.trailingAnchor.constraint(equalTo: requestButRef.trailingAnchor, constant: 0.0))
            prqCV[0].isActive = true
            prqCV.append(postReqButt.leadingAnchor.constraint(equalTo: requestButRef.trailingAnchor, constant: -30.0))
            prqCV[1].isActive = true
            prqCV.append(postReqButt.topAnchor.constraint(equalTo: requestButRef.topAnchor, constant: 0.0))
            prqCV[2].isActive = true
            prqCV.append(postReqButt.bottomAnchor.constraint(equalTo: requestButRef.topAnchor, constant: 30.0))
            prqCV[3].isActive = true
            prqCV.append(postReqButt.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -UIScreen.main.bounds.width * 0.25))
            prqCV[4].isActive = false
            prqCV.append(postReqButt.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: UIScreen.main.bounds.width * 0.25))
            prqCV[5].isActive = false
            prqCV.append(postReqButt.topAnchor.constraint(equalTo: reqTextView.bottomAnchor, constant: 25))
            prqCV[6].isActive = false
            prqCV.append(postReqButt.bottomAnchor.constraint(equalTo: reqTextView.bottomAnchor, constant: 25 + UIScreen.main.bounds.width * 0.12))
            prqCV[7].isActive = false
            postReqButt.addTarget(self, action: #selector(postRequestButton(_:)), for: UIControl.Event.touchUpInside)
            addReqView.bringSubviewToFront(postReqButt)
            
            self.view.layoutIfNeeded()
            
            UIView.animate(withDuration: 0.2)
            {
                self.reqCVR[0].isActive = false
                self.reqCVR[1].isActive = false
                self.reqCVR[2].isActive = false
                self.reqCVR[3].isActive = false
                
                self.tvCVR[0].isActive = false
                self.tvCVR[1].isActive = false
                self.tvCVR[2].isActive = false
                self.tvCVR[3].isActive = false
                
                self.prqCV[0].isActive = false
                self.prqCV[1].isActive = false
                self.prqCV[2].isActive = false
                self.prqCV[3].isActive = false
                
                self.reqCVR[4].isActive = true
                self.reqCVR[5].isActive = true
                self.reqCVR[6].isActive = true
                self.reqCVR[7].isActive = true
                
                self.tvCVR[4].isActive = true
                self.tvCVR[5].isActive = true
                self.tvCVR[6].isActive = true
                self.tvCVR[7].isActive = true
                
                self.prqCV[4].isActive = true
                self.prqCV[5].isActive = true
                self.prqCV[6].isActive = true
                self.prqCV[7].isActive = true
                
                //self.addReqView.layer.cornerRadius = 0.0
                self.addReqView.backgroundColor = self.addRVTC
                self.addReqView.layer.borderColor = UIColor.white.cgColor
                
                self.addRVBC.backgroundColor = self.addRVTC
                
                self.closeRVBut.transform = self.closeRVBut.transform.rotated(by: .pi / 4.0)

                self.reqTextView.alpha = 1.0
                
                self.postReqButt.alpha = 1.0
                
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc func closeRequestButton(_ sender: UIButton!)
    {
        if(isMe)
        {
            self.view.layoutIfNeeded()
            
            UIView.animate(withDuration: 0.2, animations: {
                
                self.reqCVR[4].isActive = false
                self.reqCVR[5].isActive = false
                self.reqCVR[6].isActive = false
                self.reqCVR[7].isActive = false
                
                self.tvCVR[4].isActive = false
                self.tvCVR[5].isActive = false
                self.tvCVR[6].isActive = false
                self.tvCVR[7].isActive = false
                
                self.prqCV[4].isActive = false
                self.prqCV[5].isActive = false
                self.prqCV[6].isActive = false
                self.prqCV[7].isActive = false
                
                self.reqCVR[0].isActive = true
                self.reqCVR[1].isActive = true
                self.reqCVR[2].isActive = true
                self.reqCVR[3].isActive = true
                
                self.tvCVR[0].isActive = true
                self.tvCVR[1].isActive = true
                self.tvCVR[2].isActive = true
                self.tvCVR[3].isActive = true
                
                self.prqCV[0].isActive = true
                self.prqCV[1].isActive = true
                self.prqCV[2].isActive = true
                self.prqCV[3].isActive = true
                
                //self.addReqView.layer.cornerRadius = 0.0
                self.addReqView.backgroundColor = UIColor(displayP3Red: 115.0 / 255.0, green: 105.0 / 255.0, blue: 220.0 / 255.0, alpha: 0.0)
                self.addReqView.layer.borderColor = UIColor.clear.cgColor
                
                self.addRVBC.backgroundColor = UIColor.systemIndigo
                
                self.closeRVBut.transform = self.closeRVBut.transform.rotated(by: .pi / 4.0)
                self.closeRVBut.alpha = 1.0
                
                self.reqTextView.alpha = 0.0

                self.postReqButt.alpha = 0.0
                
                self.view.layoutIfNeeded()
            }) { _ in
                self.closeRVBut.removeFromSuperview()
                self.reqTextView.removeFromSuperview()
                self.postReqButt.removeFromSuperview()
                self.addRVBC.removeFromSuperview()
                self.addReqView.removeFromSuperview()
                self.view.layoutIfNeeded()
            }
        }
    }
    
    
    
    @objc func closeRequest(notification: NSNotification)
    {
        if(isMe && addRVBOOL)
        {
            self.view.layoutIfNeeded()
            
            UIView.animate(withDuration: 0.1, animations: {
                
                self.reqCVR[4].isActive = false
                self.reqCVR[5].isActive = false
                self.reqCVR[6].isActive = false
                self.reqCVR[7].isActive = false
                
                self.tvCVR[4].isActive = false
                self.tvCVR[5].isActive = false
                self.tvCVR[6].isActive = false
                self.tvCVR[7].isActive = false
                
                self.prqCV[4].isActive = false
                self.prqCV[5].isActive = false
                self.prqCV[6].isActive = false
                self.prqCV[7].isActive = false
                
                self.reqCVR[0].isActive = true
                self.reqCVR[1].isActive = true
                self.reqCVR[2].isActive = true
                self.reqCVR[3].isActive = true
                
                self.tvCVR[0].isActive = true
                self.tvCVR[1].isActive = true
                self.tvCVR[2].isActive = true
                self.tvCVR[3].isActive = true
                
                self.prqCV[0].isActive = true
                self.prqCV[1].isActive = true
                self.prqCV[2].isActive = true
                self.prqCV[3].isActive = true
                
                //self.addReqView.layer.cornerRadius = 0.0
                self.addReqView.backgroundColor = UIColor(displayP3Red: 115.0 / 255.0, green: 105.0 / 255.0, blue: 220.0 / 255.0, alpha: 0.0)
                self.addReqView.layer.borderColor = UIColor.clear.cgColor
                
                self.addRVBC.backgroundColor = UIColor.systemIndigo
                
                self.closeRVBut.transform = self.closeRVBut.transform.rotated(by: .pi / 4.0)
                self.closeRVBut.alpha = 1.0

                self.reqTextView.alpha = 0.0
                
                self.postReqButt.alpha = 0.0
                
                self.view.layoutIfNeeded()
            }) { _ in
                self.closeRVBut.removeFromSuperview()
                self.reqTextView.removeFromSuperview()
                self.postReqButt.removeFromSuperview()
                self.addRVBC.removeFromSuperview()
                self.addReqView.removeFromSuperview()
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc func postRequestButton(_ sender: UIButton!)
    {
        if(reqTextView.text != "" && reqTextView.text != "tutoring request details..." && isMe)
        {
            requests.append(reqTextView.text)
            for i in 0...(requests.count - 1)
            {
                db.child("users/\(userEmail!)/requests/\(i)").setValue(requests[i])
            }
            
            self.view.layoutIfNeeded()
            
            UIView.animate(withDuration: 0.1, animations: {
                
                self.reqCVR[4].isActive = false
                self.reqCVR[5].isActive = false
                self.reqCVR[6].isActive = false
                self.reqCVR[7].isActive = false
                
                self.tvCVR[4].isActive = false
                self.tvCVR[5].isActive = false
                self.tvCVR[6].isActive = false
                self.tvCVR[7].isActive = false
                
                self.prqCV[4].isActive = false
                self.prqCV[5].isActive = false
                self.prqCV[6].isActive = false
                self.prqCV[7].isActive = false
                
                self.reqCVR[0].isActive = true
                self.reqCVR[1].isActive = true
                self.reqCVR[2].isActive = true
                self.reqCVR[3].isActive = true
                
                self.tvCVR[0].isActive = true
                self.tvCVR[1].isActive = true
                self.tvCVR[2].isActive = true
                self.tvCVR[3].isActive = true
                
                self.prqCV[0].isActive = true
                self.prqCV[1].isActive = true
                self.prqCV[2].isActive = true
                self.prqCV[3].isActive = true
                
                //self.addReqView.layer.cornerRadius = 0.0
                self.addReqView.backgroundColor = UIColor(displayP3Red: 115.0 / 255.0, green: 105.0 / 255.0, blue: 220.0 / 255.0, alpha: 0.0)
                self.addReqView.layer.borderColor = UIColor.clear.cgColor
                
                self.addRVBC.backgroundColor = UIColor.systemIndigo
                
                self.closeRVBut.transform = self.closeRVBut.transform.rotated(by: .pi / 4.0)
                self.closeRVBut.alpha = 1.0

                self.reqTextView.alpha = 0.0
                
                self.postReqButt.alpha = 0.0
                
                self.view.layoutIfNeeded()
            }) { _ in
                self.closeRVBut.removeFromSuperview()
                self.reqTextView.removeFromSuperview()
                self.postReqButt.removeFromSuperview()
                self.addRVBC.removeFromSuperview()
                self.addReqView.removeFromSuperview()
                self.view.layoutIfNeeded()
            }
        }
    }
    
    
    // make it so it doesn't load users for tutors but instead loads tutoring requests
    
    
    
    
    
    
    
    
    
    func loadStackView()
    {
        stackView.subviews.forEach({vieww in
            stackView.removeArrangedSubview(vieww)
            vieww.removeFromSuperview()
        })
        buttList.removeAll()
        
        if(role == "Learner, Student, or Parent")
        {
            requestButRef.isHidden = false
            
            requests.forEach { beep in
                self.createRequestStackViewMember(passedUsername: username, req: beep)
            }
            
            let _ = db.child("users").queryOrdered(byChild: "account_type").queryEqual(toValue: "Tutor or Teacher").observe(.value, with: { (snap) in
                 
                for child in snap.children
                {
                    let snap = child as! DataSnapshot
                    let dict = snap.value as! [String : Any]
                    let NAMe = dict["name"] as! String
                    let USERNAMe = dict["username"] as! String
                    if (dict["account_type"] as! String == "Tutor or Teacher")
                    {
                        if let intChildren = snap.childSnapshot(forPath: "interests").children.allObjects as? [DataSnapshot]
                        {
                            var intListT: [String]! = []
                            for child2 in intChildren
                            {
                                intListT.append((child2.value as? String)!)
                            }
                            let contains: Bool = !Set(interests).isDisjoint(with: Set(intListT))
                            if(contains)
                            {
                                if(self.searchBarRef.text! == "" || USERNAMe.contains(self.searchBarRef.text!) || NAMe.contains(self.searchBarRef.text!))
                                {
                                    self.createStackViewMember(passedUsername: USERNAMe)
                                    self.loadCircle.isHidden = true
                                }
                            }
                        }
                    }
                }
                
            })
        } else if(role == "Tutor or Teacher")
        {
            requestButRef.isHidden = true
            let _ = db.child("users").queryOrdered(byChild: "account_type").queryEqual(toValue: "Learner, Student, or Parent").observe(.value, with: { (snap) in
                 
                for child in snap.children
                {
                    let snap = child as! DataSnapshot
                    let dict = snap.value as! [String : Any]
                    let NAMe = dict["name"] as! String
                    let USERNAMe = dict["username"] as! String
                    if let REQUESTs = dict["requests"] as! [String]?
                    {
                        if (dict["account_type"] as! String == "Learner, Student, or Parent" && REQUESTs.count != 0)
                        {
                            if let intChildren = snap.childSnapshot(forPath: "interests").children.allObjects as? [DataSnapshot]
                            {
                                var intListT: [String]! = []
                                for child2 in intChildren
                                {
                                    intListT.append((child2.value as? String)!)
                                }
                                let contains: Bool = !Set(interests).isDisjoint(with: Set(intListT))
                                if(contains)
                                {
                                    if(self.searchBarRef.text! == "" || USERNAMe.lowercased().contains(self.searchBarRef.text!.lowercased()) || NAMe.lowercased().contains(self.searchBarRef.text!.lowercased()))
                                    {
                                        REQUESTs.forEach { request in
                                            self.createRequestStackViewMember(passedUsername: USERNAMe, req: request)
                                            self.loadCircle.isHidden = true
                                        }
                                        
                                    }
                                }
                            }
                        }
                    }
                }
                
            })
        }
        
    }
    
    func textViewDidBeginEditing(_ textView: UITextView)
    {
        if(textView.text == "tutoring request details...")
        {
            textView.text = ""
        }
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar)
    {
        if(isMe)
        {
            loadStackView()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        if(isMe)
        {
            loadStackView()
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
        let _ = Int(sender.title(for: .normal)!)! + 1
    }
    
    @objc func loggingOut(notification: NSNotification)
    {
        if(isMe)
        {
            isMe = false
        }
    }
    
    
}

extension String
{
    func heightWithConstrainedWidth(width: CGFloat, font: UIFont) -> CGFloat
    {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [NSAttributedString.Key.font: font], context: nil)
        return boundingBox.height
    }
}
