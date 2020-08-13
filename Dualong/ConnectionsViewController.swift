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

class ConnectionsViewController: UIViewController, UITextViewDelegate, UIScrollViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate, UITextFieldDelegate
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
    var idInfo: String! = ""
    
    var loadCircle = UIView()
    var lcLC: [NSLayoutConstraint]! = []
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
    var mNameLabel: UILabel = UILabel()
    var mNameBackground: UIView = UIView()
    var mPlusButton: UIButton! = UIButton()
    var mShadeView: UIView = UIView()
    var mOptionsView: UIView = UIView()
    var movLC: [NSLayoutConstraint]! = []
    var optionsToggle: Bool = false
    var togglingOptions: Bool = false
    var mUploadPicBut: UIButton! = UIButton()
    var mTutorSessBut: UIButton! = UIButton()
    var mOptSepView: UIView = UIView()
    var mPropView: UIView = UIView()
    var mpvLC: [NSLayoutConstraint]! = []
    var mPropCloseBut: UIButton = UIButton()
    var mPropLabel: UILabel = UILabel()
    var mPropTextField: UITextField! = UITextField()
    var mPropDate: UIDatePicker! = UIDatePicker()
    var mPropToggle: Bool = false
    var mPropButton: UIButton! = UIButton()
    
    var passedAutoID: String = ""
    
    var MSVUserList: [String]! = []
    var MSVMessageList: [String]! = []
    var MSVTimeList: [String]! = []
    var MSVDateList: [String]! = []
    var MSVIDList: [String]! = []
    
    var lastHeight: CGFloat = 0

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        if(isMe)
        {
            let conncloseTap = UITapGestureRecognizer(target: self, action: #selector(closeMenu))
            conncloseTap.cancelsTouchesInView = false
            conncloseTap.delegate = self
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
            NotificationCenter.default.addObserver(self, selector: #selector(closeMessages(notification:)), name: Notification.Name("toHomeNoti"), object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(closeMessages(notification:)), name: Notification.Name("toProfileNoti"), object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(closeMessages(notification:)), name: Notification.Name("toExploreNoti"), object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(closeMessages(notification:)), name: Notification.Name("toProfileNoti"), object: nil)
        }
        
    }
    
    @objc func connectionPressed(_ sender: UIButton!)
    {
        let num = Int(sender.title(for: .normal)!)!
        
        NotificationCenter.default.post(name: Notification.Name("toggleMenuOpacity"), object: nil)
        
        nameInfo = nameList[num]
        mNameLabel.text = nameInfo
        usernameInfo = usernameList[num]
        emailInfo = emailList[num]
        profpicInfo = profpicList[num]
        idInfo = idList[num]
        
        loadCircle.isHidden = false
        lcLC[0].isActive = false
        lcLC[1].isActive = true
        
        connTitleRef.alpha = 1.0
        
        self.view.layoutIfNeeded()
        
        loadMessages(id: idInfo)
        
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
        
        mStackView.subviews.forEach { vieww in
            mStackView.removeArrangedSubview(vieww)
            vieww.removeFromSuperview()
            vieww.isHidden = true
        }
        
        MSVMessageList = []
        MSVUserList = []
        MSVTimeList = []
        MSVDateList = []
        MSVIDList = []
        
        var COUNTER: Int = 0
        var totalCount: Int = 0
        
        db.child("connections/\(id)/message_list").observeSingleEvent(of: .value) { snap in
            if let children = snap.children.allObjects as? [DataSnapshot]
            {
                totalCount = children.count
                for _ in 0...(totalCount - 1)
                {
                    self.MSVMessageList.append("")
                    self.MSVUserList.append("")
                    self.MSVTimeList.append("")
                    self.MSVDateList.append("")
                    self.MSVIDList.append("")
                }
                for child in children
                {
                    let Q = COUNTER
                    self.MSVIDList[Q] = child.key
                    COUNTER += 1
                    if let subChildren = child.children.allObjects as? [DataSnapshot]
                    {
                        for child2 in subChildren
                        {
                            if(child2.key == "username")
                            {
                                self.MSVUserList[Q] = (child2.value as? String)!
                                if(self.MSVUserList[totalCount - 1] != "" && self.MSVMessageList[totalCount - 1] != "" && self.MSVTimeList[totalCount - 1] != "" && self.MSVDateList[totalCount - 1] != "")
                                {
                                    self.sortMessagesByTime()
                                }
                            }
                            if(child2.key == "timestamp")
                            {
                                if let timeChildren = child2.children.allObjects as? [DataSnapshot]
                                {
                                    for child3 in timeChildren
                                    {
                                        if(child3.key == "date")
                                        {
                                            self.MSVDateList[Q] = (child3.value as? String)!
                                        }
                                        if(child3.key == "time")
                                        {
                                            self.MSVTimeList[Q] = (child3.value as? String)!
                                        }
                                        if(self.MSVUserList[totalCount - 1] != "" && self.MSVMessageList[totalCount - 1] != "" && self.MSVTimeList[totalCount - 1] != "" && self.MSVDateList[totalCount - 1] != "")
                                        {
                                            self.sortMessagesByTime()
                                        }
                                    }
                                }
                            }
                            if(child2.key == "message")
                            {
                                self.MSVMessageList[Q] = (child2.value as? String)!
                                if(self.MSVUserList[totalCount - 1] != "" && self.MSVMessageList[totalCount - 1] != "" && self.MSVTimeList[totalCount - 1] != "" && self.MSVDateList[totalCount - 1] != "")
                                {
                                    self.sortMessagesByTime()
                                }
                            }
                        }
                    }
                }
            }
        }
        
    }
    
    func sortMessagesByTime()
    {
        var combinedDate: [Int:String] = [:]
        var combinedTime: [Int:String] = [:]
        var combinedTimeDate: [Int:Int] = [:]
        
        refreshChat()
        
        var b: Int = 0
        MSVDateList.forEach { date in
            
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
        MSVTimeList.forEach { time in
            
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
        
        for i in 0...(MSVTimeList.count - 1)
        {
            combinedTimeDate[i] = Int("\((combinedDate[i])!)\((combinedTime[i])!)")
        }
        
        let sortedDict = combinedTimeDate.sorted { $0.1 < $1.1 }
        
        itemOrder = []
        b = 0
        sortedDict.forEach { (key: Int, value: Int) in
            itemOrder.append(key)
            b += 1
        }
        
        loadCircle.isHidden = true
        
        for q in 0...(itemOrder.count - 1)
        {
            if(MSVUserList[itemOrder[q]] == username)
            {
                if("\(Array(MSVMessageList[itemOrder[q]])[0])\(Array(MSVMessageList[itemOrder[q]])[1])" == "/m")
                {
                    let MESS = "\(MSVMessageList[itemOrder[q]].dropFirst(2))"
                    createTextView(text: MESS, atindex: -1, userself: true, isImage: false, imagee: UIImage(), isProposal: false)
                } else if("\(Array(MSVMessageList[itemOrder[q]])[0])\(Array(MSVMessageList[itemOrder[q]])[1])" == "/i")
                {
                    let MESS = "\(MSVMessageList[itemOrder[q]].dropFirst(2))"
                    createTextView(text: MESS, atindex: -1, userself: true, isImage: true, imagee: UIImage(named: "loadImage"), isProposal: false)
                } else if("\(Array(MSVMessageList[itemOrder[q]])[0])\(Array(MSVMessageList[itemOrder[q]])[1])" == "/t")
                {
                    let MESS = "\(MSVMessageList[itemOrder[q]].dropFirst(2))"
                    createTextView(text: MESS, atindex: -1, userself: true, isImage: false, imagee: UIImage(), isProposal: true)
                }
            } else
            {
                if("\(Array(MSVMessageList[itemOrder[q]])[0])\(Array(MSVMessageList[itemOrder[q]])[1])" == "/m")
                {
                    let MESS = "\(MSVMessageList[itemOrder[q]].dropFirst(2))"
                    createTextView(text: MESS, atindex: -1, userself: false, isImage: false, imagee: UIImage(), isProposal: false)
                } else if("\(Array(MSVMessageList[itemOrder[q]])[0])\(Array(MSVMessageList[itemOrder[q]])[1])" == "/i")
                {
                    let MESS = "\(MSVMessageList[itemOrder[q]].dropFirst(2))"
                    createTextView(text: MESS, atindex: -1, userself: false, isImage: true, imagee: UIImage(named: "loadImage"), isProposal: false)
                } else if("\(Array(MSVMessageList[itemOrder[q]])[0])\(Array(MSVMessageList[itemOrder[q]])[1])" == "/t")
                {
                    let MESS = "\(MSVMessageList[itemOrder[q]].dropFirst(2))"
                    createTextView(text: MESS, atindex: -1, userself: false, isImage: false, imagee: UIImage(), isProposal: true)
                }
            }
        }
        loadCircle.isHidden = true
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
        }
        
        let sortedDict = combinedTimeDate.sorted { $0.1 > $1.1 }
        
        itemOrder = []
        b = 0
        sortedDict.forEach { (key: Int, value: Int) in
            itemOrder.append(key)
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
        
        lcLC[1].isActive = false
        lcLC[0].isActive = true
        
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
        
        
        db.child("users/\(userEmail!)/connections").observeSingleEvent(of: .value) { (SNAP) in
            if let childrenq = SNAP.children.allObjects as? [DataSnapshot]
            {
                for childq in childrenq
                {
                    connections["\(childq.key)"] = (childq.value as? String)!
                }
                
                connections.forEach { (key: String, value: String) in
                    self.buttList.append(UIButton())
                    self.nameList.append("")
                    self.usernameList.append("")
                    self.emailList.append("")
                    self.profpicList.append(UIImage(named: "defaultProfileImageSolid")!)
                    self.roleList.append("")
                    self.connStatus.append("")
                    self.errorList.append("")
                    self.idList.append("")
                    self.dateList.append("")
                    self.timeList.append("")
                    self.imgviewList.append(UIImageView())
                }
                
                var PP: Int = 0
                let optLeng = connections.count
                
                for (key, value) in connections
                {
                    let _ = value
                    let c = PP
                    self.usernameList[c] = key
                    self.db.child("usernames/\(key)").observeSingleEvent(of: .value) { snap in
                        if let tEmail = snap.value as? String
                        {
                            
                            // INDEX OUT OF RANGE ERROR AT self.emailList[c] = tEmail
                            
                            
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
        mScrollView.topAnchor.constraint(equalTo: mView.topAnchor, constant: 85.0).isActive = true
        mScrollView.bottomAnchor.constraint(equalTo: mView.bottomAnchor, constant: -50.0).isActive = true
        
        mStackView = UIStackView()
        mStackView.translatesAutoresizingMaskIntoConstraints = false
        mStackView.removeConstraints(mStackView.constraints)
        mScrollView.addSubview(mStackView)
        mStackView.leadingAnchor.constraint(equalTo: mScrollView.leadingAnchor).isActive = true
        mStackView.trailingAnchor.constraint(equalTo: mScrollView.trailingAnchor).isActive = true
        mStackView.topAnchor.constraint(equalTo: mScrollView.topAnchor).isActive = true
        mStackView.bottomAnchor.constraint(equalTo: mScrollView.bottomAnchor).isActive = true
        mStackView.widthAnchor.constraint(equalTo: mScrollView.widthAnchor).isActive = true
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
        
        mNameBackground = UIView()
        mNameBackground.translatesAutoresizingMaskIntoConstraints = false
        mNameBackground.removeConstraints(mNameBackground.constraints)
        mView.addSubview(mNameBackground)
        mNameBackground.leadingAnchor.constraint(equalTo: mView.safeAreaLayoutGuide.leadingAnchor).isActive = true
        mNameBackground.trailingAnchor.constraint(equalTo: mView.safeAreaLayoutGuide.trailingAnchor).isActive = true
        mNameBackground.topAnchor.constraint(equalTo: mView.topAnchor).isActive = true
        mNameBackground.bottomAnchor.constraint(equalTo: mView.topAnchor, constant: 80.0).isActive = true
        mNameBackground.backgroundColor = UIColor(displayP3Red: 70.0 / 255.0, green: 70.0 / 255.0, blue: 120.0 / 255.0, alpha: 1.0)
        mNameBackground.alpha = 1.0
        
        mBackButton = UIButton()
        mBackButton.translatesAutoresizingMaskIntoConstraints = false
        mBackButton.removeConstraints(mBackButton.constraints)
        mView.addSubview(mBackButton)
        mBackButton.leadingAnchor.constraint(equalTo: mView.safeAreaLayoutGuide.leadingAnchor, constant: 20.0).isActive = true
        mBackButton.trailingAnchor.constraint(equalTo: mView.safeAreaLayoutGuide.leadingAnchor, constant: 43.0).isActive = true
        mBackButton.topAnchor.constraint(equalTo: mView.safeAreaLayoutGuide.topAnchor, constant: 15.0).isActive = true
        mBackButton.bottomAnchor.constraint(equalTo: mView.safeAreaLayoutGuide.topAnchor, constant: 45.0).isActive = true
        mBackButton.setTitle("", for: .normal)
        mBackButton.tintColor = UIColor.white
        mBackButton.setBackgroundImage(UIImage(systemName: "chevron.left"), for: .normal)
        mBackButton.addTarget(self, action: #selector(closeMessageView(_:)), for: .touchUpInside)
        
        mNameLabel = UILabel()
        mNameLabel.translatesAutoresizingMaskIntoConstraints = false
        mNameLabel.removeConstraints(mNameLabel.constraints)
        mView.addSubview(mNameLabel)
        mNameLabel.leadingAnchor.constraint(equalTo: mView.safeAreaLayoutGuide.leadingAnchor, constant: 63).isActive = true
        mNameLabel.trailingAnchor.constraint(lessThanOrEqualTo: mView.safeAreaLayoutGuide.trailingAnchor, constant: -100).isActive = true
        mNameLabel.topAnchor.constraint(equalTo: mView.safeAreaLayoutGuide.topAnchor, constant: 15).isActive = true
        mNameLabel.bottomAnchor.constraint(equalTo: mView.safeAreaLayoutGuide.topAnchor, constant: 45).isActive = true
        mNameLabel.text = ""
        mNameLabel.font = UIFont(name: "HelveticaNeue", size: 25.0)
        mNameLabel.textColor = UIColor.white
        
        mShadeView = UIView()
        mShadeView.translatesAutoresizingMaskIntoConstraints = false
        mShadeView.removeConstraints(mShadeView.constraints)
        mView.addSubview(mShadeView)
        mShadeView.leadingAnchor.constraint(equalTo: mView.leadingAnchor).isActive = true
        mShadeView.trailingAnchor.constraint(equalTo: mView.trailingAnchor).isActive = true
        mShadeView.topAnchor.constraint(equalTo: mView.topAnchor).isActive = true
        mShadeView.bottomAnchor.constraint(equalTo: mView.bottomAnchor).isActive = true
        mShadeView.backgroundColor = UIColor.black
        mShadeView.alpha = 0.0
        
        mPlusButton = UIButton()
        mPlusButton.translatesAutoresizingMaskIntoConstraints = false
        mPlusButton.removeConstraints(mPlusButton.constraints)
        mView.addSubview(mPlusButton)
        mPlusButton.trailingAnchor.constraint(equalTo: mView.trailingAnchor, constant: -7.0).isActive = true
        mPlusButton.leadingAnchor.constraint(equalTo: mView.trailingAnchor, constant: -43.0).isActive = true
        mPlusButton.topAnchor.constraint(equalTo: mView.bottomAnchor, constant: -43.0).isActive = true
        mPlusButton.bottomAnchor.constraint(equalTo: mView.bottomAnchor, constant: -7.0).isActive = true
        mPlusButton.layer.cornerRadius = 20.0
        mPlusButton.backgroundColor = UIColor(displayP3Red: 86.0 / 255.0, green: 84.0 / 255.0, blue: 213.0 / 255.0, alpha: 1.0)
        mPlusButton.setImage(UIImage(systemName: "plus"), for: .normal)
        mPlusButton.tintColor = UIColor.white
        mPlusButton.addTarget(self, action: #selector(bringUpOptions(_:)), for: .touchUpInside)
        
        mOptionsView = UIView()
        mOptionsView.translatesAutoresizingMaskIntoConstraints = false
        mOptionsView.removeConstraints(mOptionsView.constraints)
        mView.addSubview(mOptionsView)
        mView.bringSubviewToFront(mOptionsView)
        movLC = []
        movLC.append(mOptionsView.trailingAnchor.constraint(equalTo: mPlusButton.trailingAnchor))
        movLC[0].isActive = true
        movLC.append(mOptionsView.leadingAnchor.constraint(equalTo: mPlusButton.leadingAnchor))
        movLC[1].isActive = true
        movLC.append(mOptionsView.topAnchor.constraint(equalTo: mPlusButton.topAnchor))
        movLC[2].isActive = true
        movLC.append(mOptionsView.bottomAnchor.constraint(equalTo: mPlusButton.bottomAnchor))
        movLC[3].isActive = true
        movLC.append(mOptionsView.trailingAnchor.constraint(equalTo: mView.trailingAnchor, constant: -5.0))
        movLC[4].isActive = false
        movLC.append(mOptionsView.leadingAnchor.constraint(equalTo: mView.leadingAnchor, constant: 5.0))
        movLC[5].isActive = false
        movLC.append(mOptionsView.topAnchor.constraint(equalTo: mView.bottomAnchor, constant: -150.0))
        movLC[6].isActive = false
        movLC.append(mOptionsView.bottomAnchor.constraint(equalTo: mView.bottomAnchor, constant: -50.0))
        movLC[7].isActive = false
        mOptionsView.layer.cornerRadius = 20.0
        mOptionsView.backgroundColor = UIColor(displayP3Red: 86.0 / 255.0, green: 84.0 / 255.0, blue: 213.0 / 255.0, alpha: 1.0)
        mOptionsView.alpha = 0.0
        
        mOptSepView = UIView()
        mOptSepView.translatesAutoresizingMaskIntoConstraints = false
        mOptSepView.removeConstraints(mOptSepView.constraints)
        mOptionsView.addSubview(mOptSepView)
        mOptSepView.leadingAnchor.constraint(equalTo: mOptionsView.leadingAnchor, constant: 17.5).isActive = true
        mOptSepView.trailingAnchor.constraint(equalTo: mOptionsView.trailingAnchor, constant: -17.5).isActive = true
        mOptSepView.topAnchor.constraint(equalTo: mOptionsView.centerYAnchor, constant: -0.5).isActive = true
        mOptSepView.bottomAnchor.constraint(equalTo: mOptionsView.centerYAnchor, constant: 0.5).isActive = true
        mOptSepView.backgroundColor = UIColor.white
        mOptSepView.layer.cornerRadius = 0.5
        mOptSepView.alpha = 0.5
        
        mUploadPicBut = UIButton()
        mUploadPicBut.translatesAutoresizingMaskIntoConstraints = false
        mUploadPicBut.removeConstraints(mUploadPicBut.constraints)
        mOptionsView.addSubview(mUploadPicBut)
        mUploadPicBut.leadingAnchor.constraint(equalTo: mOptionsView.leadingAnchor, constant: 10.0).isActive = true
        mUploadPicBut.trailingAnchor.constraint(equalTo: mOptionsView.trailingAnchor, constant: -10.0).isActive = true
        mUploadPicBut.topAnchor.constraint(equalTo: mOptionsView.topAnchor, constant: 5.0).isActive = true
        mUploadPicBut.bottomAnchor.constraint(equalTo: mOptionsView.centerYAnchor, constant: -5.0).isActive = true
        mUploadPicBut.backgroundColor = UIColor.clear
        mUploadPicBut.setTitle("Upload Picture", for: .normal)
        mUploadPicBut.setTitleColor(UIColor(displayP3Red: 1.0, green: 1.0, blue: 1.0, alpha: 0.75), for: .normal)
        mUploadPicBut.titleLabel?.font = UIFont(name: "HelveticaNeue", size: 22.0)
        mUploadPicBut.addTarget(self, action: #selector(uploadPicPressed(_:)), for: .touchUpInside)
        
        mTutorSessBut = UIButton()
        mTutorSessBut.translatesAutoresizingMaskIntoConstraints = false
        mTutorSessBut.removeConstraints(mTutorSessBut.constraints)
        mOptionsView.addSubview(mTutorSessBut)
        mTutorSessBut.leadingAnchor.constraint(equalTo: mOptionsView.leadingAnchor, constant: 10.0).isActive = true
        mTutorSessBut.trailingAnchor.constraint(equalTo: mOptionsView.trailingAnchor, constant: -10.0).isActive = true
        mTutorSessBut.topAnchor.constraint(equalTo: mOptionsView.centerYAnchor, constant: 5.0).isActive = true
        mTutorSessBut.bottomAnchor.constraint(equalTo: mOptionsView.bottomAnchor, constant: -5.0).isActive = true
        mTutorSessBut.backgroundColor = UIColor.clear
        mTutorSessBut.setTitle("Propose Tutoring Session", for: .normal)
        mTutorSessBut.setTitleColor(UIColor(displayP3Red: 1.0, green: 1.0, blue: 1.0, alpha: 0.75), for: .normal)
        mTutorSessBut.titleLabel?.font = UIFont(name: "HelveticaNeue", size: 22.0)
        mTutorSessBut.addTarget(self, action: #selector(proposeSessionPressed(_:)), for: .touchUpInside)
        
        mPropView = UIView()
        mPropView.translatesAutoresizingMaskIntoConstraints = false
        mPropView.removeConstraints(mPropView.constraints)
        mView.addSubview(mPropView)
        mpvLC = []
        mPropView.leadingAnchor.constraint(equalTo: mView.leadingAnchor, constant: 5.0).isActive = true
        mPropView.trailingAnchor.constraint(equalTo: mView.trailingAnchor, constant: -5.0).isActive = true
        mpvLC.append(mPropView.topAnchor.constraint(equalTo: mView.topAnchor, constant: 40.0))
        mpvLC[0].isActive = false
        mpvLC.append(mPropView.bottomAnchor.constraint(equalTo: mView.bottomAnchor, constant: 20.0))
        mpvLC[1].isActive = false
        mpvLC.append(mPropView.topAnchor.constraint(equalTo: mView.bottomAnchor, constant: 0.0))
        mpvLC[2].isActive = true
        mpvLC.append(mPropView.bottomAnchor.constraint(equalTo: mView.bottomAnchor, constant: 100.0))
        mpvLC[3].isActive = true
        mPropView.backgroundColor = UIColor(displayP3Red: 86.0 / 255.0, green: 84.0 / 255.0, blue: 213.0 / 255.0, alpha: 1.0)
        mPropView.layer.cornerRadius = 20.0
        mPropView.alpha = 0.0
        
        mPropCloseBut = UIButton()
        mPropCloseBut.translatesAutoresizingMaskIntoConstraints = false
        mPropCloseBut.removeConstraints(mPropCloseBut.constraints)
        mPropView.addSubview(mPropCloseBut)
        mPropCloseBut.trailingAnchor.constraint(equalTo: mPropView.trailingAnchor, constant: -25.0).isActive = true
        mPropCloseBut.leadingAnchor.constraint(equalTo: mPropView.trailingAnchor, constant: -55.0).isActive = true
        mPropCloseBut.topAnchor.constraint(equalTo: mPropView.topAnchor, constant: 25.0).isActive = true
        mPropCloseBut.bottomAnchor.constraint(equalTo: mPropView.topAnchor, constant: 55.0).isActive = true
        mPropCloseBut.setTitle("", for: .normal)
        mPropCloseBut.setBackgroundImage(UIImage(systemName: "plus"), for: .normal)
        mPropCloseBut.transform = mPropCloseBut.transform.rotated(by: .pi / 4.0)
        mPropCloseBut.tintColor = UIColor.white
        mPropCloseBut.addTarget(self, action: #selector(closePropSessionButtonPressed(_:)), for: .touchUpInside)
        
        mPropLabel = UILabel()
        mPropLabel.translatesAutoresizingMaskIntoConstraints = false
        mPropLabel.removeConstraints(mPropLabel.constraints)
        mPropView.addSubview(mPropLabel)
        mPropLabel.trailingAnchor.constraint(equalTo: mPropView.trailingAnchor, constant: -80.0).isActive = true
        mPropLabel.leadingAnchor.constraint(equalTo: mPropView.leadingAnchor, constant: 25.0).isActive = true
        mPropLabel.topAnchor.constraint(equalTo: mPropView.topAnchor, constant: 25.0).isActive = true
        mPropLabel.bottomAnchor.constraint(equalTo: mPropView.topAnchor, constant: 56.0).isActive = true
        mPropLabel.text = "Propose Tutoring Session"
        mPropLabel.font = UIFont(name: "HelveticaNeue", size: 22.0)
        mPropLabel.textColor = UIColor.white
        
        mPropDate = UIDatePicker()
        mPropDate.translatesAutoresizingMaskIntoConstraints = false
        mPropDate.removeConstraints(mPropDate.constraints)
        mPropView.addSubview(mPropDate)
        mPropDate.trailingAnchor.constraint(equalTo: mPropView.trailingAnchor, constant: -25.0).isActive = true
        mPropDate.leadingAnchor.constraint(equalTo: mPropView.leadingAnchor, constant: 25.0).isActive = true
        mPropDate.topAnchor.constraint(equalTo: mPropView.topAnchor, constant: 80.0).isActive = true
        mPropDate.bottomAnchor.constraint(equalTo: mPropView.topAnchor, constant: 280.0).isActive = true
        mPropDate.timeZone = TimeZone.current
        var dateComponents = Calendar.current.dateComponents([.day, .month, .year, .hour, .minute, .second],
        from: Date())
        dateComponents.minute = dateComponents.minute! + 5
        mPropDate.minimumDate = Calendar.current.date(from: dateComponents)
        
        mPropTextField = UITextField()
        mPropTextField.translatesAutoresizingMaskIntoConstraints = false
        mPropTextField.removeConstraints(mPropTextField.constraints)
        mPropView.addSubview(mPropTextField)
        mPropTextField.text = "subject"
        mPropTextField.font = UIFont(name: "HelveticaNeue", size: 20.0)
        mPropTextField.textColor = UIColor(displayP3Red: 1.0, green: 1.0, blue: 1.0, alpha: 0.5)
        mPropTextField.delegate = self
        mPropTextField.leadingAnchor.constraint(equalTo: mPropView.leadingAnchor, constant: 30.0).isActive = true
        mPropTextField.trailingAnchor.constraint(equalTo: mPropView.trailingAnchor, constant: -30.0).isActive = true
        mPropTextField.topAnchor.constraint(equalTo: mPropView.topAnchor, constant: 300.0).isActive = true
        mPropTextField.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
        mPropTextField.backgroundColor = UIColor(displayP3Red: 0.3, green: 0.3, blue: 0.55, alpha: 1.0)
        mPropTextField.setLeftPaddingPoints(10.0)
        mPropTextField.setRightPaddingPoints(10.0)
        
        mPropButton = UIButton()
        mPropButton.translatesAutoresizingMaskIntoConstraints = false
        mPropButton.removeConstraints(mPropButton.constraints)
        mPropView.addSubview(mPropButton)
        mPropButton.trailingAnchor.constraint(equalTo: mPropView.trailingAnchor, constant: -widd / 4.0).isActive = true
        mPropButton.leadingAnchor.constraint(equalTo: mPropView.leadingAnchor, constant: widd / 4.0).isActive = true
        mPropButton.topAnchor.constraint(equalTo: mPropView.topAnchor, constant: 370.0).isActive = true
        mPropButton.heightAnchor.constraint(equalToConstant: widd * 0.15).isActive = true
        mPropButton.setTitle("Send Proposal", for: .normal)
        mPropButton.backgroundColor = UIColor.white
        mPropButton.setTitleColor(UIColor.systemIndigo, for: .normal)
        mPropButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: widd * 0.05)
        mPropButton.tintColor = UIColor.white
        mPropButton.layer.cornerRadius = widd * 0.02
        mPropButton.addTarget(self, action: #selector(sendProposal(_:)), for: .touchUpInside)
        
        self.view.layoutIfNeeded()
    }
    
    @objc func closeMessageView(_ sender: UIButton!)
    {
        if(isMe)
        {
            NotificationCenter.default.post(name: Notification.Name("toggleMenuOpacity"), object: nil)
            
            connTitleRef.alpha = 0.0
            
            db.removeAllObservers()
            
            if(optionsToggle)
            {
                toggleOptionsPopup()
            }
            
            loadConnections()
            
            self.view.layoutIfNeeded()
            
            UIView.animate(withDuration: 0.2, animations: {
                
                self.svLC[2].isActive = false
                self.svLC[3].isActive = false
                
                self.svLC[0].isActive = true
                self.svLC[1].isActive = true
                
                self.mvLC[2].isActive = false
                self.mvLC[3].isActive = false
                
                self.mvLC[0].isActive = true
                self.mvLC[1].isActive = true
                
                self.connTitleRef.alpha = 1.0
                
                self.view.layoutIfNeeded()
                
            }) { _ in
                
                sender.backgroundColor = UIColor.clear
                self.view.layoutIfNeeded()
                
            }
        }
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
            if(!mPropToggle)
            {
                if(optionsToggle)
                {
                    toggleOptionsPopup()
                }
            }
        }
    }
    
    @objc func sendProposal(_ sender: UIButton!)
    {
        let proposalSubject: String! = mPropTextField.text!
        
        let dateTemp = mPropDate.date.convertToTimeZone(initTimeZone: TimeZone(abbreviation: "GMT")!, timeZone: TimeZone(abbreviation: "PDT")!)
        let dateAsString: String = "\(dateTemp)"
        let components = Calendar.current.dateComponents([.day, .month, .year, .hour, .minute],
                                                         from: mPropDate.date)
        
        let proposalDate: String = "\(dateAsString.prefix(10))"
        
        let hr = components.hour!
        var mn = "\(components.minute!)"
        if(mn.count == 1)
        {
            mn = "0\(mn)"
        }
        
        let proposalTime: String = "\(hr):\(mn):00"
        
        let DATE = Date()
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(abbreviation: "PDT")!
        let hour = calendar.component(.hour, from: DATE)
        let minutes = calendar.component(.minute, from: DATE)
        let seconds = calendar.component(.second, from: DATE)
        let stringDate = "\(DATE)"
        let messRef = self.db.child("connections/\(self.idInfo!)/message_list/").childByAutoId()
        let proposalDateTimeSubject: String = "\(proposalDate)|\(proposalTime)|\(proposalSubject!)|\(messRef.key!)|pending|\(username)"
        self.MSVIDList.append(messRef.key!)
        messRef.updateChildValues(["username":"\(username)", "message":"/t\(proposalDateTimeSubject)", "timestamp/date":"\(stringDate.prefix(10))", "timestamp/time":"\(hour):\(minutes):\(seconds)"])
        
        createTextView(text: "\(proposalDateTimeSubject)", atindex: -1, userself: true, isImage: false, imagee: UIImage(), isProposal: true)
        
        self.view.endEditing(true)
        closePropSession()
        toggleOptionsPopup()
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        if(isMe && currScene == "Connections")
        {
            self.view.layoutIfNeeded()
            
            if(textField.text == "subject")
            {
                textField.text = ""
                textField.textColor = UIColor(displayP3Red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                self.view.layoutIfNeeded()
            }
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        if(isMe && currScene == "Connections")
        {
            self.view.layoutIfNeeded()
            if(textField.text == "")
            {
                textField.text = "subject"
                textField.textColor = UIColor(displayP3Red: 1.0, green: 1.0, blue: 1.0, alpha: 0.5)
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc func bringUpOptions(_ sender: UIButton!)
    {
        if(!togglingOptions)
        {
            
            self.view.endEditing(true)
            toggleOptionsPopup()
        }
    }
    
    func toggleOptionsPopup()
    {
        togglingOptions = true
        optionsToggle = !optionsToggle
        
        self.view.layoutIfNeeded()
        
        UIView.animate(withDuration: 0.15, animations: {
            
            if(self.optionsToggle)
            {
                
                self.movLC[0].isActive = false
                self.movLC[1].isActive = false
                self.movLC[2].isActive = false
                self.movLC[3].isActive = false
                
                self.movLC[4].isActive = true
                self.movLC[5].isActive = true
                self.movLC[6].isActive = true
                self.movLC[7].isActive = true
                
                self.mOptionsView.alpha = 1.0
                
                self.mShadeView.alpha = 0.5
                
            } else
            {
                
                self.movLC[4].isActive = false
                self.movLC[5].isActive = false
                self.movLC[6].isActive = false
                self.movLC[7].isActive = false
                
                self.movLC[0].isActive = true
                self.movLC[1].isActive = true
                self.movLC[2].isActive = true
                self.movLC[3].isActive = true
                
                self.mOptionsView.alpha = 0.0
                
                self.mShadeView.alpha = 0.0
                
            }
            
            self.view.layoutIfNeeded()
            
        }) { _ in
            self.togglingOptions = false
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func closeMessages(notification: NSNotification)
    {
        /*if(isMe && currScene == "Connections")
        {
            NotificationCenter.default.post(name: Notification.Name("toggleMenuOpacity"), object: nil)
            connTitleRef.alpha = 0.0
            db.removeAllObservers()
            if(optionsToggle)
            {
                toggleOptionsPopup()
            }
            loadConnections()
            self.svLC[2].isActive = false
            self.svLC[3].isActive = false
            self.svLC[0].isActive = true
            self.svLC[1].isActive = true
            self.mvLC[2].isActive = false
            self.mvLC[3].isActive = false
            self.mvLC[0].isActive = true
            self.mvLC[1].isActive = true
            self.connTitleRef.alpha = 1.0
            self.view.layoutIfNeeded()
            
        }*/
    }
    
    @objc func proposeSessionPressed(_ sender: UIButton!)
    {
        mPropView.alpha = 1.0 - mPropView.alpha
        
        mPropToggle = true
        
        var dateComponents = Calendar.current.dateComponents([.day, .month, .year, .hour, .minute, .second],
        from: Date())
        dateComponents.minute = dateComponents.minute! + 5
        mPropDate.minimumDate = Calendar.current.date(from: dateComponents)
        
        UIView.animate(withDuration: 0.35, animations: {
            
            self.mpvLC[2].isActive = false
            self.mpvLC[3].isActive = false
            
            self.mpvLC[0].isActive = true
            self.mpvLC[1].isActive = true
            
            self.mPropView.alpha = 1.0
            
            self.view.layoutIfNeeded()
            
        }) { _ in
            self.view.layoutIfNeeded()
        }
    }
    
    func closePropSession()
    {
        UIView.animate(withDuration: 0.35, animations: {
            
            self.mpvLC[0].isActive = false
            self.mpvLC[1].isActive = false
            
            self.mpvLC[2].isActive = true
            self.mpvLC[3].isActive = true
            
            self.view.layoutIfNeeded()
            
        }) { _ in
            self.mPropView.alpha = 1.0 - self.mPropView.alpha
            self.mPropTextField.text = "subject"
            self.view.layoutIfNeeded()
            self.mPropToggle = false
        }
    }
    
    @objc func closePropSessionButtonPressed(_ sender: UIButton!)
    {
        closePropSession()
    }
    
    @objc func uploadPicPressed(_ sender: UIButton!)
    {
        if(isMe && currScene == "Connections")
        {
            let picker = UIImagePickerController()
            
            picker.allowsEditing = false
            
            picker.delegate = self
            
            present(picker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        if(isMe && currScene == "Connections")
        {
        
            if let originalImage = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerOriginalImage")]
            {
                
                let newImage = originalImage as? UIImage
                
                passedAutoID = db.child("connections/\(idInfo!)/message_list").childByAutoId().key!
                
                toggleOptionsPopup()
                
                guard let imageData = newImage!.jpegData(compressionQuality: 1.0) else { return }
                let uploadMetadata = StorageMetadata.init()
                uploadMetadata.contentType = "image/jpeg"
                let uploadRef = self.st.child("messages/\(idInfo!)/\(passedAutoID).jpg").putData(imageData, metadata: uploadMetadata) { (downloadMetadata, error) in
                    if let _ = error
                    {
                        print("failureupload")
                        return
                    }
                    
                    // send image text
                    
                    self.mTextView.resignFirstResponder()
                    
                    self.createTextView(text: "\(self.passedAutoID)", atindex: -1, userself: true, isImage: true, imagee: newImage, isProposal: false)
                    
                    let date = Date()
                    var calendar = Calendar.current
                    calendar.timeZone = TimeZone(abbreviation: "PDT")!
                    let hour = calendar.component(.hour, from: date)
                    let minutes = calendar.component(.minute, from: date)
                    let seconds = calendar.component(.second, from: date)
                    let stringDate = "\(date)"
                    let messRef = self.db.child("connections/\(self.idInfo!)/message_list/\(self.passedAutoID)")
                    self.MSVIDList.append(messRef.key!)
                    messRef.updateChildValues(["username":"\(username)", "message":"/i\(self.passedAutoID)", "timestamp/date":"\(stringDate.prefix(10))", "timestamp/time":"\(hour):\(minutes):\(seconds)"])
                    
                    self.view.layoutIfNeeded()
                    
                }
                let progressBar = UIProgressView()
                progressBar.translatesAutoresizingMaskIntoConstraints = false
                progressBar.removeConstraints(progressBar.constraints)
                mView.addSubview(progressBar)
                progressBar.leadingAnchor.constraint(equalTo: mView.leadingAnchor).isActive = true
                progressBar.trailingAnchor.constraint(equalTo: mView.trailingAnchor).isActive = true
                progressBar.topAnchor.constraint(equalTo: mView.topAnchor, constant: 80.0).isActive = true
                progressBar.alpha = 1.0
                uploadRef.observe(.progress) { snapshot in
                    progressBar.progress = Float(snapshot.progress!.fractionCompleted)
                }
                uploadRef.observe(.success) { snapshot in
                    UIView.animate(withDuration: 0.2) {
                        progressBar.alpha = 0.0
                    }
                }
                
            } else
            {
                
                
                print("error uploading image")
                // error notification popup
                
                
                
            }
            dismiss(animated: true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        if(isMe && currScene == "Connections")
        {
            dismiss(animated: true, completion: nil)
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
        loadCircle.removeConstraints(loadCircle.constraints)
        loadCircle.isHidden = false
        self.view.addSubview(loadCircle)
        loadCircle.backgroundColor = UIColor.clear
        loadCircle.layer.insertSublayer(shapeLayer, at: 0)
        loadCircle.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        lcLC = []
        lcLC.append(loadCircle.centerXAnchor.constraint(equalTo: mView.leadingAnchor, constant: -UIScreen.main.bounds.width / 2.0))
        lcLC[0].isActive = true
        lcLC.append(loadCircle.centerXAnchor.constraint(equalTo: mView.leadingAnchor, constant: UIScreen.main.bounds.width / 2.0))
        lcLC[1].isActive = false
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
                if(!mPropToggle)
                {
                    self.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - keyboardSize.height)
                    self.view.bounds = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - keyboardSize.height)
                } else
                {
                    self.view.frame.origin.y = -keyboardSize.height * 0.3
                }
                self.view.layoutIfNeeded()
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification)
    {
        self.view.layoutIfNeeded()
        if(currScene == "Connections" && isMe)
        {
            if(!mPropToggle)
            {
                self.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                self.view.bounds = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            } else
            {
                self.view.frame.origin.y = 0
            }
            self.view.layoutIfNeeded()
        }
        
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool
    {
        if(text == "\n" && textView.text! != "" && isMe)
        {
            textView.resignFirstResponder()
            
            createTextView(text: "\(textView.text!.prefix(500))", atindex: -1, userself: true, isImage: false, imagee: UIImage(), isProposal: false)
            
            let date = Date()
            var calendar = Calendar.current
            calendar.timeZone = TimeZone(abbreviation: "PDT")!
            let hour = calendar.component(.hour, from: date)
            let minutes = calendar.component(.minute, from: date)
            let seconds = calendar.component(.second, from: date)
            let stringDate = "\(date)"
            let messRef = db.child("connections/\(idInfo!)/message_list").childByAutoId()
            MSVIDList.append(messRef.key!)
            messRef.updateChildValues(["username":"\(username)", "message":"/m\(textView.text!.prefix(500))", "timestamp/date":"\(stringDate.prefix(10))", "timestamp/time":"\(hour):\(minutes):\(seconds)"])
            
            self.view.layoutIfNeeded()
            
            clearText()
            return false
        }
        return true
    }
    
    func refreshChat()
    {
        let observeR = db.child("connections/\(idInfo!)/message_list").observe(.childAdded, with: { snapshotT in
            
            if let value = snapshotT.value
            {
                let diction = value as! [String: Any]
                let messageVAR = diction["message"] as? String
                let userVAR = diction["username"] as? String
                if(!self.MSVIDList.contains(snapshotT.key))
                {
                    self.MSVIDList.append(snapshotT.key)
                    let arrrr = Array(messageVAR!)
                    if("\(arrrr[0])\(arrrr[1])" == "/m")
                    {
                        let MESS = "\(messageVAR!.dropFirst(2))"
                        self.createTextView(text: MESS, atindex: -1, userself: (userVAR! == username), isImage: false, imagee: UIImage(), isProposal: false)
                    } else if("\(arrrr[0])\(arrrr[1])" == "/i")
                    {
                        let MESS = "\(messageVAR!.dropFirst(2))"
                        self.createTextView(text: MESS, atindex: -1, userself: (userVAR! == username), isImage: true, imagee: UIImage(named: "loadImage"), isProposal: false)
                    
                    } else if("\(arrrr[0])\(arrrr[1])" == "/t")
                    {
                        let MESS = "\(messageVAR!.dropFirst(2))"
                        self.createTextView(text: MESS, atindex: -1, userself: (userVAR! == username), isImage: false, imagee: UIImage(named: "loadImage"), isProposal: true)
                   
                    }
                    
                    // add option for time proposals
                }
                self.db.child("connections/\(self.idInfo!)/message_list/\(snapshotT.key)/timestamp").observeSingleEvent(of: .value) { timesnap in
                    if let vall = timesnap.value
                    {
                        let diction2 = vall as! [String: Any]
                        let dateVAR = diction2["date"] as? String
                        let timeVAR = diction2["time"] as? String
                        self.db.child("connections/\(self.idInfo!)/last_message_time").updateChildValues(["date":"\(dateVAR!)", "time":"\(timeVAR!)"])
                    }
                }
            }
        })
    }
    
    func createTextView(text: String, atindex: Int, userself: Bool, isImage: Bool, imagee: UIImage!, isProposal: Bool)
    {
        
        if(!isMe || connTitleRef.alpha != 0.0)
        {
            return
        }
        
        let postOverallView = UIView()
        let postView = UIView()
        let postLabel = UILabel()
        let postImage = UIButton()
        let postTopLabel = UILabel()
        let postBottomLabel = UILabel()
        var tempDATE: [String.SubSequence] = []
        var tempTIME: [String.SubSequence] = []
        var tempID: String = ""
        var tempGOING: String = ""
        var tempSENDER: String = ""
        var tempSUBJECT: String = ""
        var subHeight = UIScreen.main.bounds.height * 0.0
        let monthsOfYear: [String]! = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
        let yesButton = UIButton()
        let noButton = UIButton()
        let yesImage = UIImageView()
        let noImage = UIImageView()
        let neutralButton = UIButton()
        
        let screenWidth = UIScreen.main.bounds.width
        var viewWidth = screenWidth * 0.7
        var viewHeight = text.heightWithConstrainedWidth(width: viewWidth, font: UIFont(name: "HelveticaNeue", size: 20.0)!) + 17.0
        if(viewHeight < 60.0)
        {
            viewWidth = text.WidthCalc(font: UIFont(name: "HelveticaNeue", size: 20.0)!) + 1
        }
        
        if(isImage)
        {
            postImage.isHidden = false
            let heioverwid = imagee.size.height / imagee.size.width
            viewWidth = screenWidth * 0.6
            viewHeight = viewWidth * heioverwid + 30
        } else
        {
            
            postImage.isHidden = true
            if(isProposal)
            {
                let separateParts = text.split(separator: "|")
                let oNE = "\(separateParts[0])"
                let tWO = "\(separateParts[1])"
                tempDATE = oNE.split(separator: "-")
                tempTIME = tWO.split(separator: ":")
                tempSUBJECT = "\(separateParts[2])"
                tempID = "\(separateParts[3])"
                tempGOING = "\(separateParts[4])"
                tempSENDER = "\(separateParts[5])"
                viewWidth = screenWidth * 0.7
                var pTS: String = "Proposed Tutoring Session"
                subHeight = tempSUBJECT.heightWithConstrainedWidth(width: viewWidth, font: UIFont(name: "HelveticaNeue", size: 25.0)!) + 1.0
                viewHeight = 15.0 + 18.0 + 5.0 + subHeight + 5.0 + 25.0 + 50.0 + 10.0
            }
        }
        
        postOverallView.translatesAutoresizingMaskIntoConstraints = false
        postOverallView.removeConstraints(postOverallView.constraints)
        let originalHeightAnchor = postOverallView.heightAnchor.constraint(equalToConstant: viewHeight + 10.0)
        originalHeightAnchor.isActive = true
        postOverallView.widthAnchor.constraint(equalToConstant: screenWidth).isActive = true
        postOverallView.backgroundColor = UIColor.clear
        if(atindex == -1)
        {
            mStackView.addArrangedSubview(postOverallView)
        } else
        {
            mStackView.insertArrangedSubview(postOverallView, at: atindex)
        }
        
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
        
        if(!isImage)
        {
            if(!isProposal)
            {
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
            } else
            {
                // insert content for proposal here
                
                postTopLabel.translatesAutoresizingMaskIntoConstraints = false
                postTopLabel.removeConstraints(postLabel.constraints)
                postView.addSubview(postTopLabel)
                postTopLabel.trailingAnchor.constraint(equalTo: postView.trailingAnchor, constant: -20.0).isActive = true
                postTopLabel.leadingAnchor.constraint(equalTo: postView.leadingAnchor, constant: 20.0).isActive = true
                postTopLabel.topAnchor.constraint(equalTo: postView.topAnchor, constant: 15.0).isActive = true
                postTopLabel.bottomAnchor.constraint(equalTo: postView.topAnchor, constant: 33.0).isActive = true
                postTopLabel.text = "Proposed Tutoring Session:"
                postTopLabel.font = UIFont(name: "HelveticaNeue", size: 17.0)
                postTopLabel.textColor = UIColor.white
                postTopLabel.lineBreakMode = .byWordWrapping
                postTopLabel.numberOfLines = 0
                postTopLabel.textAlignment = .left
                
                postLabel.translatesAutoresizingMaskIntoConstraints = false
                postLabel.removeConstraints(postLabel.constraints)
                postView.addSubview(postLabel)
                postLabel.trailingAnchor.constraint(equalTo: postView.trailingAnchor, constant: -20.0).isActive = true
                postLabel.leadingAnchor.constraint(equalTo: postView.leadingAnchor, constant: 20.0).isActive = true
                postLabel.topAnchor.constraint(equalTo: postView.topAnchor, constant: 38.0).isActive = true
                postLabel.bottomAnchor.constraint(equalTo: postView.topAnchor, constant: 39.0 + subHeight).isActive = true
                postLabel.text = tempSUBJECT
                postLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 25.0)
                postLabel.textColor = UIColor.white
                postLabel.lineBreakMode = .byWordWrapping
                postLabel.numberOfLines = 0
                postLabel.textAlignment = .left
                
                var timeMOD: String = "AM"
                if(Int("\(tempTIME[0])")! > 11 && Int("\(tempTIME[0])")! < 24)
                {
                    timeMOD = "PM"
                }
                
                postBottomLabel.translatesAutoresizingMaskIntoConstraints = false
                postBottomLabel.removeConstraints(postBottomLabel.constraints)
                postView.addSubview(postBottomLabel)
                postBottomLabel.trailingAnchor.constraint(equalTo: postView.trailingAnchor, constant: -20.0).isActive = true
                postBottomLabel.leadingAnchor.constraint(equalTo: postView.leadingAnchor, constant: 20.0).isActive = true
                postBottomLabel.topAnchor.constraint(equalTo: postView.topAnchor, constant: 43 + subHeight).isActive = true
                postBottomLabel.bottomAnchor.constraint(equalTo: postView.topAnchor, constant: 68.0 + subHeight).isActive = true
                postBottomLabel.text = "\(monthsOfYear[Int("\(tempDATE[1])")! - 1]) \(tempDATE[2]), \(tempDATE[0]) at \((Int("\(tempTIME[0])")!) % 12):\(tempTIME[1]) \(timeMOD)"
                postBottomLabel.font = UIFont(name: "HelveticaNeue", size: 20.0)
                postBottomLabel.textColor = UIColor.white
                postBottomLabel.lineBreakMode = .byWordWrapping
                postBottomLabel.numberOfLines = 0
                postBottomLabel.textAlignment = .left
                
                if(tempSENDER == username || tempGOING == "accepted" || tempGOING == "denied")
                {
                    
                    neutralButton.translatesAutoresizingMaskIntoConstraints = false
                    neutralButton.removeConstraints(neutralButton.constraints)
                    postView.addSubview(neutralButton)
                    neutralButton.trailingAnchor.constraint(equalTo: postView.trailingAnchor, constant: -20.0).isActive = true
                    neutralButton.leadingAnchor.constraint(equalTo: postView.leadingAnchor, constant: 20.0).isActive = true
                    neutralButton.topAnchor.constraint(equalTo: postView.topAnchor, constant: 79.0 + subHeight).isActive = true
                    neutralButton.bottomAnchor.constraint(equalTo: postView.bottomAnchor, constant: -15.0).isActive = true
                    neutralButton.setTitleColor(UIColor.clear, for: .normal)
                    neutralButton.layer.cornerRadius = 10.0
                    neutralButton.tintColor = UIColor.white
                    neutralButton.titleLabel?.font = UIFont(name: "HelveticaNeue", size: 20.0)
                    neutralButton.setTitleColor(UIColor(displayP3Red: 1.0, green: 1.0, blue: 1.0, alpha: 0.8), for: .normal)
                    
                    if(tempGOING == "accepted")
                    {
                        neutralButton.backgroundColor = UIColor(displayP3Red: 0.6, green: 0.75, blue: 0.6, alpha: 1.0)
                        neutralButton.setTitle("accepted", for: .normal)
                    } else if(tempGOING == "denied")
                    {
                        neutralButton.backgroundColor = UIColor(displayP3Red: 0.75, green: 0.6, blue: 0.6, alpha: 1.0)
                        neutralButton.setTitle("denied", for: .normal)
                    } else
                    {
                        neutralButton.backgroundColor = UIColor(displayP3Red: 0.7, green: 0.7, blue: 0.7, alpha: 1.0)
                        neutralButton.setTitle("pending", for: .normal)
                    }
                } else
                {
                    yesButton.translatesAutoresizingMaskIntoConstraints = false
                    yesButton.removeConstraints(yesButton.constraints)
                    postView.addSubview(yesButton)
                    yesButton.trailingAnchor.constraint(equalTo: postView.centerXAnchor, constant: -5.0).isActive = true
                    yesButton.trailingAnchor.constraint(equalTo: postView.trailingAnchor, constant: -20.0).isActive = false
                    yesButton.leadingAnchor.constraint(equalTo: postView.leadingAnchor, constant: 20.0).isActive = true
                    yesButton.topAnchor.constraint(equalTo: postView.topAnchor, constant: 79.0 + subHeight).isActive = true
                    yesButton.bottomAnchor.constraint(equalTo: postView.bottomAnchor, constant: -15.0).isActive = true
                    yesButton.backgroundColor = UIColor(displayP3Red: 0.1, green: 0.8, blue: 0.2, alpha: 1.0)
                    yesButton.setTitle("\(tempID)", for: .normal)
                    yesButton.setTitleColor(UIColor.clear, for: .normal)
                    yesButton.layer.cornerRadius = 10.0
                    yesButton.tintColor = UIColor.white
                    yesButton.addTarget(self, action: #selector(yesToProposalPressed(_:)), for: .touchUpInside)
                    
                    noButton.translatesAutoresizingMaskIntoConstraints = false
                    noButton.removeConstraints(noButton.constraints)
                    postView.addSubview(noButton)
                    noButton.trailingAnchor.constraint(equalTo: postView.trailingAnchor, constant: -20.0).isActive = true
                    noButton.leadingAnchor.constraint(equalTo: postView.centerXAnchor, constant: 5.0).isActive = true
                    noButton.topAnchor.constraint(equalTo: postView.topAnchor, constant: 79.0 + subHeight).isActive = true
                    noButton.bottomAnchor.constraint(equalTo: postView.bottomAnchor, constant: -15.0).isActive = true
                    noButton.backgroundColor = UIColor(displayP3Red: 0.8, green: 0.1, blue: 0.2, alpha: 1.0)
                    noButton.setTitle("\(tempID)", for: .normal)
                    noButton.setTitleColor(UIColor.clear, for: .normal)
                    noButton.layer.cornerRadius = 10.0
                    noButton.tintColor = UIColor.white
                    noButton.addTarget(self, action: #selector(noToProposalPressed(_:)), for: .touchUpInside)
                    
                    yesImage.translatesAutoresizingMaskIntoConstraints = false
                    yesImage.removeConstraints(yesImage.constraints)
                    postView.addSubview(yesImage)
                    yesImage.centerXAnchor.constraint(equalTo: yesButton.centerXAnchor).isActive = true
                    yesImage.centerYAnchor.constraint(equalTo: yesButton.centerYAnchor).isActive = true
                    yesImage.widthAnchor.constraint(equalToConstant: 30.0).isActive = true
                    yesImage.heightAnchor.constraint(equalToConstant: 25.0).isActive = true
                    yesImage.image = UIImage(systemName: "checkmark")!
                    yesImage.tintColor = UIColor.white
                    postView.bringSubviewToFront(yesImage)
                    
                    noImage.translatesAutoresizingMaskIntoConstraints = false
                    noImage.removeConstraints(noImage.constraints)
                    postView.addSubview(noImage)
                    noImage.centerXAnchor.constraint(equalTo: noButton.centerXAnchor).isActive = true
                    noImage.centerYAnchor.constraint(equalTo: noButton.centerYAnchor).isActive = true
                    noImage.widthAnchor.constraint(equalToConstant: 23.0).isActive = true
                    noImage.heightAnchor.constraint(equalToConstant: 25.0).isActive = true
                    noImage.image = UIImage(systemName: "multiply")!
                    noImage.tintColor = UIColor.white
                    postView.bringSubviewToFront(noImage)
                }
            }
        } else
        {
            postImage.translatesAutoresizingMaskIntoConstraints = false
            postImage.removeConstraints(postImage.constraints)
            postView.addSubview(postImage)
            postImage.trailingAnchor.constraint(equalTo: postView.trailingAnchor, constant: -20.0).isActive = true
            postImage.leadingAnchor.constraint(equalTo: postView.leadingAnchor, constant: 20.0).isActive = true
            postImage.topAnchor.constraint(equalTo: postView.topAnchor, constant: 20.0).isActive = true
            postImage.bottomAnchor.constraint(equalTo: postView.bottomAnchor, constant: -20.0).isActive = true
            postImage.setBackgroundImage(UIImage(named: "loadImage"), for: .normal)
            postImage.setTitle("", for: .normal)
            st.child("messages/\(idInfo!)/\(text).jpg").getData(maxSize: 25 * 1024 * 1024, completion: { (data, error) in
                if error != nil
                {
                    print("error loading image \(error!)")
                }
                if let data = data
                {
                    postImage.setBackgroundImage(UIImage(data: data), for: .normal)
                    let heioverwidratio = UIImage(data: data)!.size.height / UIImage(data: data)!.size.width
                    viewWidth = screenWidth * 0.6
                    viewHeight = viewWidth * heioverwidratio
                    originalHeightAnchor.isActive = false
                    postOverallView.heightAnchor.constraint(equalToConstant: viewHeight + 40.0).isActive = true
                }
            })
        }
        
        lastHeight = viewHeight + 10
        
        mScrollView.contentSize = mStackView.frame.size
        
    }
    
    @objc func yesToProposalPressed(_ sender: UIButton!)
    {
        // take ID info (in button name) and change it in firebase to yes
        
        let givenID: String = (sender.titleLabel?.text)!
        
        db.child("connections/\(idInfo!)/message_list/\(givenID)").observeSingleEvent(of: .value) { snap in
            if let value = snap.value
            {
                let dictionary = value as! [String: Any]
                let originalData = dictionary["message"] as? String
                let sepParts = originalData!.split(separator: "|")
                let newData: String = "\(sepParts[0])|\(sepParts[1])|\(sepParts[2])|\(sepParts[3])|accepted|\(sepParts[5])"
                self.db.child("connections/\(self.idInfo!)/message_list/\(givenID)/message").setValue(newData)
                
                let newChild = self.db.child("users/\(userEmail!)/sessions").childByAutoId()
                newChild.setValue(newData)
                
                self.db.child("usernames/\(sepParts[5])").observeSingleEvent(of: .value) { nameSnap in
                    if let theval = nameSnap.value as? String
                    {
                        let newChild2 = self.db.child("users/\(theval)/sessions").childByAutoId()
                        newChild2.setValue(newData)
                    }
                }
                
                let newCoverView = UIView()
                let lcList = [NSLayoutConstraint]! = []
                newCoverView.layer.cornerRadius = 10.0
                newCoverView.translatesAutoresizingMaskIntoConstraints = false
                newCoverView.removeConstraints(newCoverView.constraints)
                lcList.append(newCoverView.leadingAnchor.constraint(equalTo: sender.leadingAnchor, constant: 0.0))
                lcList[0].isActive = true
                lcList.append(newCoverView.trailingAnchor.constraint(equalTo: sender.trailingAnchor, constant: 0.0))
                lcList[1].isActive = true
                lcList.append(newCoverView.trailingAnchor.constraint(equalTo: sender.trailingAnchor, constant: UIScreen.main.bounds.width * 0.35 - 15.0))
                lcList[2].isActive = true
                newCoverView.topAnchor.constraint(equalTo: sender.topAnchor, constant: 0.0).isActive = true
                newCoverView.bottomAnchor.constraint(equalTo: sender.bottomAnchor, constant: 0.0).isActive = true
                newCoverView.backgroundColor = sender.backgroundColor
                
                UIView.animate(withDuration: 0.3, animations: {
                    
                    lcList[1].isActive = false
                    lcList[2].isActive = true
                    
                    newCoverView.backgroundColor = UIColor(displayP3Red: 0.6, green: 0.75, blue: 0.6, alpha: 1.0)
                    
                    sender.alpha = 0.0
                    self.view.layoutIfNeeded()
                    
                }) { _ in
                    
                }
            }
        }
        
    }
    
    @objc func noToProposalPressed(_ sender: UIButton!)
    {
        // change status to denied
        
        let givenID: String = (sender.titleLabel?.text)!
        
        db.child("connections/\(idInfo!)/message_list/\(givenID)").observeSingleEvent(of: .value) { snap in
            if let value = snap.value
            {
                let dictionary = value as! [String: Any]
                let originalData = dictionary["message"] as? String
                let sepParts = originalData!.split(separator: "|")
                let newData: String = "\(sepParts[0])|\(sepParts[1])|\(sepParts[2])|\(sepParts[3])|denied|\(sepParts[5])"
                self.db.child("connections/\(self.idInfo!)/message_list/\(givenID)/message").setValue(newData)
                
            }
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView)
    {
        if(isMe)
        {
            self.view.layoutIfNeeded()
            if(togglingOptions)
            {
                toggleOptionsPopup()
            }
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
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool
    {
        let isControllTapped = touch.view is UIControl
        return !isControllTapped
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

extension UIScrollView
{
    func scrollToBottom(lastHeight: CGFloat)
    {
        let bottomOffset = CGPoint(x: 0, y: lastHeight + 10 + contentSize.height - bounds.size.height)
        setContentOffset(bottomOffset, animated: true)
        layoutIfNeeded()
    }
}

extension UITextField
{
    func setLeftPaddingPoints(_ amount:CGFloat)
    {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat)
    {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}

extension Date
{
    func convertToTimeZone(initTimeZone: TimeZone, timeZone: TimeZone) -> Date
    {
         let delta = TimeInterval(timeZone.secondsFromGMT(for: self) - initTimeZone.secondsFromGMT(for: self))
         return addingTimeInterval(delta)
    }
}
