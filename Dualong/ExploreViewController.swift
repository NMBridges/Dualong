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
    var noRotationReq: UIButton = UIButton()
    
    var cachedUsernames: [String]! = []
    var cachedNames: [String]! = []
    var cachedProfPics: [UIImage]! = []
    var cachedRequests: [String]! = []
    
    var popupView = UIView()
    var ppcvr: [NSLayoutConstraint]! = []
    var popupBOOL: Bool = false
    var closePUBut: UIButton! = UIButton()
    var noRotationPop: UIButton! = UIButton()
    var pupp: UIImageView! = UIImageView()
    var puppVR: [NSLayoutConstraint]! = []
    var puUsername: UILabel! = UILabel()
    var puusVR: [NSLayoutConstraint]! = []
    var puName: UILabel! = UILabel()
    var makeConn: UIButton! = UIButton()
    
    var delView = UIView()
    var dcvr: [NSLayoutConstraint]! = []
    var delBOOL: Bool = false
    var closeDUBut: UIButton! = UIButton()
    var noRotationDel: UIButton! = UIButton()
    var delReqBU: UIButton! = UIButton()
    
    var popUP: Bool = false
    var delUP: Bool = false
    
    var dimView: UIView! = UIView()
    
    var lastPressed: Int = -1
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        
        if(isMe)
        {
            
            scrollViewRef.delegate = self
            scrollViewRef.isScrollEnabled = true
            
            let closeTap = UITapGestureRecognizer(target: self, action: #selector(closeMenus))
            closeTap.cancelsTouchesInView = false
            closeTap.delegate = self
            view.addGestureRecognizer(closeTap)
            
            searchBarRef.delegate = self
            searchBarRef.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
            
            setupLoadCircle()
            displayLink = CADisplayLink(target: self, selector: #selector(loadAnimations))
            displayLink.add(to: RunLoop.main, forMode: .default)
            
            dimView = UIView()
            self.view.addSubview(dimView)
            dimView.translatesAutoresizingMaskIntoConstraints = false
            dimView.removeConstraints(dimView.constraints)
            dimView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
            dimView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
            dimView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
            dimView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
            dimView.backgroundColor = UIColor.black
            dimView.alpha = 0.0
            
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
    
    func createStackViewMember(passedUsername: String, cc: Int)
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
                            self.cachedNames[cc] = tName
                            self.cachedUsernames[cc] = tUsername
                            self.cachedProfPics[cc] = UIImage(named: "defaultProfileImageSolid")!
                            
                            self.db.child("users/\(tEmail)/account_type").observeSingleEvent(of: .value)
                            { (snapshot2) in
                                if let helper2 = snapshot2.value as? String
                                {
                                    tRole = helper2
                                    
                                    newView.heightAnchor.constraint(equalToConstant: barHeight).isActive = true
                                    newView.backgroundColor = UIColor(displayP3Red: 86.0 / 255.0, green: 84.0 / 255.0, blue: 213.0 / 255.0, alpha: 1)
                                    newView.layer.cornerRadius = 15.0
                                    
                                    newButton.frame = CGRect(x: 0, y: 0, width: self.xWid - 10.0, height: barHeight)
                                    newButton.setTitle("\(cc)", for: .normal)
                                    newButton.alpha = 0.1
                                    newButton.setTitleColor(newView.backgroundColor, for: .normal)
                                    self.buttList[cc] = newButton
                                    self.buttList[cc].addTarget(self, action: #selector(self.listItemSelected), for: UIControl.Event.touchUpInside)
                                    
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
                                    
                                    newView.addSubview(self.buttList[cc])
                                    newView.addSubview(newName)
                                    newView.addSubview(newRole)
                                    newView.addSubview(newImage)
                                    
                                    self.stackView.insertArrangedSubview(newView, at: cc)
                                    
                                    self.st.child("profilepics/\(tUsername).jpg").getData(maxSize: 4 * 1024 * 1024, completion: { (data, error) in
                                        if error != nil
                                        {
                                            print("error loading image \(error!)")
                                        }
                                        if let data = data
                                        {
                                            tImage = UIImage(data: data)!
                                            newImage.image = tImage
                                            self.cachedProfPics[cc] = tImage
                                        }
                                    })
                                    
                                    self.loadCircle.isHidden = true
                                    
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
    
    func createRequestStackViewMember(passedUsername: String, req: String, cc: Int)
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

                            self.cachedUsernames[cc] = tUsername
                            self.cachedRequests[cc] = req
                            self.cachedNames[cc] = tName
                            
                            newView.heightAnchor.constraint(equalToConstant: barHeight * 0.35 + req.heightWithConstrainedWidth(width: self.scrollViewRef.frame.width, font: UIFont(name: "HelveticaNeue", size: 20.0)!)).isActive = true
                            newView.backgroundColor = UIColor(displayP3Red: 86.0 / 255.0, green: 84.0 / 255.0, blue: 213.0 / 255.0, alpha: 1)
                            newView.layer.cornerRadius = 15.0
                            
                            newButton.frame = CGRect(x: 0.0, y: 0.0, width: self.xWid - 10.0, height: barHeight * 0.35 + req.heightWithConstrainedWidth(width: self.scrollViewRef.frame.width, font: UIFont(name: "HelveticaNeue", size: 20.0)!))
                            newButton.setTitle("\(cc)", for: .normal)
                            newButton.alpha = 0.1
                            newButton.setTitleColor(newView.backgroundColor, for: .normal)
                            self.buttList[cc] = newButton
                            self.buttList[cc].addTarget(self, action: #selector(self.listItemSelected), for: UIControl.Event.touchUpInside)
                            
                            if(tUsername == username)
                            {
                                newName.text = "Your Tutoring Request"
                                newName.frame = CGRect(x: barHeight * 0.05, y: 0, width: self.xWid - barHeight * 0.05, height: barHeight * 0.3)
                            } else
                            {
                                newName.text = tName
                                newName.frame = CGRect(x: barHeight * 0.3, y: 0, width: self.xWid - barHeight * 0.3, height: barHeight * 0.3)
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
                            
                            newView.addSubview(self.buttList[cc])
                            newView.addSubview(newName)
                            
                            if(tUsername != username)
                            {
                                newImage = UIImageView(image: UIImage(named: "defaultProfileImageSolid"))
                                newImage.layer.borderWidth = 1
                                newImage.layer.masksToBounds = false
                                newImage.frame = CGRect(x: barHeight * 0.05, y: barHeight * 0.05, width: barHeight * 0.2, height: barHeight * 0.2)
                                newImage.layer.borderColor = UIColor.white.cgColor
                                newImage.layer.cornerRadius = newImage.frame.height / 2.0
                                newImage.clipsToBounds = true
                                newView.addSubview(newImage)
                                self.stackView.insertArrangedSubview(newView, at: cc)
                            } else
                            {
                                self.stackView.insertArrangedSubview(newView, at: cc)
                            }
                            
                            
                            
                            
                            if(tUsername != username)
                            {
                                self.st.child("profilepics/\(tUsername).jpg").getData(maxSize: 4 * 1024 * 1024, completion: { (data, error) in
                                    if error != nil
                                    {
                                        print("error loading image \(error!)")
                                    }
                                    if let data = data
                                    {
                                        tImage = UIImage(data: data)!
                                        newImage.image = tImage
                                        self.cachedProfPics[cc] = tImage
                                    }
                                })
                            } else
                            {
                                self.cachedProfPics[cc] = UIImage()
                            }

                            self.loadCircle.isHidden = true
                            
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
            
            self.dimView.alpha = 0.0
            
            if(!addRVBOOL)
            {
                addReqView = UIView()
                self.view.addSubview(addReqView)
                addReqView.translatesAutoresizingMaskIntoConstraints = false
                addReqView.removeConstraints(addReqView.constraints)
                reqCVR.removeAll()
                reqCVR = []
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
            }
            addReqView.isHidden = false
            addReqView.backgroundColor = addRVTC
            addReqView.backgroundColor?.withAlphaComponent(0.0)
            addReqView.alpha = 1.0
            addReqView.layer.cornerRadius = 15.0
            addReqView.layer.borderWidth = 0.0
            addReqView.layer.borderColor = UIColor.clear.cgColor
            
            if(!addRVBOOL)
            {
                addRVBC = UIView()
                addReqView.addSubview(addRVBC)
                addRVBC.translatesAutoresizingMaskIntoConstraints = false
                addRVBC.removeConstraints(addRVBC.constraints)
                addRVBC.trailingAnchor.constraint(equalTo: requestButRef.trailingAnchor).isActive = true
                addRVBC.leadingAnchor.constraint(equalTo: requestButRef.trailingAnchor, constant: -30).isActive = true
                addRVBC.topAnchor.constraint(equalTo: requestButRef.topAnchor).isActive = true
                addRVBC.bottomAnchor.constraint(equalTo: requestButRef.topAnchor, constant: 30).isActive = true
            }
            addRVBC.isHidden = false
            addRVBC.alpha = 1.0
            addRVBC.backgroundColor = UIColor.systemIndigo
            
            if(!addRVBOOL)
            {
                closeRVBut = UIButton()
                addReqView.addSubview(closeRVBut)
                closeRVBut.translatesAutoresizingMaskIntoConstraints = false
                closeRVBut.removeConstraints(closeRVBut.constraints)
                closeRVBut.trailingAnchor.constraint(equalTo: requestButRef.trailingAnchor).isActive = true
                closeRVBut.leadingAnchor.constraint(equalTo: requestButRef.trailingAnchor, constant: -30).isActive = true
                closeRVBut.topAnchor.constraint(equalTo: requestButRef.topAnchor).isActive = true
                closeRVBut.bottomAnchor.constraint(equalTo: requestButRef.topAnchor, constant: 30).isActive = true
                closeRVBut.addTarget(self, action: #selector(closeRequestButton(_:)), for: UIControl.Event.touchUpInside)
                noRotationReq.transform = closeRVBut.transform.rotated(by: 0.0)
            }
            closeRVBut.isHidden = false
            closeRVBut.alpha = 1.0
            closeRVBut.setTitle("", for: .normal)
            closeRVBut.setBackgroundImage(UIImage(systemName: "plus"), for: .normal)
            closeRVBut.tintColor = UIColor.white
            closeRVBut.transform = noRotationReq.transform
            addReqView.bringSubviewToFront(closeRVBut)
            
            if(!addRVBOOL)
            {
                reqTextView = UITextView()
                addReqView.addSubview(reqTextView)
                reqTextView.translatesAutoresizingMaskIntoConstraints = false
                reqTextView.removeConstraints(reqTextView.constraints)
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
            }
            reqTextView.layer.cornerRadius = 15.0
            reqTextView.isHidden = false
            reqTextView.alpha = 0.0
            reqTextView.text = "tutoring request details..."
            reqTextView.delegate = self
            reqTextView.backgroundColor = UIColor(displayP3Red: 120 / 255, green: 114 / 255, blue: 225 / 255, alpha: 1)
            reqTextView.textColor = UIColor.white
            reqTextView.font = UIFont(name: "HelveticaNeue", size: 17.0)
            
            if(!addRVBOOL)
            {
                postReqButt = UIButton()
                addReqView.addSubview(postReqButt)
                postReqButt.translatesAutoresizingMaskIntoConstraints = false
                postReqButt.removeConstraints(postReqButt.constraints)
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
            }
            postReqButt.layer.cornerRadius = UIScreen.main.bounds.width * 0.03
            postReqButt.isHidden = false
            postReqButt.alpha = 0.0
            postReqButt.setTitle("Post", for: .normal)
            postReqButt.titleLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: UIScreen.main.bounds.width * 0.05)
            postReqButt.backgroundColor = UIColor(displayP3Red: 120 / 255, green: 114 / 255, blue: 225 / 255, alpha: 1)
            addReqView.bringSubviewToFront(postReqButt)
            
            addRVBOOL = true
            
            view.endEditing(true)
            
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
                
                self.requestButRef.isUserInteractionEnabled = false
                
                //self.addReqView.layer.cornerRadius = 0.0
                self.addReqView.backgroundColor = self.addRVTC
                self.addReqView.layer.borderColor = UIColor.white.cgColor
                
                self.dimView.alpha = 0.5
                
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
            closeRequestTab()
        }
    }
    
    
    
    @objc func closeRequest(notification: NSNotification)
    {
        if(isMe && addRVBOOL)
        {
            closeRequestTab()
            if(self.ppcvr.count != 0)
            {
                self.ppcvr[2].isActive = false
                self.ppcvr[3].isActive = false
                self.puppVR[2].isActive = false
                self.puppVR[3].isActive = false
                self.ppcvr[0].isActive = true
                self.ppcvr[1].isActive = true
                self.puppVR[0].isActive = true
                self.puppVR[1].isActive = true
                self.closePUBut.alpha = 0.0
                self.pupp.alpha = 0.0
                self.puUsername.font = UIFont(name: "HelveticaNeue-Bold", size: 2.0)
                self.puUsername.alpha = 0.0
                self.puName.font = UIFont(name: "HelveticaNeue", size: 2.0)
                self.puName.alpha = 0.0
                self.dimView.alpha = 0.0
                self.popupView.backgroundColor = UIColor.clear
                self.popupView.layer.borderColor = UIColor.white.cgColor
                self.closePUBut.transform = self.closePUBut.transform.rotated(by: .pi / 4)
                self.popupView.isHidden = true
                self.view.layoutIfNeeded()
            }
        }
    }
    
    
    
    
    
    
    
    
    
    // fix switch tabs when popup open
    
    
    
    
    
    
    
    
    
    @objc func postRequestButton(_ sender: UIButton!)
    {
        if(reqTextView.text != "" && reqTextView.text != "tutoring request details..." && isMe)
        {
            requests.append("\(reqTextView.text!.prefix(500))")
            for i in 0...(requests.count - 1)
            {
                db.child("users/\(userEmail!)/requests/\(i)").setValue(requests[i])
            }
            
            closeRequestTab()
            loadStackView()
        }
    }
    
    func closeRequestTab()
    {
        if(addRVBOOL)
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
                
                self.dimView.alpha = 0.0
                
                self.closeRVBut.transform = self.closeRVBut.transform.rotated(by: .pi / 4.0)
                self.closeRVBut.alpha = 1.0

                self.reqTextView.alpha = 0.0
                
                self.postReqButt.alpha = 0.0
                
                self.view.layoutIfNeeded()
            }) { _ in
                self.addReqView.isHidden = true
                self.requestButRef.isUserInteractionEnabled = true
                self.view.layoutIfNeeded()
            }
        }
    }
    
    func loadStackView()
    {

        self.loadCircle.isHidden = false
        stackView.subviews.forEach({vieww in
            stackView.removeArrangedSubview(vieww)
            vieww.removeFromSuperview()
        })
        buttList.removeAll()
        buttList = []
        cachedNames = []
        cachedUsernames = []
        cachedProfPics = []
        cachedRequests = []
        
        if(role == "Learner, Student, or Parent")
        {
            requestButRef.isHidden = false
            
            var cc: Int = 0
            requests.forEach { _ in
                cachedNames.append("")
                cachedUsernames.append("")
                cachedRequests.append("")
                cachedProfPics.append(UIImage(named: "defaultProfileImageSolid")!)
                buttList.append(UIButton())
            }
            requests.forEach { beep in
                self.createRequestStackViewMember(passedUsername: username, req: beep, cc: cc)
                cc += 1
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
                                    self.cachedNames.append("")
                                    self.cachedUsernames.append("")
                                    self.cachedRequests.append("")
                                    self.cachedProfPics.append(UIImage(named: "defaultProfileImageSolid")!)
                                    self.buttList.append(UIButton())
                                    self.createStackViewMember(passedUsername: USERNAMe, cc: cc)
                                    cc += 1
                                }
                            }
                        }
                    }
                }
                
            })
        } else if(role == "Tutor or Teacher")
        {
            var pp: Int = 0
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
                                        
                                        REQUESTs.forEach { _ in
                                            self.cachedNames.append("")
                                            self.cachedUsernames.append("")
                                            self.cachedRequests.append("")
                                            self.cachedProfPics.append(UIImage(named: "defaultProfileImageSolid")!)
                                            self.buttList.append(UIButton())
                                        }
                                        REQUESTs.forEach { request in
                                            self.createRequestStackViewMember(passedUsername: USERNAMe, req: request, cc: pp)
                                            pp += 1
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
        if(textView.text == "tutoring request details..." && isMe && currScene == "Explore")
        {
            textView.text = ""
        }
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar)
    {
        if(isMe && currScene == "Explore")
        {
            loadStackView()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        if(isMe && currScene == "Explore")
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
        if(isMe)
        {
            continueLoad = false
            loadCircle.isHidden = true
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool
    {
        let isControllTapped = touch.view is UIControl
        return !isControllTapped
    }
    
    
    @objc func closeMenus()
    {
        if(isMe)
        {
            if(currScene == "Explore")
            {
                view.endEditing(true)
                NotificationCenter.default.post(name: Notification.Name("closeRequest"), object: nil)
                closePopupScript()
                closeDelScript()
            }
            if(menuToggle)
            {
                NotificationCenter.default.post(name: Notification.Name("closeMenuTab"), object: nil)
            }
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
        if(menuToggle && isMe && currScene == "Explore")
        {
            NotificationCenter.default.post(name: Notification.Name("closeMenuTab"), object: nil)
        }
        
    }

    @objc func keyboardWillHide(notification: NSNotification)
    {
        if(isMe)
        {
            
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
        if(menuToggle)
        {
            NotificationCenter.default.post(name: Notification.Name("closeMenuTab"), object: nil)
        } else
        {
            let c = Int(sender.title(for: .normal)!)!

            if(role == "Learner, Student, or Parent")
            {
                if(cachedUsernames[c] != username && cachedUsernames[c] != "")
                {
                    if(!popUP)
                    {
                        createPersonPopup(usernameP: cachedUsernames[c], nameP: cachedNames[c], profpicP: cachedProfPics[c], sender: sender)
                        lastPressed = c
                    }
                } else
                {
                    if(!delUP)
                    {
                        createDeleteRequestPopup(usernameP: cachedUsernames[c], sender: sender)
                        lastPressed = c
                    }
                }
            } else if (role == "Tutor or Teacher")
            {
                if(!popUP)
                {
                    createPersonPopup(usernameP: cachedUsernames[c], nameP: cachedNames[c], profpicP: cachedProfPics[c], sender: sender)
                    lastPressed = c
                }
            }
        }
    }
    
    func createPersonPopup(usernameP: String, nameP: String, profpicP: UIImage!, sender: UIButton!)
    {
        if(isMe)
        {
            
            dimView.alpha = 0.0
            
            popupView.isHidden = false
            if(!popupBOOL)
            {
                popupView = UIView()
                self.view.addSubview(popupView)
                popupView.translatesAutoresizingMaskIntoConstraints = false
                popupView.removeConstraints(popupView.constraints)
                ppcvr.removeAll()
                ppcvr = []
                popupView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -5.0).isActive = true
                popupView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 5.0).isActive = true
                ppcvr.append(popupView.topAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -50.0))
                ppcvr[0].isActive = true
                ppcvr.append(popupView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 50.0))
                ppcvr[1].isActive = true
                ppcvr.append(popupView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 50))
                ppcvr[2].isActive = false
                ppcvr.append(popupView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -5.0))
                ppcvr[3].isActive = false
            }
            popupView.backgroundColor = addRVTC
            popupView.backgroundColor?.withAlphaComponent(0.0)
            popupView.alpha = 1.0
            popupView.layer.cornerRadius = 15.0
            popupView.layer.borderWidth = 0.0
            popupView.layer.borderColor = UIColor.clear.cgColor
            
            if(!popupBOOL)
            {
                closePUBut = UIButton()
                popupView.addSubview(closePUBut)
                closePUBut.translatesAutoresizingMaskIntoConstraints = false
                closePUBut.addTarget(self, action: #selector(closePopupButton(_:)), for: UIControl.Event.touchUpInside)
                noRotationPop.transform = closePUBut.transform.rotated(by: 0.0)
                closePUBut.removeConstraints(closePUBut.constraints)
                closePUBut.trailingAnchor.constraint(equalTo: popupView.trailingAnchor, constant: -26.0).isActive = true
                closePUBut.leadingAnchor.constraint(equalTo: popupView.trailingAnchor, constant: -56.0).isActive = true
                closePUBut.topAnchor.constraint(equalTo: popupView.topAnchor, constant: 26.0).isActive = true
                closePUBut.bottomAnchor.constraint(equalTo: popupView.topAnchor, constant: 56.0).isActive = true
            }
            closePUBut.alpha = 0.0
            closePUBut.isHidden = false
            closePUBut.setTitle("", for: .normal)
            closePUBut.setBackgroundImage(UIImage(systemName: "plus"), for: .normal)
            closePUBut.tintColor = UIColor.white
            closePUBut.transform = noRotationPop.transform
            popupView.bringSubviewToFront(closePUBut)
            
            let imageSize = UIScreen.main.bounds.width * 0.5
            
            if(!popupBOOL)
            {
                pupp = UIImageView()
                popupView.addSubview(pupp)
                pupp.translatesAutoresizingMaskIntoConstraints = false
                pupp.removeConstraints(pupp.constraints)
                puppVR.removeAll()
                puppVR = []
                pupp.centerXAnchor.constraint(equalTo: popupView.centerXAnchor).isActive = true
                pupp.topAnchor.constraint(equalTo: popupView.topAnchor, constant: imageSize * 0.5 + 5.0).isActive = true
                puppVR.append(pupp.widthAnchor.constraint(equalToConstant: 5.0))
                puppVR[0].isActive = true
                puppVR.append(pupp.heightAnchor.constraint(equalToConstant: 5.0))
                puppVR[1].isActive = true
                puppVR.append(pupp.widthAnchor.constraint(equalToConstant: imageSize))
                puppVR[2].isActive = false
                puppVR.append(pupp.heightAnchor.constraint(equalToConstant: imageSize))
                puppVR[3].isActive = false
            }
            pupp.image = profpicP
            pupp.layer.cornerRadius = imageSize / 2.0
            pupp.layer.borderWidth = 2.0
            pupp.layer.borderColor = UIColor.white.cgColor
            pupp.layer.masksToBounds = false
            pupp.clipsToBounds = true
            pupp.alpha = 0.0
            
            if(!popupBOOL)
            {
                puUsername = UILabel()
                popupView.addSubview(puUsername)
                puUsername.translatesAutoresizingMaskIntoConstraints = false
                puUsername.removeConstraints(puUsername.constraints)
                puusVR.removeAll()
                puusVR = []
                puUsername.centerXAnchor.constraint(equalTo: popupView.centerXAnchor).isActive = true
                puUsername.topAnchor.constraint(equalTo: popupView.topAnchor, constant: imageSize * 1.5 + 15.0).isActive = true
                puUsername.widthAnchor.constraint(equalTo: popupView.widthAnchor).isActive = true
                puUsername.heightAnchor.constraint(equalToConstant: sqrt(UIScreen.main.bounds.width) * 19 * 0.08).isActive = true
            }
            puUsername.text = usernameP
            puUsername.textColor = UIColor.white
            puUsername.font = UIFont(name: "HelveticaNeue-Bold", size: 2.0)
            puUsername.textAlignment = .center
            puUsername.alpha = 0.0
            
            if(!popupBOOL)
            {
                puName = UILabel()
                popupView.addSubview(puName)
                puName.translatesAutoresizingMaskIntoConstraints = false
                puName.removeConstraints(puName.constraints)
                puusVR.removeAll()
                puusVR = []
                puName.centerXAnchor.constraint(equalTo: popupView.centerXAnchor).isActive = true
                puName.topAnchor.constraint(equalTo: popupView.topAnchor, constant: imageSize * 1.5 + sqrt(UIScreen.main.bounds.width) * 19 * 0.10 + 10).isActive = true
                puName.widthAnchor.constraint(equalTo: popupView.widthAnchor).isActive = true
                puName.heightAnchor.constraint(equalToConstant: sqrt(UIScreen.main.bounds.width) * 19 * 0.08).isActive = true
            }
            puName.text = nameP
            puName.textColor = UIColor.white
            puName.font = UIFont(name: "HelveticaNeue", size: 2.0)
            puName.textAlignment = .center
            puName.alpha = 0.0
            
            if(!popupBOOL)
            {
                makeConn = UIButton()
                popupView.addSubview(makeConn)
                makeConn.translatesAutoresizingMaskIntoConstraints = false
                makeConn.addTarget(self, action: #selector(makeConnectionButton(_:)), for: UIControl.Event.touchUpInside)
                makeConn.removeConstraints(closePUBut.constraints)
                makeConn.trailingAnchor.constraint(equalTo: popupView.trailingAnchor, constant: -UIScreen.main.bounds.width * 0.2).isActive = true
                makeConn.leadingAnchor.constraint(equalTo: popupView.leadingAnchor, constant: UIScreen.main.bounds.width * 0.2).isActive = true
                makeConn.topAnchor.constraint(equalTo: popupView.topAnchor, constant: imageSize * 1.5 + sqrt(UIScreen.main.bounds.width) * 19 * 0.20 + 10).isActive = true
                makeConn.bottomAnchor.constraint(equalTo: popupView.topAnchor, constant: imageSize * 1.5 + sqrt(UIScreen.main.bounds.width) * 19 * 0.30 + 20).isActive = true
            }
            makeConn.alpha = 0.0
            makeConn.isHidden = false
            makeConn.layer.cornerRadius = (sqrt(UIScreen.main.bounds.width) * 19 * 0.10 + 10) / 4.0
            if(connections[usernameP] != "" && connections[usernameP] != nil)
            {
                makeConn.setTitle("Already Connected", for: .normal)
            } else
            {
                makeConn.setTitle("Make Connection", for: .normal)
            }
            makeConn.titleLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: sqrt(UIScreen.main.bounds.width) * 19 * 0.05)
            makeConn.setTitleColor(UIColor.systemIndigo, for: .normal)
            makeConn.backgroundColor = UIColor.white
            makeConn.tintColor = UIColor.white
            popupView.bringSubviewToFront(makeConn)
            
            
            popupBOOL = true
            popUP = true
            
            view.endEditing(true)
            
            closeRequestTab()
            
            self.view.layoutIfNeeded()
            
            UIView.animate(withDuration: 0.2)
            {
                self.ppcvr[0].isActive = false
                self.ppcvr[1].isActive = false
                
                self.puppVR[0].isActive = false
                self.puppVR[1].isActive = false
                
                self.ppcvr[2].isActive = true
                self.ppcvr[3].isActive = true
                
                self.puppVR[2].isActive = true
                self.puppVR[3].isActive = true
                
                self.closePUBut.alpha = 1.0
                
                self.pupp.alpha = 1.0
                
                self.puUsername.font = UIFont(name: "HelveticaNeue-Bold", size: sqrt(UIScreen.main.bounds.width) * 19 * 0.0667)
                self.puUsername.alpha = 1.0
                
                self.dimView.alpha = 0.5
                
                self.makeConn.alpha = 1.0

                self.puName.font = UIFont(name: "HelveticaNeue", size: sqrt(UIScreen.main.bounds.width) * 19 * 0.0667)
                self.puName.alpha = 0.5
                
                self.popupView.backgroundColor = self.addRVTC
                self.popupView.layer.borderColor = UIColor.white.cgColor
                self.closePUBut.transform = self.closePUBut.transform.rotated(by: .pi / 4)
                
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc func closePopupButton(_ sender: UIButton!)
    {
        if(isMe)
        {
            closePopupScript()
        }
    }
    
    @objc func makeConnectionButton(_ sender: UIButton!)
    {
        if(isMe)
        {
            if(connections[cachedUsernames[lastPressed]] != "")
            {
                let date = Date()
                var calendar = Calendar.current
                calendar.timeZone = TimeZone(abbreviation: "PDT")!
                let hour = calendar.component(.hour, from: date)
                let minutes = calendar.component(.minute, from: date)
                let seconds = calendar.component(.second, from: date)
                let randomID = db.child("connections").childByAutoId()
                let randomID2 = randomID.child("message_list").childByAutoId()
                randomID2.child("username").setValue("\(username)")
                randomID2.child("message").setValue("\(name) has made a connection!")
                let stringDate = "\(date)"
                randomID2.child("timestamp/date").setValue("\(stringDate.prefix(10))")
                randomID2.child("timestamp/time").setValue("\(hour):\(minutes):\(seconds)")
                randomID.child("last_message_time/time").setValue("\(hour):\(minutes):\(seconds)")
                randomID.child("last_message_time/date").setValue("\(stringDate.prefix(10))")
                connections[cachedUsernames[lastPressed]] = "\(randomID.key!)"
                randomID.child("\(username)/status").setValue("healthy")
                randomID.child("\(cachedUsernames[lastPressed])/status").setValue("healthy")
                db.child("users/\(userEmail!)/connections/\(cachedUsernames[lastPressed])").setValue("\(randomID.key!)")
                db.child("usernames/\(cachedUsernames[lastPressed])").observeSingleEvent(of: .value) { (snap) in
                    if let val = snap.value as? String
                    {
                        self.db.child("users/\(val)/connections/\(username)").setValue("\(randomID.key!)")
                    }
                }
            }
            closePopupScript()
        }
    }
    
    func closePopupScript()
    {
        if(popupBOOL)
        {
            self.view.layoutIfNeeded()
            
            UIView.animate(withDuration: 0.2, animations: {
                
                self.ppcvr[2].isActive = false
                self.ppcvr[3].isActive = false
                
                self.puppVR[2].isActive = false
                self.puppVR[3].isActive = false
                
                self.ppcvr[0].isActive = true
                self.ppcvr[1].isActive = true
                
                self.puppVR[0].isActive = true
                self.puppVR[1].isActive = true
                
                self.closePUBut.alpha = 0.0
                
                self.pupp.alpha = 0.0
                
                self.dimView.alpha = 0.0
                
                self.makeConn.alpha = 0.0
                
                self.puUsername.font = UIFont(name: "HelveticaNeue-Bold", size: 2.0)
                self.puUsername.alpha = 0.0
                
                self.puName.font = UIFont(name: "HelveticaNeue", size: 2.0)
                self.puName.alpha = 0.0
                
                self.popupView.backgroundColor = UIColor.clear
                self.popupView.layer.borderColor = UIColor.white.cgColor
                self.closePUBut.transform = self.closePUBut.transform.rotated(by: .pi / 4)
                
                self.view.layoutIfNeeded()
            }) { _ in
                self.popupView.isHidden = true
                self.view.layoutIfNeeded()
                self.popUP = false
            }
        }
    }
    
    func createDeleteRequestPopup(usernameP: String, sender: UIButton!)
    {
        if(isMe)
        {
            
            
            dimView.alpha = 0.0
            
            delView.isHidden = false
            if(!delBOOL)
            {
                delView = UIView()
                self.view.addSubview(delView)
                self.view.bringSubviewToFront(delView)
                delView.translatesAutoresizingMaskIntoConstraints = false
                delView.removeConstraints(delView.constraints)
                dcvr.removeAll()
                dcvr = []
                delView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -5.0).isActive = true
                delView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 5.0).isActive = true
                dcvr.append(delView.topAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -20))
                dcvr[0].isActive = true
                dcvr.append(delView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 62.0))
                dcvr[1].isActive = true
                dcvr.append(delView.topAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -41.0))
                dcvr[2].isActive = false
                dcvr.append(delView.bottomAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 41.0))
                dcvr[3].isActive = false
            }
            delView.backgroundColor = addRVTC
            delView.backgroundColor?.withAlphaComponent(0.0)
            delView.alpha = 1.0
            delView.layer.cornerRadius = 15.0
            delView.layer.borderWidth = 0.0
            delView.layer.borderColor = UIColor.clear.cgColor
            
            if(!delBOOL)
            {
                closeDUBut = UIButton()
                delView.addSubview(closeDUBut)
                closeDUBut.translatesAutoresizingMaskIntoConstraints = false
                closeDUBut.addTarget(self, action: #selector(closeDelButton(_:)), for: UIControl.Event.touchUpInside)
                noRotationDel.transform = closeDUBut.transform.rotated(by: 0.0)
                closeDUBut.removeConstraints(closeDUBut.constraints)
                closeDUBut.trailingAnchor.constraint(equalTo: delView.trailingAnchor, constant: -26.0).isActive = true
                closeDUBut.leadingAnchor.constraint(equalTo: delView.trailingAnchor, constant: -56.0).isActive = true
                closeDUBut.topAnchor.constraint(equalTo: delView.topAnchor, constant: 26.0).isActive = true
                closeDUBut.bottomAnchor.constraint(equalTo: delView.topAnchor, constant: 56.0).isActive = true
            }
            closeDUBut.alpha = 0.0
            closeDUBut.isHidden = false
            closeDUBut.setTitle("", for: .normal)
            closeDUBut.setBackgroundImage(UIImage(systemName: "plus"), for: .normal)
            closeDUBut.tintColor = UIColor.white
            closeDUBut.transform = noRotationDel.transform
            delView.bringSubviewToFront(closeDUBut)
            
            if(!delBOOL)
            {
                delReqBU = UIButton()
                delView.addSubview(delReqBU)
                delReqBU.translatesAutoresizingMaskIntoConstraints = false
                delReqBU.addTarget(self, action: #selector(delReqButton(_:)), for: UIControl.Event.touchUpInside)
                delReqBU.removeConstraints(delReqBU.constraints)
                delReqBU.trailingAnchor.constraint(equalTo: delView.trailingAnchor, constant: -82.0).isActive = true
                delReqBU.leadingAnchor.constraint(equalTo: delView.leadingAnchor, constant: 31.0).isActive = true
                delReqBU.topAnchor.constraint(equalTo: delView.topAnchor, constant: 20.0).isActive = true
                delReqBU.bottomAnchor.constraint(equalTo: delView.bottomAnchor, constant: -20.0).isActive = true
            }
            delReqBU.layer.cornerRadius = 10.0
            delReqBU.alpha = 0.0
            delReqBU.isHidden = false
            delReqBU.setTitle("Delete Request?", for: .normal)
            delReqBU.titleLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 20.0)
            delReqBU.setTitleColor(UIColor.white, for: .normal)
            delReqBU.backgroundColor = UIColor.systemPink
            closeDUBut.tintColor = UIColor.white
            delView.bringSubviewToFront(delReqBU)
            
            delBOOL = true
            delUP = true
            
            view.endEditing(true)
            
            self.view.layoutIfNeeded()
            
            closeRequestTab()
            
            UIView.animate(withDuration: 0.2)
            {
                self.dcvr[0].isActive = false
                self.dcvr[1].isActive = false
                
                self.dcvr[2].isActive = true
                self.dcvr[3].isActive = true
                
                self.closeDUBut.alpha = 1.0

                self.delReqBU.alpha = 1.0
                
                self.dimView.alpha = 0.5
                
                self.delView.backgroundColor = self.addRVTC
                self.delView.layer.borderColor = UIColor.white.cgColor
                self.closeDUBut.transform = self.closeDUBut.transform.rotated(by: .pi / 4)
                
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc func closeDelButton(_ sender: UIButton!)
    {
        if(isMe)
        {
            closeDelScript()
        }
    }
    
    @objc func delReqButton(_ sender: UIButton!)
    {
        if(isMe)
        {
            var TMPC: Int = 0
            requests.forEach { req in
                if(cachedRequests[lastPressed] == req)
                {
                    requests.remove(at: TMPC)
                } else
                {
                    TMPC += 1
                }
            }
            db.child("users/\(userEmail!)/requests").removeValue()
            for i in 0...(requests.count - 1)
            {
                db.child("users/\(userEmail!)/requests/\(i)").setValue(requests[i])
            }
            closeDelScript()
            loadStackView()
        }
    }
    
    func closeDelScript()
    {
        if(delBOOL)
        {
            self.view.layoutIfNeeded()
            
            UIView.animate(withDuration: 0.2, animations: {
                self.dcvr[2].isActive = false
                self.dcvr[3].isActive = false
                
                self.dcvr[0].isActive = true
                self.dcvr[1].isActive = true
                
                self.closeDUBut.alpha = 0.0
                
                self.delReqBU.alpha = 0.0
                
                self.dimView.alpha = 0.0
                
                self.delView.backgroundColor = UIColor.clear
                self.delView.layer.borderColor = UIColor.white.cgColor
                self.closeDUBut.transform = self.closeDUBut.transform.rotated(by: .pi / 4)
                
                self.view.layoutIfNeeded()
            }) { _ in
                self.delView.isHidden = true
                self.view.layoutIfNeeded()
                self.delUP = false
            }
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

extension String
{
    func heightWithConstrainedWidth(width: CGFloat, font: UIFont) -> CGFloat
    {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [NSAttributedString.Key.font: font], context: nil)
        return boundingBox.height
    }
}
