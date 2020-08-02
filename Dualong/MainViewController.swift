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

var userEmail: String! = ""
var rawEmail: String! = ""
var role: String = ""
var name: String = ""
var interests: [String]! = []
var username: String = ""
var currScene: String = "Login"
var onlyOnce: Bool = true
var stars: Double = -1

class MainViewController: UIViewController
{
    
    @IBOutlet weak var cover: UIView!
    
    @IBOutlet weak var textBox: UITextView!
    
    @IBOutlet var signInButton: GIDSignInButton!
    
    let st = Storage.storage().reference()
    
    let db = Database.database().reference()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        guard let shIns = GIDSignIn.sharedInstance() else { return }
        shIns.presentingViewController = self
        //shIns.delegate = self
        if(onlyOnce)
        {
            cover.isHidden = true
            if(shIns.hasPreviousSignIn())
            {
                cover.isHidden = false
                shIns.restorePreviousSignIn()
            }
            onlyOnce = false
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(setEmail(notification:)), name: .signedin, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(loggingOut(notification:)), name: Notification.Name("logOut"), object: nil)
    }
    
    
    
    @objc func setEmail(notification: NSNotification)
    {
        userEmail = GIDSignIn.sharedInstance()?.currentUser.profile.email.lowercased()
        rawEmail = GIDSignIn.sharedInstance()?.currentUser.profile.email.lowercased()
        userEmail = userEmail?.replacingOccurrences(of: ".", with: ",")
        interests.removeAll()
        
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
                        self.st.child("profilepics/\(username).jpg").getData(maxSize: 4 * 1024 * 1024, completion: { (data, error) in
                            if error != nil
                            {
                                print("error loading image \(error!)")
                            }
                            if let data = data
                            {
                                ownProfPic = UIImage(data: data)
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
                self.performSegue(withIdentifier: "loginToHome", sender: self)
                currScene = "Home"
            } else
            {
                NotificationCenter.default.post(name: Notification.Name("profImageLoaded"), object: nil)
                
                self.performSegue(withIdentifier: "LoginToSetup", sender: self)
                currScene = "Setup"
            }
        })
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
    
}

extension Notification.Name
{
    static let signedin = Notification.Name("signedin")
}

