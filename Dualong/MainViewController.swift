//
//  ViewController.swift
//  Dualong
//
//  Created by Nolan Bridges on 7/23/20.
//  Copyright © 2020 NiMBLe Interactive. All rights reserved.
//

import UIKit
import GoogleSignIn
import FirebaseStorage
import FirebaseDatabase
import FirebaseAuth
import AuthenticationServices

var userEmail: String! = ""
var rawEmail: String! = ""
var role: String = ""
var name: String = ""
var interests: [String]! = []
var username: String = ""
var currScene: String = "Login"
var onlyOnce: Bool = true
var stars: Double = -1
var connections: [String: String]! = [:]

class MainViewController: UIViewController
{
    
    @IBOutlet weak var cover: UIView!
    
    @IBOutlet weak var textBox: UITextView!
    
    @IBOutlet var signInButton: GIDSignInButton!
    
    let st = Storage.storage().reference()
    
    let db = Database.database().reference()
    
    var loadCircle = UIView()
    var circle = UIBezierPath()
    var displayLink: CADisplayLink!
    var shapeLayer: CAShapeLayer!
    var time = CACurrentMediaTime()
    var ogtime = CACurrentMediaTime()
    
    let appleProvider = AppleSignInClient()
    
    @IBOutlet weak var googleButRef: GIDSignInButton!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)

        AppUtility.lockOrientation(.portrait)
        
        let appleSignInBut = ASAuthorizationAppleIDButton()
        self.view.addSubview(appleSignInBut)
        self.view.bringSubviewToFront(cover)
        appleSignInBut.translatesAutoresizingMaskIntoConstraints = false
        appleSignInBut.widthAnchor.constraint(equalToConstant: 194.0).isActive = true
        appleSignInBut.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        appleSignInBut.topAnchor.constraint(equalTo: googleButRef.bottomAnchor, constant: 10.0).isActive = true
        appleSignInBut.heightAnchor.constraint(equalToConstant: 43).isActive = true
        appleSignInBut.layer.cornerRadius = 2.0
        appleSignInBut.addTarget(self, action: #selector(signInWithApple(_:)), for: .touchUpInside)
        
        setupLoadCircle()
        displayLink = CADisplayLink(target: self, selector: #selector(loadAnimations))
        displayLink.add(to: RunLoop.main, forMode: .default)
        
        loadCircle.isHidden = true
        
        guard let shIns = GIDSignIn.sharedInstance() else { return }
        shIns.presentingViewController = self
        //shIns.delegate = self
        if(onlyOnce)
        {
            cover.isHidden = true
            if(shIns.hasPreviousSignIn())
            {
                loadCircle.isHidden = false
                cover.isHidden = false
                shIns.restorePreviousSignIn()
            }
            onlyOnce = false
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(setEmail(notification:)), name: .signedin, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(loggingOut(notification:)), name: Notification.Name("logOut"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(SHOWLOADCIRCLE(notification:)), name: Notification.Name("LOGGGGIN"), object: nil)
    }
    
    @objc func signInWithApple(_ sender: ASAuthorizationAppleIDButton)
    {
        appleProvider.handleAppleIdRequest(block: { fullname, email, token in
            
            
            self.db.child("tokens").observeSingleEvent(of: .value) { over in
                if let hoo = over.children.allObjects as? [DataSnapshot]
                {
                    var tof: Bool = true
                    for child in hoo
                    {
                        if(child.value as? String == token!)
                        {
                            let val = child.key
                            userEmail = val
                            rawEmail = val
                            NotificationCenter.default.post(name: .signedin, object: nil)
                            tof = false
                        }
                    }
                    if(tof)
                    {
                        if let _ = email
                        {
                            let email2 = email!.replacingOccurrences(of: ".", with: ",")
                            self.db.child("tokens/\(email2.lowercased())").setValue(token!)
                            userEmail = email2.lowercased()
                            rawEmail = email2.lowercased()
                            
                            userEmail = userEmail?.replacingOccurrences(of: ".", with: ",")
                            interests.removeAll()
                            role = ""
                            name = ""
                            username = ""
                            ownProfPic = UIImage(named: "defaultProfileImageSolid")!
                            stars = 0.0
                            interests = []
                            requests = []
                            connections = [:]
                            
                            NotificationCenter.default.post(name: Notification.Name("profImageLoaded"), object: nil)

                            self.loadCircle.isHidden = true
                            self.performSegue(withIdentifier: "LoginToSetup", sender: self)
                            currScene = "Setup"
                        } else
                        {
                            let keyr = self.db.child("users").childByAutoId()
                            let keystring: String = keyr.key!
                            self.db.child("tokens/\(keystring)").setValue(token!)
                            userEmail = keystring
                            rawEmail = keystring
                            
                            userEmail = userEmail?.replacingOccurrences(of: ".", with: ",")
                            interests.removeAll()
                            role = ""
                            name = ""
                            username = ""
                            ownProfPic = UIImage(named: "defaultProfileImageSolid")!
                            stars = 0.0
                            interests = []
                            requests = []
                            connections = [:]
                            
                            NotificationCenter.default.post(name: Notification.Name("profImageLoaded"), object: nil)

                            self.loadCircle.isHidden = true
                            self.performSegue(withIdentifier: "LoginToSetup", sender: self)
                            currScene = "Setup"
                        }
                    }
                }
            }
        })
    }
    
    @objc func setEmail(notification: NSNotification)
    {
        if(GIDSignIn.sharedInstance()?.currentUser != nil)
        {
            userEmail = GIDSignIn.sharedInstance()?.currentUser.profile.email.lowercased()
            rawEmail = GIDSignIn.sharedInstance()?.currentUser.profile.email.lowercased()
            userEmail = userEmail?.replacingOccurrences(of: ".", with: ",")
        }
        interests.removeAll()
        role = ""
        name = ""
        username = ""
        ownProfPic = UIImage(named: "defaultProfileImageSolid")!
        stars = 0.0
        interests = []
        requests = []
        connections = [:]
        
        db.child("users/\(userEmail!)").observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.exists()
            {
                self.db.child("users/\(userEmail!)/account_type").observeSingleEvent(of: .value) { (SNAP) in
                    if let value = SNAP.value as? String
                    {
                        role = value
                    }
                }
                self.db.child("users/\(userEmail!)/name").observeSingleEvent(of: .value) { (SNAP) in
                    if let value = SNAP.value as? String
                    {
                        name = value
                    }
                }
                self.db.child("users/\(userEmail!)/username").observeSingleEvent(of: .value) { (SNAP) in
                    if let value = SNAP.value as? String
                    {
                        username = value
                        self.st.child("profilepics/\(username).jpg").getData(maxSize: 8 * 1024 * 1024, completion: { (data, error) in
                            if error != nil
                            {
                                print("error loading image \(error!)")
                            }
                            if let data = data
                            {
                                if(data.count != 0)
                                {
                                    ownProfPic = UIImage(data: data)
                                } else
                                {
                                    ownProfPic = UIImage(named: "defaultProfileImageSolid")
                                    guard let imageData = UIImage(named: "defaultProfileImageSolid")?.jpegData(compressionQuality: 0.75) else { return }
                                    let uploadMetadata = StorageMetadata.init()
                                    uploadMetadata.contentType = "image/jpeg"
                                    self.st.child("profilepics/\(username).jpg").putData(imageData, metadata: uploadMetadata) { (downloadMetadata, error) in
                                        if let _ = error
                                        {
                                            print("failureupload")
                                            return
                                        }
                                    }
                                }
                                
                                NotificationCenter.default.post(name: Notification.Name("profImageLoaded"), object: nil)
                                
                                
                            }
                        })
                    }
                }
                self.db.child("users/\(userEmail!)/stars").observeSingleEvent(of: .value) { (SNAP) in
                    if let value = SNAP.value as? Double
                    {
                        stars = value
                    }
                }
                self.db.child("users/\(userEmail!)/interests").observeSingleEvent(of: .value) { (SNAP) in
                    if let children = SNAP.children.allObjects as? [DataSnapshot]
                    {
                        for child in children
                        {
                            interests.append((child.value as? String)!)
                        }
                    }
                }
                self.db.child("users/\(userEmail!)/requests").observeSingleEvent(of: .value) { (SNAP) in
                    if let children = SNAP.children.allObjects as? [DataSnapshot]
                    {
                        for child in children
                        {
                            requests.append((child.value as? String)!)
                        }
                    }
                }
                self.db.child("users/\(userEmail!)/connections").observeSingleEvent(of: .value) { (SNAP) in
                    if let children = SNAP.children.allObjects as? [DataSnapshot]
                    {
                        for child in children
                        {
                            connections["\(child.key)"] = (child.value as? String)!
                        }
                    }
                }
                self.loadCircle.isHidden = true
                self.performSegue(withIdentifier: "loginToHome", sender: self)
                currScene = "Home"
            } else
            {
                NotificationCenter.default.post(name: Notification.Name("profImageLoaded"), object: nil)

                self.loadCircle.isHidden = true
                self.performSegue(withIdentifier: "LoginToSetup", sender: self)
                currScene = "Setup"
            }
        })
    }
    
    @objc func SHOWLOADCIRCLE(notification: NSNotification)
    {
        cover.isHidden = false
        loadCircle.isHidden = false
    }
    
    /*@objc func signOut(_ sender: UIButton)
    {
        print("signing out")
        GIDSignIn.sharedInstance()?.signOut()
        
        let firebaseAuth = Auth.auth()
        do
        {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError
        {
            print("failed to sign out")
            print(signOutError)
            return
        }
        
        print("Signed out")
    }*/

    @objc func loggingOut(notification: NSNotification)
    {
        name = ""
        username = ""
        ownProfPic = UIImage(named: "defaultProfileImageSolid")
        userEmail = ""
        rawEmail = ""
        stars = 0
        interests = []
        
        cover.isHidden = true
        loadCircle.isHidden = true
        print("signing out")
        GIDSignIn.sharedInstance()?.signOut()
        
        let firebaseAuth = Auth.auth()
        do
        {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError
        {
            print("failed to sign out")
            print(signOutError)
            return
        }
        
        print("Signed out")
    }
    
    @IBAction func unwindToLogin(_ sender: UIStoryboardSegue)
    {
        
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
        time = CACurrentMediaTime()
        let startAng: CGFloat = CGFloat((time - ogtime) * 12.0 + sin((time - ogtime) * 8.0) * 0.9)
        let endAng: CGFloat = CGFloat(((time - ogtime) * 12.0 + 1.5) + sin((time - ogtime) * 8.0 + 1.0) * 0.9)
        circle = UIBezierPath(arcCenter: CGPoint(x: 50.0, y: 50.0), radius: 25, startAngle: startAng, endAngle: endAng, clockwise: true)
        shapeLayer.path = circle.cgPath
    }
    
}

extension Notification.Name
{
    static let signedin = Notification.Name("signedin")
    static let LOGGGGIN = Notification.Name("LOGGGGIN")
}

