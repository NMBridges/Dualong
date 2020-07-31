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
    
    let st = Storage.storage().reference()
    
    @IBOutlet weak var usernameFail: UILabel!
    @IBOutlet weak var nameFail: UILabel!
    @IBOutlet weak var nameFail2: UILabel!
    @IBOutlet weak var accTypeFail: UILabel!
    @IBOutlet weak var usernameFail2: UILabel!
    
    @IBOutlet weak var ppImageRef: UIImageView!
    
    @IBOutlet var roleButtonCollection: [UIButton]!
    
    @IBOutlet weak var roleButtonRef: UIButton!
    
    @IBOutlet weak var usernameField: UITextField!
    
    @IBOutlet weak var nameField: UITextField!
    
    @IBOutlet weak var usernameKB: UITextField!
    
    @IBOutlet weak var nameKB: UITextField!
    
    @IBOutlet var keyboardsSet: [UITextField]!
    
    let db = Database.database().reference()
    
    var needToUpdate: Bool = false
    
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
            
            ppImageRef.layer.borderWidth = 1
            ppImageRef.layer.masksToBounds = false
            ppImageRef.layer.borderColor = UIColor.white.cgColor
            ppImageRef.layer.cornerRadius = ppImageRef.frame.height / 2.0
            ppImageRef.clipsToBounds = true
            
            NotificationCenter.default.addObserver(self, selector: #selector(updatePreset(notification:)), name: Notification.Name("editProf"), object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(loggingOut(notification:)), name: Notification.Name("logOut"), object: nil)
        }
        
    }
    
    @IBAction func roleButtonPressed(_ sender: UIButton)
    {
        if(isMe)
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
    
    @IBAction func saveButtonPressed(_ sender: UIButton)
    {
        if(isMe)
        {
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
            usernameKB.text = username
            currScene = "EditProfile"
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
        if(isMe)
        {
            let picker = UIImagePickerController()
            
            picker.allowsEditing = true
            
            picker.delegate = self
            
            present(picker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        if(isMe)
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
        if(isMe)
        {
            dismiss(animated: true, completion: nil)
        }
    }
    
}

