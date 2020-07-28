//
//  ViewController.swift
//  Dualong
//
//  Created by Nolan Bridges on 7/23/20.
//  Copyright © 2020 NiMBLe Interactive. All rights reserved.
//

import UIKit
import GoogleSignIn
import FirebaseDatabase
import FirebaseAuth

var userEmail: String! = ""
var rawEmail: String! = ""
var role: String = ""
var name: String = ""
var username: String = ""

class MainViewController: UIViewController
{
    
    @IBOutlet weak var cover: UIView!
    
    @IBOutlet weak var textBox: UITextView!
    
    @IBOutlet var signInButton: GIDSignInButton!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        guard let shIns = GIDSignIn.sharedInstance() else { return }
        shIns.presentingViewController = self
        cover.isHidden = true
        if(shIns.hasPreviousSignIn())
        {
            cover.isHidden = false
            shIns.restorePreviousSignIn()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(setEmail(notification:)), name: .signedin, object: nil)
        
    }
    
    
    
    @objc func setEmail(notification: NSNotification)
    {
        userEmail = GIDSignIn.sharedInstance()?.currentUser.profile.email
        rawEmail = GIDSignIn.sharedInstance()?.currentUser.profile.email
        userEmail = userEmail?.replacingOccurrences(of: ".", with: ",")
        
        let db = Database.database().reference()
        
        db.child("users/\(userEmail!)").observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.exists()
            {
                db.child("users/\(userEmail!)/account_type").observeSingleEvent(of: .value) { (SNAP) in
                    if let value = SNAP.value as? String
                    {
                        role = value
                    }
                }
                db.child("users/\(userEmail!)/name").observeSingleEvent(of: .value) { (SNAP) in
                    if let value = SNAP.value as? String
                    {
                        name = value
                    }
                }
                db.child("users/\(userEmail!)/username").observeSingleEvent(of: .value) { (SNAP) in
                    if let value = SNAP.value as? String
                    {
                        username = value
                    }
                }
                self.performSegue(withIdentifier: "loginToHome", sender: self)
            } else
            {
                self.performSegue(withIdentifier: "LoginToSetup", sender: self)
            }
        })
    }
    
    
    @objc func signOut(_ sender: UIButton)
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
    }

}

extension Notification.Name
{
    static let signedin = Notification.Name("signedin")
}

