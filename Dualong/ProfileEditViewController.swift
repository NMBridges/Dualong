//
//  ProfileEditViewController.swift
//  Dualong
//
//  Created by Nolan Bridges on 7/27/20.
//  Copyright © 2020 NiMBLe Interactive. All rights reserved.
//

import UIKit

class ProfileEditViewController: UIViewController
{
    
    var tempRole: String = ""
    var tempName: String = ""
    var tempUsername: String = ""
    
    @IBOutlet weak var usernameFail: UILabel!
    @IBOutlet weak var nameFail: UILabel!
    @IBOutlet weak var nameFail2: UILabel!
    @IBOutlet weak var accTypeFail: UILabel!
    @IBOutlet weak var nameFail3: UILabel!
    
    @IBOutlet var roleButtonCollection: [UIButton]!
    
    @IBOutlet weak var roleButtonRef: UIButton!
    
    @IBOutlet weak var usernameField: UITextField!
    
    @IBOutlet weak var nameField: UITextField!
    
    @IBOutlet weak var usernameKB: UITextField!
    
    @IBOutlet weak var nameKB: UITextField!
    
    @IBOutlet var keyboards: [UITextField]!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let closeTap = UITapGestureRecognizer(target: self, action: #selector(closeMenus))
        closeTap.cancelsTouchesInView = false
        view.addGestureRecognizer(closeTap)
        
        keyboards.forEach
        { (keyboard) in
                keyboard.delegate = self
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(updatePreset(notification:)), name: Notification.Name("editProf"), object: nil)
    }
    
    @IBAction func roleButtonPressed(_ sender: UIButton)
    {
        roleButtonCollection.forEach
        { (button) in
            UIView.animate(withDuration: 0.3, animations:
            {
                button.isHidden = !button.isHidden
                button.alpha = button.isHidden ? 0 : 1
                self.view.layoutIfNeeded()
            })
        }
    }
    
    @IBAction func roleChosen(_ sender: UIButton)
    {
        roleButtonPressed(sender)
        tempRole = sender.currentTitle
        roleButtonRef.setTitle("\(tempRole)", for: .normal)
        
    }
    
    func textFieldShouldReturn(_ keyboards: UITextField) -> Bool
    {
        self.view.endEditing(true)
        return true
    }
    
    @IBAction func saveButtonPressed(_ sender: UIButton)
    {
        var AccCounter: Int = 0
        tempName = nameKB.text!
        tempUsername = usernameKB.text!
        
        if(tempRole != "")
        {
            AccCounter += 1
            accTypeFail.isHidden = true
        } else
        {
            accTypeFail.isHidden = false
        }
        
        if(tempName.count < 21)
        {
            nameFail.isHidden = true
            if(tempName != "")
            {
                if(tempName.onlyLetters && tempName.filter({ $0 == "-"}).count < 2)
                {
                    nameFail2.isHidden = true
                    if()
                    {
                        AccCounter += 1
                        nameFail3.isHidden = true
                    }
                } else
                {
                    nameFail2.isHidden = false
                    nameFail3.isHidden = true
                }
            }
        } else
        {
            nameFail3.isHidden = true
            nameFail2.isHidden = true
            nameFail.isHidden = false
        }
        
        if(tempUsername != "" && tempUsername.isAlphanumeric && tempUsername.count < 17)
        {
            AccCounter += 1
            usernameFail.isHidden = true
        } else
        {
            usernameFail.isHidden = false
        }
        
        if(AccCounter == 3)
        {
            let db = Database.database().reference()
            
            db.child("users/\(userEmail!)/username").setValue(tempUsername)
            db.child("users/\(userEmail!)/name").setValue(tempName)
            db.child("users/\(userEmail!)/account_type").setValue(tempRole)
            
            name = tempName
            role = tempRole
            username = tempUsername
            
            // perform transition back
        }
    }
    
    @objc func closeMenus()
    {
        view.endEditing(true)
        
    }
    
    @objc func updatePreset()
    {
        tempRole = role
        tempName = name
        tempUsername = username
        roleButtonRef.setTitle("\(tempRole)", for: .normal)
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
