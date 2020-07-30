//
//  SetupViewController.swift
//  Dualong
//
//  Created by Nolan Bridges on 7/24/20.
//  Copyright © 2020 NiMBLe Interactive. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseDatabase

class SetupViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var forEmail: UILabel!
    
    @IBOutlet weak var accTypeFail: UILabel!
    
    @IBOutlet weak var nameFail: UILabel!
    
    @IBOutlet weak var nameFail2: UILabel!
    
    @IBOutlet weak var usernameFail: UILabel!
    
    @IBOutlet weak var nameKB: UITextField!
    
    @IBOutlet weak var usernameKB: UITextField!
    
    @IBOutlet var keyboards: [UITextField]!
    
    @IBOutlet weak var roleButton: UIButton!
    
    @IBOutlet var roleButtons: [UIButton]!
    
    let st = Storage.storage().reference()
    
    @IBAction func handleSelections(_ sender: UIButton)
    {
        roleButtons.forEach
        { (button) in
            UIView.animate(withDuration: 0.3, animations:
            {
                button.isHidden = !button.isHidden
                button.alpha = button.isHidden ? 0 : 1
                self.view.layoutIfNeeded()
            })
        }
        
    }
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let closeTap = UITapGestureRecognizer(target: self, action: #selector(closeMenus))
        closeTap.cancelsTouchesInView = false
        view.addGestureRecognizer(closeTap)
        
        keyboards?.forEach
        { (keyboard) in
                keyboard.delegate = self
        }
        
        forEmail.text = "for email: \(rawEmail!)"
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    @IBAction func roleTapped(_ sender: UIButton)
    {
        handleSelections(sender)
        role = sender.currentTitle!
        roleButton.setTitle("\(role)", for: .normal)
    }
    
    @objc func closeMenus()
    {
        view.endEditing(true)
        
    }
    
    func textFieldShouldReturn(_ keyboards: UITextField) -> Bool
    {
        self.view.endEditing(true)
        return true
    }
    
    @IBAction func createAccount(_ sender: UIButton)
    {
        var AccCounter: Int = 0
        name = nameKB.text!
        username = usernameKB.text!.lowercased()
        
        if(role != "")
        {
            AccCounter += 1
            accTypeFail.isHidden = true
        } else
        {
            accTypeFail.isHidden = false
        }
        
        if(name.count < 21)
        {
            nameFail.isHidden = true
            if(name != "")
            {
                if(name.onlyLetters && name.filter({ $0 == "-"}).count < 2)
                {
                    AccCounter += 1
                    nameFail2.isHidden = true
                } else
                {
                    nameFail2.isHidden = false
                }
            }
        } else
        {
            nameFail2.isHidden = true
            nameFail.isHidden = false
        }
        
        if(username != "" && username.isAlphanumeric && username.count < 17)
        {
            
            
            
            
            
            
            
            
            
            
            // NEED TO ADD UNIQUE USERNAME TO SETUP
            
            
            
            
            
            
            
            
            
            
            
            
            AccCounter += 1
            usernameFail.isHidden = true
        } else
        {
            usernameFail.isHidden = false
        }
        
        if(AccCounter == 3)
        {
            let db = Database.database().reference()
            
            guard let imageData = UIImage(named: "defaultProfileImageSolid")?.jpegData(compressionQuality: 0.75) else { return }
            let uploadMetadata = StorageMetadata.init()
            uploadMetadata.contentType = "image/jpeg"
            st.child("profilepics/\(username).jpg").putData(imageData, metadata: uploadMetadata) { (downloadMetadata, error) in
                if let _ = error
                {
                    print("failureupload")
                    return
                }
            }
            
            
            db.child("usernames/\(username)").setValue(("\(userEmail!.lowercased())"))
            
            db.child("users/\(userEmail!)/username").setValue(username)
            db.child("users/\(userEmail!)/name").setValue(name)
            db.child("users/\(userEmail!)/account_type").setValue(role)
            db.child("users/\(userEmail!)/stars").setValue(0)
            self.performSegue(withIdentifier: "setupToHome", sender: self)
            currScene = "Home"
        }
    }
    
    
    @objc func keyboardWillShow(notification: NSNotification)
    {
        if(currScene == "Setup")
        {
            if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            {
                self.view.superview?.frame.origin.y = -keyboardSize.height * 0.7
                self.view.layoutIfNeeded()
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification)
    {
        if(currScene == "Setup")
        {
            self.view.superview?.frame.origin.y = 0
            self.view.layoutIfNeeded()
        }
    }

}

extension String
{
    var isAlphanumeric: Bool
    {
        return !isEmpty && range(of: "[^a-zA-Z0-9]", options: .regularExpression) == nil
    }
    var onlyLetters: Bool
    {
        return !isEmpty && range(of: "[^a-zA-Z- ]", options: .regularExpression) == nil
    }
}
