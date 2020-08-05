//
//  ConnectionsViewController.swift
//  Dualong
//
//  Created by Nolan Bridges on 7/25/20.
//  Copyright © 2020 NiMBLe Interactive. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage

class ConnectionsViewController: UIViewController, UITextViewDelegate
{
    let st = Storage.storage().reference()
    let db = Database.database().reference()
    var isMe: Bool = true
    
    @IBOutlet weak var connTitleRef: UILabel!
    
    var SV: UIScrollView = UIScrollView()
    var stackView: UIStackView = UIStackView()
    var svLC: [NSLayoutConstraint]! = []
    
    var buttList: [UIButton]! = []
    var nameList: [String]! = []
    var usernameList: [String]! = []
    var emailList: [String]! = []
    var profpicList: [UIImage]! = []
    var roleList: [String]! = []
    var connStatus: [String]! = []
    var errorList: [String]! = []
    var idList: [String]! = []
    var dateList: [String]! = []
    var timeList: [String]! = []
    var itemOrder: [Int]! = []
    var imgviewList: [UIImageView]! = []
    
    var nameInfo: String! = ""
    var usernameInfo: String! = ""
    var emailInfo: String! = ""
    var profpicInfo: UIImage! = UIImage()
    
    var loadCircle = UIView()
    var circle = UIBezierPath()
    var displayLink: CADisplayLink!
    var shapeLayer: CAShapeLayer!
    var time = CACurrentMediaTime()
    var ogtime = CACurrentMediaTime()
    
