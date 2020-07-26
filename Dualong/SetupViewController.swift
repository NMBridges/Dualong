//
//  SetupViewController.swift
//  Dualong
//
//  Created by Nolan Bridges on 7/24/20.
//  Copyright © 2020 NiMBLe Interactive. All rights reserved.
//

import UIKit
import FirebaseDatabase

var role: String = ""
var name: String = ""
var username: String = ""

class SetupViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var accTypeFail: UILabel!
    
    @IBOutlet weak var nameFail: UILabel!
    
    @IBOutlet weak var nameFail2: UILabel!
    
    @IBOutlet weak var usernameFail: UILabel!
    
    @IBOutlet weak var nameKB: UITextField!
    
    @IBOutlet weak var usernameKB: UITextField!
    
    @IBOutlet var keyboards: [UITextField]!
    
    @IBOutlet weak var roleButton: UIButton!
    
    @IBOutlet var roleButtons: [UIButton]!
    
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
        
        keyboards.forEach
        { (keyboard) in
                keyboard.delegate = self
        }
        
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
        username = usernameKB.text!
        
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
            AccCounter += 1
            usernameFail.isHidden = true
        } else
        {
            usernameFail.isHidden = false
        }
        
        if(AccCounter == 3)
        {
            let db = Database.database().reference()
            
            db.child("users/\(userEmail!)/username").setValue(username)
            db.child("users/\(userEmail!)/name").setValue(name)
            db.child("users/\(userEmail!)/account type").setValue(role)
            self.performSegue(withIdentifier: "setupToHome", sender: self)
        }
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension String {
    var isAlphanumeric: Bool {
        return !isEmpty && range(of: "[^a-zA-Z0-9]", options: .regularExpression) == nil
    }
    var onlyLetters: Bool {
        return !isEmpty && range(of: "[^a-zA-Z- ]", options: .regularExpression) == nil
    }
}
