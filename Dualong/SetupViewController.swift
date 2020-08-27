//
//  SetupViewController.swift
//  Dualong
//
//  Created by Nolan Bridges on 7/24/20.
//  Copyright © 2020 NiMBLe Interactive. All rights reserved.
//

import UIKit
import GoogleSignIn
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
    
    @IBOutlet weak var phoneKB: UITextField!
    
    @IBOutlet var keyboards: [UITextField]!
    
    @IBOutlet weak var roleButton: UIButton!
    
    @IBOutlet var roleButtons: [UIButton]!
    
    @IBOutlet weak var nextBUTREF: UIButton!
    
    let st = Storage.storage().reference()
    
    var interestView: UIView! = UIView()
    var intvVC: [NSLayoutConstraint]! = []
    var interestTitle: UITextView! = UITextView()
    var interestScrollView: UIScrollView! = UIScrollView()
    var intStackView: UIStackView! = UIStackView()
    var interestsTemp: [String]! = []
    var createAccButton: UIButton! = UIButton()
    var selectOptionsFail: UITextView! = UITextView()
    
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
        
        instantiateInterestsView()
        
        nextBUTREF.layer.cornerRadius = 10.0
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(loggingOut(notification:)), name: Notification.Name("logOut"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(setEmail(notification:)), name: .signedin, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(setEmail(notification:)), name: Notification.Name("setEmailSetup"), object: nil)

        NotificationCenter.default.post(name: Notification.Name("setEmailSetup"), object: nil)
        
    }
    
    func instantiateInterestsView()
    {
        
        intvVC.removeAll()
        
        self.view.addSubview(interestView)
        interestView.translatesAutoresizingMaskIntoConstraints = false
        interestView.removeConstraints(interestView.constraints)
        interestView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        interestView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        intvVC.append(interestView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0.0))
        intvVC[0].isActive = false
        intvVC.append(interestView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0.0))
        intvVC[1].isActive = false
        intvVC.append(interestView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: UIScreen.main.bounds.width))
        intvVC[2].isActive = true
        intvVC.append(interestView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: UIScreen.main.bounds.width))
        intvVC[3].isActive = true
        interestView.backgroundColor = UIColor.systemBlue
        
        interestView.addSubview(interestScrollView)
        interestScrollView.translatesAutoresizingMaskIntoConstraints = false
        interestScrollView.removeConstraints(interestScrollView.constraints)
        interestScrollView.topAnchor.constraint(equalTo: interestView.topAnchor, constant: 200.0).isActive = true
        interestScrollView.bottomAnchor.constraint(equalTo: interestView.bottomAnchor, constant: -145.0).isActive = true
        interestScrollView.leadingAnchor.constraint(equalTo: interestView.leadingAnchor, constant: 25).isActive = true
        interestScrollView.trailingAnchor.constraint(equalTo: interestView.trailingAnchor, constant: -25).isActive = true
        interestScrollView.contentSize = interestScrollView.frame.size
        
        intStackView.axis = .vertical
        intStackView.distribution  = .fill
        intStackView.alignment = .fill
        intStackView.spacing = 5.0
        interestScrollView.addSubview(intStackView)
        intStackView.translatesAutoresizingMaskIntoConstraints = false
        intStackView.removeConstraints(intStackView.constraints)
        intStackView.leadingAnchor.constraint(equalTo: interestScrollView.contentLayoutGuide.leadingAnchor).isActive = true
        intStackView.trailingAnchor.constraint(equalTo: interestScrollView.contentLayoutGuide.trailingAnchor).isActive = true
        intStackView.topAnchor.constraint(equalTo: interestScrollView.contentLayoutGuide.topAnchor).isActive = true
        intStackView.bottomAnchor.constraint(equalTo: interestScrollView.contentLayoutGuide.bottomAnchor).isActive = true
        intStackView.widthAnchor.constraint(equalTo: interestScrollView.frameLayoutGuide.widthAnchor).isActive = true
        
        interestTitle = UITextView()
        interestView.addSubview(interestTitle)
        interestTitle.translatesAutoresizingMaskIntoConstraints = false
        interestTitle.topAnchor.constraint(equalTo: interestView.topAnchor, constant: 50).isActive = true
        interestTitle.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
        interestTitle.centerXAnchor.constraint(equalTo: interestView.centerXAnchor).isActive = true
        interestTitle.heightAnchor.constraint(equalToConstant: 120).isActive = true
        interestTitle.textAlignment = NSTextAlignment.center
        interestTitle.text = "What subjects are you interested in learning or tutoring?"
        interestTitle.font = UIFont(name: "HelveticaNeue-Light", size: 30)
        interestTitle.textColor = UIColor.white
        interestTitle.backgroundColor = UIColor.clear
        
        selectOptionsFail = UITextView()
        interestView.addSubview(selectOptionsFail)
        selectOptionsFail.translatesAutoresizingMaskIntoConstraints = false
        selectOptionsFail.topAnchor.constraint(equalTo: interestView.topAnchor, constant: 165).isActive = true
        selectOptionsFail.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
        selectOptionsFail.centerXAnchor.constraint(equalTo: interestView.centerXAnchor).isActive = true
        selectOptionsFail.heightAnchor.constraint(equalToConstant: 30).isActive = true
        selectOptionsFail.textAlignment = NSTextAlignment.center
        selectOptionsFail.text = "Please select at least one subject"
        selectOptionsFail.font = UIFont(name: "HelveticaNeue", size: 15)
        selectOptionsFail.textColor = UIColor.white
        selectOptionsFail.backgroundColor = UIColor.clear
        selectOptionsFail.isHidden = true
        
        interestView.addSubview(createAccButton)
        createAccButton.setTitle("Create Account", for: .normal)
        createAccButton.setTitleColor(UIColor.systemBlue, for: .normal)
        createAccButton.titleLabel!.font = UIFont(name: "HelveticaNeue-Bold", size: 25.0)
        createAccButton.backgroundColor = UIColor.white
        createAccButton.translatesAutoresizingMaskIntoConstraints = false
        createAccButton.removeConstraints(createAccButton.constraints)
        createAccButton.centerXAnchor.constraint(equalTo: interestView.centerXAnchor).isActive = true
        createAccButton.widthAnchor.constraint(equalToConstant: 225.0).isActive = true
        createAccButton.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
        createAccButton.bottomAnchor.constraint(equalTo: interestView.bottomAnchor, constant: -25.0).isActive = true
        createAccButton.layer.cornerRadius = 15.0
        createAccButton.addTarget(self, action: #selector(createAccountNow(_:)), for: UIControl.Event.touchUpInside)
        
        let privpol = UILabel()
        privpol.translatesAutoresizingMaskIntoConstraints = false
        privpol.removeConstraints(privpol.constraints)
        interestView.addSubview(privpol)
        privpol.bottomAnchor.constraint(equalTo: createAccButton.topAnchor, constant: -15.0).isActive = true
        privpol.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
        privpol.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.8).isActive = true
        privpol.centerXAnchor.constraint(equalTo: interestView.centerXAnchor).isActive = true
        privpol.text = "By pressing 'Create Account' you are accepting the privacy policy available on our app store page"
        privpol.font = UIFont(name: "HelveticaNeue", size: 13.0)
        privpol.textColor = UIColor.white
        privpol.lineBreakMode = .byWordWrapping
        privpol.numberOfLines = 0
        privpol.textAlignment = .center
        
        
        let buttonHeight: CGFloat = 60.0
        let buttonList: [String]! = ["Math","Biology","Chemistry","Physics","English (for non-native speakers)","Spanish (for non-native speakers)","Fitness","AP Review"]
        let buttonTextSize: [CGFloat]! = [23.0, 23.0, 23.0, 23.0, 18.0, 18.0, 23.0, 23.0]
        var listC = 0
        buttonList.forEach( { button in
            let tempButton = UIButton()
            tempButton.translatesAutoresizingMaskIntoConstraints = false
            tempButton.heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true
            tempButton.setTitle(button, for: .normal)
            tempButton.titleLabel?.font = UIFont(name: "HelveticaNeue", size: buttonTextSize[listC])
            tempButton.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
            tempButton.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.center
            tempButton.alpha = 0.5
            tempButton.layer.borderWidth = 1
            tempButton.layer.borderColor = UIColor.white.cgColor
            tempButton.addTarget(self, action: #selector(interestButtonPressed(_:)), for: UIControl.Event.touchUpInside)
            intStackView.addArrangedSubview(tempButton)
            listC += 1
        })
        
        interestView.isHidden = true
        
    }
    
    @objc func interestButtonPressed(_ sender: UIButton!)
    {
        if(sender.alpha == 0.5)
        {
            interestsTemp.append(sender.title(for: .normal)!)
            sender.alpha = 1.0
        } else if(sender.alpha == 1.0)
        {
            interestsTemp.removeAll { $0 == sender.title(for: .normal)!}
            sender.alpha = 0.5
        }
    }
    
    @objc func createAccountNow(_ sender: UIButton!)
    {
        if(interestsTemp.count != 0)
        {
            interests = interestsTemp
            selectOptionsFail.isHidden = true
            uploadAccount()
        } else
        {
            selectOptionsFail.isHidden = false
        }
    }
    
    @objc func setEmail(notification: NSNotification)
    {
        var gEmail: String = ""
        if(GIDSignIn.sharedInstance()?.currentUser != nil)
        {
            gEmail = GIDSignIn.sharedInstance()?.currentUser.profile.email.lowercased() as! String
        }
        forEmail.text = "for email: \(gEmail)"
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
        if(currScene == "Setup")
        {
            self.view.endEditing(true)
            return true
        }
        return false
    }
    
    @IBAction func createAccount(_ sender: UIButton)
    {
        var AccCounter: Int = 0
        connections = [:]
        connections["contact,nimbleinteractive@gmail,com"] = "temp"
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
        
        if(username != "" && username.isAlphanumeric && username.count < 18)
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
            
            interestView.isHidden = false
            
            UIView.animate(withDuration: 0.3, animations: {
                self.intvVC[2].isActive = false
                self.intvVC[3].isActive = false
                self.intvVC[0].isActive = true
                self.intvVC[1].isActive = true
                self.view.layoutIfNeeded()
            }, completion: nil)
            
            //uploadAccount()
        }
    }
    
    func uploadAccount()
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
        
        let charset = CharacterSet(charactersIn: "911")
        
        if(phoneKB.text! != "" && phoneKB.text!.onlyNumbers && phoneKB.text!.count > 6 && phoneKB.text!.rangeOfCharacter(from: charset) == nil)
        {
            db.child("users/\(userEmail!)").updateChildValues(["username":"\(username)", "name":"\(name)", "account_type":"\(role)", "stars":"\(Double(0))", "connections/contact,nimbleinteractive@gmail,com":"healthy", "phone_number":"\(phoneKB.text!)"])
        } else
        {
            db.child("users/\(userEmail!)").updateChildValues(["username":"\(username)", "name":"\(name)", "account_type":"\(role)", "stars":"\(Double(0))", "connections/contact,nimbleinteractive@gmail,com":"healthy", "phone_number":"nil"])
        }
        
        
        let date = Date()
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(abbreviation: "PDT")!
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        let seconds = calendar.component(.second, from: date)
        let randomID = db.child("connections").childByAutoId()
        let randomID2 = randomID.child("message_list").childByAutoId()
        let stringDate = "\(date)"
        if(username != "nimbleinteractive")
        {
            connections["contact,nimbleinteractive@gmail,com"] = "\(randomID.key!)"
            randomID.updateChildValues(["last_message_time/date":"\(stringDate.prefix(10))", "last_message_time/time":"\(hour):\(minutes):\(seconds)", "message_list/\(randomID2.key!)/user":"contact,nimbleinteractive@gmail,com", "message_list/\(randomID2.key!)/message":"/mHi! This is NiMBLe Interactive support. Please feel free to send any support requests through this channel. For finding tutors or learners' tutoring requests, go to the explore tab (search icon). Thanks!", "message_list/\(randomID2.key!)/timestamp/date":"\(stringDate.prefix(10))", "message_list/\(randomID2.key!)/timestamp/time":"\(hour):\(minutes):\(seconds)", "\(userEmail!)/status":"healthy","contact,nimbleinteractive@gmail,com/status":"healthy"])
            db.child("users/\(userEmail!)/connections/contact,nimbleinteractive@gmail,com").setValue("\(randomID.key!)")
            db.child("users/contact,nimbleinteractive@gmail,com/connections/\(userEmail!)").setValue("\(randomID.key!)")
        }
        
        for i in 0...(interests.count - 1)
        {
            db.child("users/\(userEmail!)/interests/\(i)").setValue(interests[i])
        }
        
        
        NotificationCenter.default.post(name: Notification.Name("updateProf"), object: nil)
        
        
        currScene = "Home"
        
        
        self.performSegue(withIdentifier: "setupToHome", sender: self)
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
    
    @objc func loggingOut(notification: NSNotification)
    {
        
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
    var onlyNumbers: Bool
    {
        return !isEmpty && range(of: "[^0-9-]", options: .regularExpression) == nil
    }
}