    var mView: UIView = UIView()
    var mvLC: [NSLayoutConstraint]! = []
    var mScrollView: UIScrollView = UIScrollView()
    var mStackView: UIStackView = UIStackView()
    var mTextView: UITextView = UITextView()
    var mBackButton: UIButton = UIButton()

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        if(isMe)
        {
            let conncloseTap = UITapGestureRecognizer(target: self, action: #selector(closeMenu))
            conncloseTap.cancelsTouchesInView = false
            view.addGestureRecognizer(conncloseTap)
            
            instantiateScrollView()
            instantiateMessageView()
            
            self.connTitleRef.alpha = 1.0
            
            setupLoadCircle()
            displayLink = CADisplayLink(target: self, selector: #selector(loadAnimations))
            displayLink.add(to: RunLoop.main, forMode: .default)
            
            NotificationCenter.default.addObserver(self, selector: #selector(loggingOut(notification:)), name: Notification.Name("logOut"), object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(loadConnectionsNoti(notification:)), name: Notification.Name("toConnectionsNoti"), object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        }
        
    }
    
    @objc func connectionPressed(_ sender: UIButton!)
    {
        let num = Int(sender.title(for: .normal)!)!
        
        nameInfo = nameList[num]
        usernameInfo = usernameList[num]
        emailInfo = emailList[num]
        profpicInfo = profpicList[num]
        
        connTitleRef.alpha = 1.0
        
        self.view.layoutIfNeeded()
        
        UIView.animate(withDuration: 0.2, animations: {
            
            self.svLC[0].isActive = false
            self.svLC[1].isActive = false
            
            self.svLC[2].isActive = true
            self.svLC[3].isActive = true
            
            self.mvLC[0].isActive = false
            self.mvLC[1].isActive = false
            
            self.mvLC[2].isActive = true
            self.mvLC[3].isActive = true
            
            sender.backgroundColor = UIColor(displayP3Red: 120.0 / 255.0, green: 110.0 / 255.0, blue: 220.0 / 255.0, alpha: 0.8)
            self.connTitleRef.alpha = 0.0
            
            self.view.layoutIfNeeded()
            
        }) { _ in
            
            sender.backgroundColor = UIColor.clear
            self.view.layoutIfNeeded()
            
        }
        
    }
    
    func loadMessages(id: String)
    {
        db.child("connections/\(id)")
    }
    
    func addStackViewMember(cc: Int)
    {
        let VIEW = UIView()
        let BUTTON = UIButton()
        let LABEL = UILabel()
        imgviewList[cc] = UIImageView()
        let barHeight = CGFloat(100.0)
        
        VIEW.translatesAutoresizingMaskIntoConstraints = false
        VIEW.removeConstraints(VIEW.constraints)
        stackView.addArrangedSubview(VIEW)
        VIEW.heightAnchor.constraint(equalToConstant: barHeight).isActive = true
        VIEW.layer.cornerRadius = UIScreen.main.bounds.width * 0.03
        VIEW.backgroundColor = UIColor(displayP3Red: 86.0 / 255.0, green: 84.0 / 255.0, blue: 213.0 / 255.0, alpha: 1)
        VIEW.alpha = 1.0
        
        BUTTON.translatesAutoresizingMaskIntoConstraints = false
        BUTTON.removeConstraints(BUTTON.constraints)
        buttList[cc] = BUTTON
        VIEW.addSubview(buttList[cc])
        BUTTON.leadingAnchor.constraint(equalTo: VIEW.leadingAnchor).isActive = true
        BUTTON.trailingAnchor.constraint(equalTo: VIEW.trailingAnchor).isActive = true
        BUTTON.topAnchor.constraint(equalTo: VIEW.topAnchor).isActive = true
        BUTTON.bottomAnchor.constraint(equalTo: VIEW.bottomAnchor).isActive = true
        BUTTON.backgroundColor = UIColor.clear
        BUTTON.setTitle("\(cc)", for: .normal)
        BUTTON.setTitleColor(UIColor.clear, for: .normal)
        BUTTON.layer.cornerRadius = UIScreen.main.bounds.width * 0.03
        BUTTON.addTarget(self, action: #selector(connectionPressed(_:)), for: .touchUpInside)
        
        imgviewList[cc].translatesAutoresizingMaskIntoConstraints = false
        imgviewList[cc].removeConstraints(imgviewList[cc].constraints)
        VIEW.addSubview(imgviewList[cc])
        imgviewList[cc].leadingAnchor.constraint(equalTo: VIEW.leadingAnchor, constant: barHeight * 0.2).isActive = true
        imgviewList[cc].trailingAnchor.constraint(equalTo: VIEW.leadingAnchor, constant: barHeight * 0.8).isActive = true
        imgviewList[cc].topAnchor.constraint(equalTo: VIEW.topAnchor, constant: barHeight * 0.2).isActive = true
        imgviewList[cc].bottomAnchor.constraint(equalTo: VIEW.topAnchor, constant: barHeight * 0.8).isActive = true
        imgviewList[cc].image = profpicList[cc]
        imgviewList[cc].layer.masksToBounds = false
        imgviewList[cc].layer.borderWidth = 1.0
        imgviewList[cc].layer.cornerRadius = barHeight * 0.3
        imgviewList[cc].layer.borderColor = UIColor.white.cgColor
        imgviewList[cc].clipsToBounds = true
        imgviewList[cc].alpha = 1.0
        
        LABEL.translatesAutoresizingMaskIntoConstraints = false
        LABEL.removeConstraints(LABEL.constraints)
        VIEW.addSubview(LABEL)
        LABEL.leadingAnchor.constraint(equalTo: VIEW.leadingAnchor, constant: barHeight).isActive = true
        LABEL.trailingAnchor.constraint(equalTo: VIEW.trailingAnchor).isActive = true
        LABEL.topAnchor.constraint(equalTo: VIEW.topAnchor).isActive = true
        LABEL.bottomAnchor.constraint(equalTo: VIEW.bottomAnchor).isActive = true
        LABEL.textColor = UIColor.white
        LABEL.text = nameList[cc]
        LABEL.font = UIFont(name: "HelveticaNeue", size: 24.0)
        LABEL.backgroundColor = UIColor.clear
        LABEL.alpha = 1.0
        
    }
    
    func sortStackViews()
    {
        
        var combinedDate: [Int:String] = [:]
        var combinedTime: [Int:String] = [:]
        var combinedTimeDate: [Int:Int] = [:]
        
        var b: Int = 0
        dateList.forEach { date in
            
            let helper = date.split(separator: "-")
            
            let year = "\(helper[0])"
            
            var month = "0\(helper[1])"
            if("\(helper[1])".count == 2)
            {
                month = "\(helper[1])"
            }
            
            var day = "0\(helper[2])"
            if("\(helper[2])".count == 2)
            {
                day = "\(helper[2])"
            }
            
            combinedDate[b] = "\(year)\(month)\(day)"
            
            b += 1
        }
        
        b = 0
        timeList.forEach { time in
            
            let helper = time.split(separator: ":")
            
            var hour = "0\(helper[0])"
            if("\(helper[0])".count == 2)
            {
                hour = "\(helper[0])"
            }
            
            var minute = "0\(helper[1])"
            if("\(helper[1])".count == 2)
            {
                minute = "\(helper[1])"
            }
            
            var second = "0\(helper[2])"
            if("\(helper[2])".count == 2)
            {
                second = "\(helper[2])"
            }
            
            combinedTime[b] = "\(hour)\(minute)\(second)"
            
            b += 1
            
        }
        
        for i in 0...(timeList.count - 1)
        {
            combinedTimeDate[i] = Int("\((combinedDate[i])!)\((combinedTime[i])!)")
            print(combinedTimeDate[i]!)
        }
        
        let sortedDict = combinedTimeDate.sorted { $0.1 > $1.1 }
        
        itemOrder = []
        b = 0
        sortedDict.forEach { (key: Int, value: Int) in
            itemOrder.append(key)
            print(itemOrder[b])
            b += 1
        }
        
        loadCircle.isHidden = true
        
        for q in 0...(itemOrder.count - 1)
        {
            addStackViewMember(cc: itemOrder[q])
        }
        
    }
    
    func loadConnections()
    {
        
        loadCircle.isHidden = false
        
        stackView.subviews.forEach { subview in
            stackView.removeArrangedSubview(subview)
            subview.removeFromSuperview()
            subview.isHidden = true
        }
        
        svLC[2].isActive = false
        svLC[3].isActive = false
        
        svLC[0].isActive = true
        svLC[1].isActive = true
        
        buttList = []
        nameList = []
        usernameList = []
        emailList = []
        profpicList = []
        roleList = []
        connStatus = []
        errorList = []
        idList = []
        dateList = []
        timeList = []
        imgviewList = []
        
        connections.forEach { (key: String, value: String) in
            buttList.append(UIButton())
            nameList.append("")
            usernameList.append("")
            emailList.append("")
            profpicList.append(UIImage(named: "defaultProfileImageSolid")!)
            roleList.append("")
            connStatus.append("")
            errorList.append("")
            idList.append("")
            dateList.append("")
            timeList.append("")
            imgviewList.append(UIImageView())
        }
        
        // creating arrays with values, then sorting, then adding to stack view
        
        var PP: Int = 0
        let optLeng = connections.count
        
        for (key, value) in connections
        {
            let _ = value
            let c = PP
            usernameList[c] = key
            db.child("usernames/\(key)").observeSingleEvent(of: .value) { snap in
                if let tEmail = snap.value as? String
                {
                    self.emailList[c] = tEmail
                    self.db.child("users/\(tEmail)/name").observeSingleEvent(of: .value) { snap2 in
                        if let tName = snap2.value as? String
                        {
                            self.nameList[c] = tName
                            self.db.child("users/\(tEmail)/account_type").observeSingleEvent(of: .value) { snap3 in
                                if let tRole = snap3.value as? String
                                {
                                    self.roleList[c] = tRole
                                    self.db.child("users/\(userEmail!)/connections/\(key)").observeSingleEvent(of: .value) { snap4 in
                                        if let randID = snap4.value as? String
                                        {
                                            self.idList[c] = randID
                                            self.db.child("connections/\(randID)/\(username)/status").observeSingleEvent(of: .value) { snap5 in
                                                if let tStatus = snap5.value as? String
                                                {
                                                    self.connStatus[c] = tStatus
                                                    self.db.child("connections/\(randID)/last_message_time/date").observeSingleEvent(of: .value) { snap6 in
                                                        if let tDate = snap6.value as? String
                                                        {
                                                            self.dateList[c] = tDate
                                                            self.db.child("connections/\(randID)/last_message_time/time").observeSingleEvent(of: .value) { snap7 in
                                                                if let tTime = snap7.value as? String
                                                                {
                                                                    self.timeList[c] = tTime
                                                                    if(c >= optLeng - 1)
                                                                    {
                                                                        self.sortStackViews()
                                                                    }
                                                                    self.st.child("profilepics/\(key).jpg").getData(maxSize: 4 * 1024 * 1024, completion: { (data, error) in
                                                                        if error != nil
                                                                        {
                                                                            print("error loading image \(error!)")
                                                                            //self.errorList[c] = "FAIL"
                                                                        }
                                                                        if let data = data
                                                                        {
                                                                            let tImage = UIImage(data: data)!
                                                                            self.profpicList[c] = tImage
                                                                            self.imgviewList[c].image = self.profpicList[c]
                                                                        }
                                                                    })
                                                                } else
                                                                {
                                                                    self.errorList[c] = "FAIL"
                                                                }
                                                            }
                                                        } else
                                                        {
                                                            self.errorList[c] = "FAIL"
                                                        }
                                                    }
                                                } else
                                                {
                                                    self.errorList[c] = "FAIL"
                                                }
                                            }
                                            
                                        } else
                                        {
                                            self.errorList[c] = "FAIL"
                                        }
                                    }
                                } else
                                {
                                    self.errorList[c] = "FAIL"
                                }
                            }
                        } else
                        {
                            self.errorList[c] = "FAIL"
                        }
                    }
                } else
                {
                    self.errorList[c] = "FAIL"
                }
            }
            PP += 1
        }
        
    }
    
    @objc func loadConnectionsNoti(notification: NSNotification)
    {
        if(isMe)
        {
            connTitleRef.alpha = 1.0
            loadConnections()
        }
    }
    
    func instantiateScrollView()
    {
        SV = UIScrollView()
        self.view.addSubview(SV)
        SV.translatesAutoresizingMaskIntoConstraints = false
        SV.removeConstraints(SV.constraints)
        SV.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 5.0).isActive = true
        SV.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -5.0).isActive = true
        SV.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 105.0).isActive = true
        SV.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -5.0).isActive = true
        
        let widd = UIScreen.main.bounds.width
        
        svLC = []
        stackView = UIStackView()
        SV.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.removeConstraints(stackView.constraints)
        svLC.append(stackView.leadingAnchor.constraint(equalTo: SV.contentLayoutGuide.leadingAnchor))
        svLC[0].isActive = true
        svLC.append(stackView.trailingAnchor.constraint(equalTo: SV.contentLayoutGuide.trailingAnchor))
        svLC[1].isActive = true
        svLC.append(stackView.leadingAnchor.constraint(equalTo: SV.contentLayoutGuide.leadingAnchor, constant: -widd))
        svLC[2].isActive = false
        svLC.append(stackView.trailingAnchor.constraint(equalTo: SV.contentLayoutGuide.trailingAnchor, constant: -widd))
        svLC[3].isActive = false
        stackView.topAnchor.constraint(equalTo: SV.contentLayoutGuide.topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: SV.contentLayoutGuide.bottomAnchor).isActive = true
        stackView.widthAnchor.constraint(equalTo: SV.frameLayoutGuide.widthAnchor).isActive = true
        stackView.spacing = 5.0
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.axis = .vertical
        
        self.view.layoutIfNeeded()
    }
    
