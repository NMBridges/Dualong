//
//  ProfileEditViewController.swift
//  Dualong
//
//  Created by Nolan Bridges on 7/27/20.
//  Copyright © 2020 NiMBLe Interactive. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage

var uploadProgress: Double! = 0.0

class ProfileEditViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    
    var tempRole: String = ""
    var tempName: String = ""
    var tempUsername: String = ""
    var tempImage: UIImage!
    var isMe: Bool = true
    var instantInt: Bool = true
    
    let st = Storage.storage().reference()
    
    @IBOutlet weak var usernameFail: UILabel!
    @IBOutlet weak var nameFail: UILabel!
    @IBOutlet weak var nameFail2: UILabel!
    @IBOutlet weak var accTypeFail: UILabel!
    @IBOutlet weak var usernameFail2: UILabel!
    
    @IBOutlet weak var ppImageRef: UIImageView!
    
    @IBOutlet weak var ppButtonRef: UIButton!
    
    @IBOutlet var roleButtonCollection: [UIButton]!
    
    @IBOutlet weak var roleButtonRef: UIButton!
    
    @IBOutlet weak var usernameField: UITextField!
    
    @IBOutlet weak var nameField: UITextField!
    
    @IBOutlet weak var usernameKB: UITextField!
    
    @IBOutlet weak var nameKB: UITextField!
    
    @IBOutlet var keyboardsSet: [UITextField]!
    
    @IBOutlet weak var ChangeInterestsRef: UIButton!
    
    let db = Database.database().reference()
    
    
    var ppimCVR: [NSLayoutConstraint]! = []
    var ppbuCVR: [NSLayoutConstraint]! = []
    
    var needToUpdate: Bool = false
    var interestView: UIView! = UIView()
    var intvVC: [NSLayoutConstraint]! = []
    var interestTitle: UITextView! = UITextView()
    var interestScrollView: UIScrollView! = UIScrollView()
    var intStackView: UIStackView! = UIStackView()
    var interestsTemp: [String]! = []
    var saveAccButton: UIButton! = UIButton()
    var selectOptionsFail: UITextView! = UITextView()
    var actButtList: [UIButton]! = []
    
    override func viewDidLoad()
    {
        
        super.viewDidLoad()
        
        if(isMe)
        {
            let closeTap = UITapGestureRecognizer(target: self, action: #selector(closeMenus))
            closeTap.cancelsTouchesInView = false
            view.addGestureRecognizer(closeTap)
            
            keyboardsSet?.forEach
            { (keyboard) in
                    keyboard.delegate = self
            }
            
            ppImageRef.translatesAutoresizingMaskIntoConstraints = false
            ppButtonRef.translatesAutoresizingMaskIntoConstraints = false
            ppimCVR.removeAll()
            ppbuCVR.removeAll()
            ppimCVR.append(ppImageRef.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 75))
            ppimCVR[0].isActive = true
            ppimCVR.append(ppImageRef.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 0))
            ppimCVR[1].isActive = false
            ppbuCVR.append(ppButtonRef.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 75))
            ppbuCVR[0].isActive = true
            ppbuCVR.append(ppButtonRef.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 0))
            ppbuCVR[1].isActive = false
            
            ppImageRef.layer.borderWidth = 1
            ppImageRef.layer.masksToBounds = false
            ppImageRef.layer.borderColor = UIColor.white.cgColor
            ppImageRef.layer.cornerRadius = ppImageRef.frame.height / 2.0
            ppImageRef.clipsToBounds = true
            
            ChangeInterestsRef.translatesAutoresizingMaskIntoConstraints = false
            ChangeInterestsRef.removeConstraints(ChangeInterestsRef.constraints)
            ChangeInterestsRef.leadingAnchor.constraint(equalTo: self.view.centerXAnchor, constant: -UIScreen.main.bounds.width * 0.25).isActive = true
            ChangeInterestsRef.trailingAnchor.constraint(equalTo: self.view.centerXAnchor, constant: UIScreen.main.bounds.width * 0.25).isActive = true
            ChangeInterestsRef.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.12).isActive = true
            ChangeInterestsRef.centerYAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -UIScreen.main.bounds.width * 0.06 - 20).isActive = true
            ChangeInterestsRef.titleLabel!.font = UIFont(name: "HelveticaNeue-Bold", size: UIScreen.main.bounds.width * 0.05)
            ChangeInterestsRef.contentVerticalAlignment = .center
            ChangeInterestsRef.contentHorizontalAlignment = .center
            
            //instantiateInterestsView()
            
            NotificationCenter.default.addObserver(self, selector: #selector(updatePreset(notification:)), name: Notification.Name("editProf"), object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(loggingOut(notification:)), name: Notification.Name("logOut"), object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(animateOffInterests(notification:)), name: Notification.Name("animateOffInterests"), object: nil)
        }
        
    }
    
    @IBAction func roleButtonPressed(_ sender: UIButton)
    {
        if(isMe)
        {
            let bbbbooo = roleButtonCollection[0].isHidden
            roleButtonCollection.forEach
            { (button) in
                UIView.animate(withDuration: 0.3, animations:
                {
                    if(bbbbooo)
                    {
                        self.ppimCVR[0].isActive = false
                        self.ppbuCVR[0].isActive = false
                        self.ppimCVR[1].isActive = true
                        self.ppbuCVR[1].isActive = true
                    } else
                    {
                        self.ppimCVR[1].isActive = false
                        self.ppbuCVR[1].isActive = false
                        self.ppimCVR[0].isActive = true
                        self.ppbuCVR[0].isActive = true
                    }
                    button.isHidden = !button.isHidden
                    button.alpha = button.isHidden ? 0 : 1
                    self.view.layoutIfNeeded()
                })
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
    
    @IBAction func roleChosen(_ sender: UIButton)
    {
        if(isMe)
        {
            roleButtonPressed(sender)
            tempRole = sender.currentTitle!
            roleButtonRef.setTitle("\(tempRole)", for: .normal)
        }
    }
    
    func textFieldShouldReturn(_ keyboards: UITextField) -> Bool
    {
        if(isMe)
        {
            self.view.endEditing(true)
        }
        return true
    }
    
    func instantiateInterestsView()
    {
        
        intvVC.removeAll()
        
        if(instantInt)
        {
            self.view.addSubview(interestView)
        }
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
        interestView.backgroundColor = UIColor(displayP3Red: 55.0 / 255.0, green: 55.0 / 255.0, blue: 110.0 / 255.0, alpha: 1.0)
        
        if(instantInt)
        {
            interestView.addSubview(interestScrollView)
        }
        interestScrollView.translatesAutoresizingMaskIntoConstraints = false
        interestScrollView.removeConstraints(interestScrollView.constraints)
        interestScrollView.topAnchor.constraint(equalTo: interestView.topAnchor, constant: 200.0).isActive = true
        interestScrollView.bottomAnchor.constraint(equalTo: interestView.bottomAnchor, constant: -UIScreen.main.bounds.width * 0.2 - 20).isActive = true
        interestScrollView.leadingAnchor.constraint(equalTo: interestView.leadingAnchor, constant: 25).isActive = true
        interestScrollView.trailingAnchor.constraint(equalTo: interestView.trailingAnchor, constant: -25).isActive = true
        interestScrollView.contentSize = interestScrollView.frame.size
        
        intStackView.axis = .vertical
        intStackView.distribution  = .fill
        intStackView.alignment = .fill
        intStackView.spacing = 5.0
        if(instantInt)
        {
            interestScrollView.addSubview(intStackView)
        }
        intStackView.translatesAutoresizingMaskIntoConstraints = false
        intStackView.removeConstraints(intStackView.constraints)
        intStackView.leadingAnchor.constraint(equalTo: interestScrollView.contentLayoutGuide.leadingAnchor).isActive = true
        intStackView.trailingAnchor.constraint(equalTo: interestScrollView.contentLayoutGuide.trailingAnchor).isActive = true
        intStackView.topAnchor.constraint(equalTo: interestScrollView.contentLayoutGuide.topAnchor).isActive = true
        intStackView.bottomAnchor.constraint(equalTo: interestScrollView.contentLayoutGuide.bottomAnchor).isActive = true
        intStackView.widthAnchor.constraint(equalTo: interestScrollView.frameLayoutGuide.widthAnchor).isActive = true
        
        interestTitle = UITextView()
        if(instantInt)
        {
            interestView.addSubview(interestTitle)
        }
        interestTitle.translatesAutoresizingMaskIntoConstraints = false
        interestTitle.topAnchor.constraint(equalTo: interestView.topAnchor, constant: 60).isActive = true
        interestTitle.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
        interestTitle.centerXAnchor.constraint(equalTo: interestView.centerXAnchor).isActive = true
        interestTitle.heightAnchor.constraint(equalToConstant: 120).isActive = true
        interestTitle.textAlignment = NSTextAlignment.center
        interestTitle.text = "What subjects are you interested in learning or tutoring?"
        interestTitle.font = UIFont(name: "HelveticaNeue-Light", size: 28)
        interestTitle.textColor = UIColor.white
        interestTitle.backgroundColor = UIColor.clear
        
        selectOptionsFail = UITextView()
        if(instantInt)
        {
            interestView.addSubview(selectOptionsFail)
        }
        selectOptionsFail.translatesAutoresizingMaskIntoConstraints = false
        selectOptionsFail.topAnchor.constraint(equalTo: interestView.topAnchor, constant: 167).isActive = true
        selectOptionsFail.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
        selectOptionsFail.centerXAnchor.constraint(equalTo: interestView.centerXAnchor).isActive = true
        selectOptionsFail.heightAnchor.constraint(equalToConstant: 30).isActive = true
        selectOptionsFail.textAlignment = NSTextAlignment.center
        selectOptionsFail.text = "Please select at least one subject"
        selectOptionsFail.font = UIFont(name: "HelveticaNeue", size: 15)
        selectOptionsFail.textColor = UIColor.white
        selectOptionsFail.backgroundColor = UIColor.clear
        selectOptionsFail.isHidden = true
        
        if(instantInt)
        {
            interestView.addSubview(saveAccButton)
        }
        saveAccButton.setTitle("Save Interests", for: .normal)
        saveAccButton.setTitleColor(UIColor(displayP3Red: 55.0 / 255.0, green: 55.0 / 255.0, blue: 110.0 / 255.0, alpha: 1.0), for: .normal)
        saveAccButton.titleLabel!.font = UIFont(name: "HelveticaNeue-Bold", size: UIScreen.main.bounds.width * 0.05)
        saveAccButton.backgroundColor = UIColor.white
        saveAccButton.translatesAutoresizingMaskIntoConstraints = false
        saveAccButton.removeConstraints(saveAccButton.constraints)
        saveAccButton.centerXAnchor.constraint(equalTo: interestView.centerXAnchor).isActive = true
        saveAccButton.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.5).isActive = true
        saveAccButton.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.12).isActive = true
        saveAccButton.centerYAnchor.constraint(equalTo: interestView.bottomAnchor, constant: -UIScreen.main.bounds.width * 0.1 - 20).isActive = true
        if(instantInt)
        {
            saveAccButton.addTarget(self, action: #selector(saveAccountNow(_:)), for: UIControl.Event.touchUpInside)
        }
        
        
        let buttonHeight: CGFloat = 60.0
        let buttonList: [String]! = ["Math","Biology","Chemistry","Physics","English (for non-native speakers)","Spanish (for non-native speakers)","Fitness","AP Review"]
        let buttonTextSize: [CGFloat]! = [23.0, 23.0, 23.0, 23.0, 18.0, 18.0, 23.0, 23.0]
        var listC = 0
        
        if(instantInt)
        {
            buttonList.forEach( { button in
                let tempButton = UIButton()
                tempButton.translatesAutoresizingMaskIntoConstraints = false
                tempButton.heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true
                tempButton.setTitle(button, for: .normal)
                tempButton.titleLabel?.font = UIFont(name: "HelveticaNeue", size: buttonTextSize[listC])
                tempButton.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
                tempButton.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.center
                if(interests.contains(button))
                {
                    tempButton.alpha = 1.0
                } else
                {
                    tempButton.alpha = 0.5
                }
                tempButton.layer.borderWidth = 1
                tempButton.layer.borderColor = UIColor.white.cgColor
                tempButton.addTarget(self, action: #selector(interestButtonPressed(_:)), for: UIControl.Event.touchUpInside)
                actButtList.append(tempButton)
                intStackView.addArrangedSubview(tempButton)
                listC += 1
            })
        } else
        {
            actButtList.forEach { button in
                if(interests.contains(buttonList[listC]))
                {
                    button.alpha = 1.0
                } else
                {
                    button.alpha = 0.5
                }
                print("greeb")
                listC += 1
            }
        }
        
        interestView.isHidden = true
        
        instantInt = false
        
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
    
    @objc func saveAccountNow(_ sender: UIButton!)
    {
        if(isMe)
        {
            if(interestsTemp.count != 0)
            {
                //interests = interestsTemp
                selectOptionsFail.isHidden = true
                //uploadAccount()
                
                
                UIView.animate(withDuration: 0.3, animations: {
                    self.intvVC[0].isActive = false
                    self.intvVC[1].isActive = false
                    self.intvVC[2].isActive = true
                    self.intvVC[3].isActive = true
                    self.view.layoutIfNeeded()
                }, completion: { _ in
                    self.interestView.isHidden = true
                })
                
            } else
            {
                selectOptionsFail.isHidden = false
            }
        }
    }
    
    @objc func animateOffInterests(notification: NSNotification)
    {
        if(isMe && !instantInt)
        {
            UIView.animate(withDuration: 0.1, animations: {
                self.intvVC[0].isActive = false
                self.intvVC[1].isActive = false
                self.intvVC[2].isActive = true
                self.intvVC[3].isActive = true
                self.view.layoutIfNeeded()
            }, completion: { _ in
                self.interestView.isHidden = true
            })
        }
    }
    
    @IBAction func editInterestsPressed(_ sender: UIButton)
    {
        
        interestsTemp = interests
        if(instantInt)
        {
            instantiateInterestsView()
            self.view.layoutIfNeeded()
        }
        interestView.isHidden = false
        UIView.animate(withDuration: 0.3, animations: {
            self.intvVC[2].isActive = false
            self.intvVC[3].isActive = false
            self.intvVC[0].isActive = true
            self.intvVC[1].isActive = true
            self.view.layoutIfNeeded()
        }, completion: { _ in
            self.interestView.isHidden = false
        })
    }
    
    @IBAction func saveButtonPressed(_ sender: UIButton)
    {
        if(isMe)
        {
            if(!roleButtonCollection[0].isHidden)
            {
                roleButtonPressed(roleButtonRef)
            }
            var AccCounter: Int = 0
            tempName = nameKB.text!
            tempUsername = usernameKB.text!.lowercased()
            
            let db = Database.database().reference()
            
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
                        AccCounter += 1
                        
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
            
            if(tempUsername != "" && tempUsername.isAlphanumeric && tempUsername.count < 17)
            {
                usernameFail.isHidden = true
                db.child("usernames/\(tempUsername)").observeSingleEvent(of: .value, with: { (snapshot) in
                    if snapshot.exists()
                    {
                        if(self.tempUsername != username)
                        {
                            self.usernameFail2.isHidden = false
                        } else
                        {
                            self.usernameFail2.isHidden = true
                            AccCounter += 1
                            if(AccCounter == 3)
                            {
                                db.child("users/\(userEmail!)/username").setValue(self.tempUsername)
                                db.child("users/\(userEmail!)/name").setValue(self.tempName)
                                db.child("users/\(userEmail!)/account_type").setValue(self.tempRole)
                                

                                interests = self.interestsTemp
                                
                                db.child("users/\(userEmail!)/interests").removeValue()
                                for i in 0...(interests.count - 1)
                                {
                                    db.child("users/\(userEmail!)/interests/\(i)").setValue(interests[i])
                                }
                                
                                name = self.tempName
                                role = self.tempRole
                                username = self.tempUsername
                                
                                
                                if(self.needToUpdate)
                                {
                                    guard let imageData = self.ppImageRef.image?.jpegData(compressionQuality: 0.75) else { return }
                                    let uploadMetadata = StorageMetadata.init()
                                    uploadMetadata.contentType = "image/jpeg"
                                    let uploadRef = self.st.child("profilepics/\(username).jpg").putData(imageData, metadata: uploadMetadata) { (downloadMetadata, error) in
                                        if let _ = error
                                        {
                                            print("failureupload")
                                            return
                                        }

                                        ownProfPic = self.ppImageRef.image
                                        
                                        
                                    }
                                    NotificationCenter.default.post(name: Notification.Name("uploadBarStart"), object: nil)
                                    uploadRef.observe(.progress)
                                    { (snapshot) in
                                        NotificationCenter.default.post(name: Notification.Name("uploadBar"), object: nil)
                                        uploadProgress = snapshot.progress?.fractionCompleted
                                    }
                                    uploadRef.observe(.success)
                                    { (snapshot) in
                                        ownProfPic = self.ppImageRef.image
                                        NotificationCenter.default.post(name: Notification.Name("uploadBarComplete"), object: nil)
                                        NotificationCenter.default.post(name: Notification.Name("profImageLoaded"), object: nil)
                                        
                                    }
                                    
                                    self.needToUpdate = false
                                }
                                
                                NotificationCenter.default.post(name: Notification.Name("animateOffEditProf"), object: nil)
                            }
                        }
                    } else
                    {
                        AccCounter += 1
                        self.usernameFail2.isHidden = true
                        if(AccCounter == 3)
                        {
                            self.st.child("profilepics/\(username).jpg").delete
                                { (error) in
                                if error != nil
                                {
                                    return
                                }
                            }
                            db.child("usernames/\(username)").removeValue()
                            db.child("usernames/\(self.tempUsername)").setValue("\(userEmail!)")
                            
                            db.child("users/\(userEmail!)/username").setValue(self.tempUsername)
                            db.child("users/\(userEmail!)/name").setValue(self.tempName)
                            db.child("users/\(userEmail!)/account_type").setValue(self.tempRole)
                            
                            
                            
                            name = self.tempName
                            role = self.tempRole
                            username = self.tempUsername
                            
                            guard let imageData = self.ppImageRef.image?.jpegData(compressionQuality: 0.0) else { return }
                            let uploadMetadata = StorageMetadata.init()
                            uploadMetadata.contentType = "image/jpeg"
                            let uploadRef = self.st.child("profilepics/\(username).jpg").putData(imageData, metadata: uploadMetadata) { (downloadMetadata, error) in
                                if let _ = error
                                {
                                    print("failureupload")
                                    return
                                }
                                
                                ownProfPic = self.ppImageRef.image
                                
                                
                                
                            }
                            NotificationCenter.default.post(name: Notification.Name("uploadBarStart"), object: nil)
                            uploadRef.observe(.progress)
                            { (snapshot) in
                                NotificationCenter.default.post(name: Notification.Name("uploadBar"), object: nil)
                                uploadProgress = snapshot.progress?.fractionCompleted
                            }
                            uploadRef.observe(.success)
                            { (snapshot) in
                                NotificationCenter.default.post(name: Notification.Name("uploadBarComplete"), object: nil)
                                NotificationCenter.default.post(name: Notification.Name("profImageLoaded"), object: nil)
                            }
                            self.needToUpdate = false
                            
                            NotificationCenter.default.post(name: Notification.Name("animateOffEditProf"), object: nil)
                        }
                    }
                })
            } else
            {
                usernameFail.isHidden = false
            }
        }
    }
    
    @objc func closeMenus()
    {
        if(isMe)
        {
            if(currScene == "EditProfile")
            {
                view.endEditing(true)
            }
            if(menuToggle)
            {
                NotificationCenter.default.post(name: Notification.Name("closeMenuTab"), object: nil)
            }
        }
    }
    
    @objc func updatePreset(notification: NSNotification)
    {
        if(isMe)
        {
            tempRole = role
            tempName = name
            tempUsername = username
            roleButtonRef.setTitle("\(tempRole)", for: .normal)
            ppImageRef.image = ownProfPic
            nameKB.text = name
            interestsTemp = interests
            usernameKB.text = username
            currScene = "EditProfile"
            if(!instantInt)
            {
                intvVC[0].isActive = false
                intvVC[1].isActive = false
                intvVC[2].isActive = true
                intvVC[3].isActive = true
                interestView.isHidden = true
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc func keyboardWillShow(notification: NSNotification)
    {
        if(currScene == "EditProfile" && isMe)
        {
            if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            {
                self.view.frame.origin.y = -keyboardSize.height * 0.7
                self.view.layoutIfNeeded()
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification)
    {
        if(currScene == "EditProfile" && isMe)
        {
            self.view.frame.origin.y = 0
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func editPPPressed(_ sender: UIButton)
    {
        if(isMe && currScene == "EditProfile")
        {
            let picker = UIImagePickerController()
            
            picker.allowsEditing = true
            
            picker.delegate = self
            
            present(picker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        if(isMe && currScene == "EditProfile")
        {
        
            if let originalImage = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")]
            {
                tempImage = originalImage as? UIImage
                
                let contextImage: UIImage = UIImage(cgImage: tempImage.cgImage!)
                let contextSize: CGSize = contextImage.size
                var posX: CGFloat = 0.0
                var posY: CGFloat = 0.0
                var cgwidth: CGFloat = CGFloat(0.0)
                var cgheight: CGFloat = CGFloat(0.0)

                if(contextSize.width > contextSize.height)
                {
                    posX = ((contextSize.width - contextSize.height) / 2.0)
                    posY = 0
                    cgwidth = contextSize.height
                    cgheight = contextSize.height
                } else
                {
                    posX = 0
                    posY = ((contextSize.height - contextSize.width) / 2.0)
                    cgwidth = contextSize.width
                    cgheight = contextSize.width
                }

                let rect: CGRect = CGRect(x: posX, y: posY, width: cgwidth, height: cgheight)
                let imageRef: CGImage = contextImage.cgImage!.cropping(to: rect)!
                let newImage: UIImage = UIImage(cgImage: imageRef, scale: tempImage.scale, orientation: tempImage.imageOrientation)
                
                tempImage = newImage
                ppImageRef.image = tempImage
                needToUpdate = true
            } else
            {
                
                
                
                // error notification popup
                
                
                
            }
            dismiss(animated: true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        if(isMe && currScene == "EditProfile")
        {
            dismiss(animated: true, completion: nil)
        }
    }
    
}

