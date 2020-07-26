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

class MainViewController: UIViewController
{
    
    @IBOutlet weak var textBox: UITextView!
    
    @IBOutlet var signInButton: GIDSignInButton!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance()?.presentingViewController = self
        if(GIDSignIn.sharedInstance()?.currentUser != nil)
        {
            GIDSignIn.sharedInstance().signIn()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(setEmail(notification:)), name: .logintosetup, object: nil)
        
    }
    
    
    
    @objc func setEmail(notification: NSNotification)
    {
        userEmail = GIDSignIn.sharedInstance()?.currentUser.profile.email
        userEmail = userEmail?.replacingOccurrences(of: ".", with: ",")
        
        let db = Database.database().reference()
        
        db.child("users/\(userEmail!)").observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.exists()
            {
                return
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
    static let logintosetup = Notification.Name("logintosetup")
}