    func instantiateMessageView()
    {
        
        let widd = UIScreen.main.bounds.width
        
        mView = UIView()
        mView.translatesAutoresizingMaskIntoConstraints = false
        mView.removeConstraints(mView.constraints)
        self.view.addSubview(mView)
        mvLC = []
        mvLC.append(mView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: widd))
        mvLC[0].isActive = true
        mvLC.append(mView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: widd))
        mvLC[1].isActive = true
        mvLC.append(mView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor))
        mvLC[2].isActive = false
        mvLC.append(mView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor))
        mvLC[3].isActive = false
        mView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        mView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        mView.alpha = 1.0
        mView.backgroundColor = UIColor(displayP3Red: 55.0 / 255.0, green: 55.0 / 255.0, blue: 110.0 / 255.0, alpha: 1.0)
        
        mScrollView = UIScrollView()
        mScrollView.translatesAutoresizingMaskIntoConstraints = false
        mScrollView.removeConstraints(mScrollView.constraints)
        mView.addSubview(mScrollView)
        mScrollView.leadingAnchor.constraint(equalTo: mView.leadingAnchor).isActive = true
        mScrollView.trailingAnchor.constraint(equalTo: mView.trailingAnchor).isActive = true
        mScrollView.topAnchor.constraint(equalTo: mView.topAnchor, constant: 60.0).isActive = true
        mScrollView.bottomAnchor.constraint(equalTo: mView.bottomAnchor, constant: -50.0).isActive = true
        
        mStackView = UIStackView()
        mStackView.translatesAutoresizingMaskIntoConstraints = false
        mStackView.removeConstraints(mStackView.constraints)
        mScrollView.addSubview(mStackView)
        mStackView.leadingAnchor.constraint(equalTo: mScrollView.contentLayoutGuide.leadingAnchor).isActive = true
        mStackView.trailingAnchor.constraint(equalTo: mScrollView.contentLayoutGuide.trailingAnchor).isActive = true
        mStackView.topAnchor.constraint(equalTo: mScrollView.contentLayoutGuide.topAnchor).isActive = true
        mStackView.bottomAnchor.constraint(equalTo: mScrollView.contentLayoutGuide.bottomAnchor).isActive = true
        mStackView.widthAnchor.constraint(equalTo: mScrollView.frameLayoutGuide.widthAnchor).isActive = true
        mStackView.spacing = 5.0
        mStackView.distribution = .fill
        mStackView.alignment = .fill
        mStackView.axis = .vertical
        
        mTextView = UITextView()
        mTextView.translatesAutoresizingMaskIntoConstraints = false
        mTextView.removeConstraints(mTextView.constraints)
        mView.addSubview(mTextView)
        mTextView.delegate = self
        mTextView.leadingAnchor.constraint(equalTo: mView.leadingAnchor, constant: 5.0).isActive = true
        mTextView.trailingAnchor.constraint(equalTo: mView.trailingAnchor, constant: -50.0).isActive = true
        mTextView.topAnchor.constraint(equalTo: mView.bottomAnchor, constant: -45.0).isActive = true
        mTextView.bottomAnchor.constraint(equalTo: mView.bottomAnchor, constant: -5.0).isActive = true
        mTextView.backgroundColor = UIColor(displayP3Red: 0.3, green: 0.3, blue: 0.5, alpha: 1.0)
        mTextView.textColor = UIColor(displayP3Red: 1.0, green: 1.0, blue: 1.0, alpha: 0.5)
        mTextView.text = "message..."
        mTextView.font = UIFont(name: "HelveticaNeue", size: 20.0)
        mTextView.layer.cornerRadius = 20.0
        mTextView.layer.borderWidth = 1.0
        mTextView.layer.borderColor = UIColor(displayP3Red: 1.0, green: 1.0, blue: 1.0, alpha: 0.8).cgColor
        mTextView.contentInset.left = 10.0
        mTextView.contentInset.right = 10.0
        mTextView.returnKeyType = .send
        
        self.view.layoutIfNeeded()
    }
    
    @objc func closeMenu()
    {
        if(menuToggle && isMe)
        {
            NotificationCenter.default.post(name: Notification.Name("closeMenuTab"), object: nil)
        }
        if(isMe)
        {
            view.endEditing(true)
        }
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
        if(isMe)
        {
            time = CACurrentMediaTime()
            let startAng: CGFloat = CGFloat((time - ogtime) * 12.0 + sin((time - ogtime) * 8.0) * 0.9)
            let endAng: CGFloat = CGFloat(((time - ogtime) * 12.0 + 1.5) + sin((time - ogtime) * 8.0 + 1.0) * 0.9)
            circle = UIBezierPath(arcCenter: CGPoint(x: 50.0, y: 50.0), radius: 25, startAngle: startAng, endAngle: endAng, clockwise: true)
            shapeLayer.path = circle.cgPath
        }
    }
    
    @objc func keyboardWillShow(notification: NSNotification)
    {
        self.view.layoutIfNeeded()
        if(currScene == "Connections" && isMe)
        {
            if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            {
                self.view.frame.origin.y = -keyboardSize.height
                self.view.layoutIfNeeded()
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification)
    {
        self.view.layoutIfNeeded()
        if(currScene == "Connections" && isMe)
        {
            self.view.frame.origin.y = 0
            self.view.layoutIfNeeded()
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool
    {
        if(text == "\n" && isMe)
        {
            textView.resignFirstResponder()
            print(textView.text!)
            
            createTextView(text: textView.text!, atindex: -1, userself: false)
            // save value here, upload
            
            let bottomOffset = CGPoint(x: 0, y: mScrollView.contentSize.height - mScrollView.bounds.size.height)
            mScrollView.setContentOffset(bottomOffset, animated: true)
            
            clearText()
            return false
        }
        return true
    }
    
    func createTextView(text: String, atindex: Int, userself: Bool)
    {
        let postOverallView = UIView()
        let postView = UIView()
        let postLabel = UILabel()
        
        let screenWidth = UIScreen.main.bounds.width
        let viewWidth = screenWidth * 0.7
        let viewHeight = text.heightWithConstrainedWidth(width: viewWidth, font: UIFont(name: "HelveticaNeue", size: 20.0)!) + 17.0
        
        postOverallView.translatesAutoresizingMaskIntoConstraints = false
        postOverallView.removeConstraints(postOverallView.constraints)
        if(atindex == -1)
        {
            mStackView.addArrangedSubview(postOverallView)
        } else
        {
            mStackView.insertArrangedSubview(postOverallView, at: atindex)
        }
        postOverallView.heightAnchor.constraint(equalToConstant: viewHeight + 10.0).isActive = true
        postOverallView.backgroundColor = UIColor.clear
        
        postView.translatesAutoresizingMaskIntoConstraints = false
        postView.removeConstraints(postView.constraints)
        postOverallView.addSubview(postView)
        postView.layer.cornerRadius = 20.0
        if(userself)
        {
            postView.backgroundColor = UIColor(displayP3Red: 86.0 / 255.0, green: 84.0 / 255.0, blue: 213.0 / 255.0, alpha: 1.0)
            postView.leadingAnchor.constraint(equalTo: postOverallView.trailingAnchor, constant: -viewWidth - 45.0).isActive = true
            postView.trailingAnchor.constraint(equalTo: postOverallView.trailingAnchor, constant: -5.0).isActive = true
        } else
        {
            postView.backgroundColor = UIColor(displayP3Red: 86.0 / 255.0, green: 86.0 / 255.0, blue: 86.0 / 255.0, alpha: 1.0)
            postView.trailingAnchor.constraint(equalTo: postOverallView.leadingAnchor, constant: viewWidth + 45.0).isActive = true
            postView.leadingAnchor.constraint(equalTo: postOverallView.leadingAnchor, constant: 5.0).isActive = true
        }
        postView.topAnchor.constraint(equalTo: postOverallView.topAnchor).isActive = true
        postView.bottomAnchor.constraint(equalTo: postOverallView.bottomAnchor).isActive = true
        
        postLabel.translatesAutoresizingMaskIntoConstraints = false
        postLabel.removeConstraints(postLabel.constraints)
        postView.addSubview(postLabel)
        postLabel.trailingAnchor.constraint(equalTo: postView.trailingAnchor, constant: -20.0).isActive = true
        postLabel.leadingAnchor.constraint(equalTo: postView.leadingAnchor, constant: 20.0).isActive = true
        postLabel.topAnchor.constraint(equalTo: postView.topAnchor, constant: 5.0).isActive = true
        postLabel.bottomAnchor.constraint(equalTo: postView.bottomAnchor, constant: -5.0).isActive = true
        postLabel.text = text
        postLabel.font = UIFont(name: "HelveticaNeue", size: 20.0)
        postLabel.textColor = UIColor.white
        postLabel.lineBreakMode = .byWordWrapping
        postLabel.numberOfLines = 0
        postLabel.textAlignment = .left
        
    }
    
    func textViewDidBeginEditing(_ textView: UITextView)
    {
        if(isMe)
        {
            let bottomOffset = CGPoint(x: 0, y: mScrollView.contentSize.height - mScrollView.bounds.size.height)
            mScrollView.setContentOffset(bottomOffset, animated: true)
            self.view.layoutIfNeeded()
            if(textView.text == "message...")
            {
                textView.text = ""
                textView.textColor = UIColor(displayP3Red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                mTextView.contentInset.left = 10.0
                mTextView.contentInset.right = 10.0
                self.view.layoutIfNeeded()
            }
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView)
    {
        if(isMe)
        {
            self.view.layoutIfNeeded()
            if(textView.text == "")
            {
                textView.text = "message..."
                textView.textColor = UIColor(displayP3Red: 1.0, green: 1.0, blue: 1.0, alpha: 0.5)
                mTextView.contentInset.left = 10.0
                mTextView.contentInset.right = 10.0
                self.view.layoutIfNeeded()
            }
        }
    }
    
    func clearText()
    {
        mTextView.text = "message..."
        mTextView.textColor = UIColor(displayP3Red: 1.0, green: 1.0, blue: 1.0, alpha: 0.5)
        mTextView.contentInset.left = 10.0
        mTextView.contentInset.right = 10.0
    }

    @objc func loggingOut(notification: NSNotification)
    {
        if(isMe)
        {
            isMe = false
        }
    }
    

}

struct AppUtility {

    static func lockOrientation(_ orientation: UIInterfaceOrientationMask) {

        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.orientationLock = orientation
        }
    }

    static func lockOrientation(_ orientation: UIInterfaceOrientationMask, andRotateTo rotateOrientation:UIInterfaceOrientation) {

        self.lockOrientation(orientation)

        UIDevice.current.setValue(rotateOrientation.rawValue, forKey: "orientation")
        UINavigationController.attemptRotationToDeviceOrientation()
    }

}
