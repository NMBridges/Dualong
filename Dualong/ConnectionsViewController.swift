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
    var phoneList: [String]! = []
    
    var nameInfo: String! = ""
    var usernameInfo: String! = ""
    var emailInfo: String! = ""
    var profpicInfo: UIImage! = UIImage()
    var idInfo: String! = ""
    var phoneInfo: String! = ""
    
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
    var mCallButton: UIButton! = UIButton()
    
    var passedAutoID: String = ""
    
    var MSVUserList: [String]! = []
    var MSVMessageList: [String]! = []
    var MSVTimeList: [String]! = []
    var MSVDateList: [String]! = []
    var MSVIDList: [String]! = []
    
    var lastHeight: CGFloat = 0
    
    var wbView: UIView = UIView()
    var wbLC: [NSLayoutConstraint]! = []
    var wbSV: UIScrollView = UIScrollView()
    var wbUP: Bool = false
    var wbBackgroundView: UIView = UIView()
    var wbImageView: UIImageView! = UIImageView()
    var wbImageLoaded: Bool = false
    var wbModeView: UIView = UIView()
    var wbmLC: [NSLayoutConstraint]! = []
    var wbMode: String = ""
    var wbLastMode: String = ""
    var wbImageWid: CGFloat = 0.0
    var wbImageHei: CGFloat = 0.0
    var wbWidToImage: CGFloat = 0.0
    var wbHeiToImage: CGFloat = 0.0
    var imageDrawingOn: String = ""
    var wbImageRadians: CGFloat = 0.0
    var buttonBarList: [UIButton]! = []
    var wbCoverView: UIView = UIView()
    var wbEditSizeBut: UIButton! = UIButton()
    var wbEditColorBut: UIButton! = UIButton()
    var wbEraserBut: UIButton! = UIButton()
    var wbSizeSliderView: UIView = UIView()
    var wbSizeSlider: UISlider = UISlider()
    var wbssLC: [NSLayoutConstraint] = []
    var wbColorSliderView: UIView = UIView()
    var wbColorSlider: UISlider = UISlider()
    var wbcsLC: [NSLayoutConstraint] = []
    var wbColor: CGFloat = 0.0
    var wbSize: CGFloat = 3.0
    
    var noPeople: UILabel! = UILabel()
    
    var wbMyPositions: [String]! = []  // keeps an array of the last line drawn -- need to copy to small scale variable before uploading so it doesn't get overridden
    var lineList: [CAShapeLayer] = []
    var lineIDList: [String] = []
    var currLinePath: UIBezierPath = UIBezierPath()
    var cnol: Int = 0
    var drawingLine: Bool = false

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
        }
        
    }
    
    @objc func connectionPressed(_ sender: UIButton!)
    {
        if(isMe)
        {
            if(menuToggle)
            {
                NotificationCenter.default.post(name: Notification.Name("closeMenuTab"), object: nil)
            }
            
            let num = Int(sender.title(for: .normal)!)!
            
            NotificationCenter.default.post(name: Notification.Name("toggleMenuOpacity"), object: nil)
            
            nameInfo = nameList[num]
            mNameLabel.text = nameInfo
            usernameInfo = usernameList[num]
            emailInfo = emailList[num]
            profpicInfo = profpicList[num]
            idInfo = idList[num]
            phoneInfo = phoneList[num]
            
            if(phoneInfo! != "nil" && phoneInfo! != "" && phoneInfo!.count > 6)
            {
                mCallButton.isHidden = false
            } else
            {
                mCallButton.isHidden = true
            }
            
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
        
    }
    
    override func viewDidLayoutSubviews()
    {
        wbView.frame = self.view.bounds
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
                            if(child2.key == "user")
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
            if(MSVUserList[itemOrder[q]] == userEmail!)
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
        VIEW.backgroundColor = UIColor(displayP3Red: 116.0 / 255.0, green: 114.0 / 255.0, blue: 233.0 / 255.0, alpha: 1)
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
        
        for q in 0...(itemOrder.count - 1)
        {
            addStackViewMember(cc: itemOrder[q])
        }
        
        loadCircle.isHidden = true
        
    }
    
    func loadConnections()
    {
        
        loadCircle.isHidden = false
        noPeople.isHidden = true
        
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
        phoneList = []
        
        
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
                    self.phoneList.append("")
                }
                
                if(connections.count == 0)
                {
                    self.noPeople.removeFromSuperview()
                    self.noPeople = UILabel()
                    self.noPeople.isHidden = false
                    self.noPeople.translatesAutoresizingMaskIntoConstraints = false
                    self.noPeople.removeConstraints(self.noPeople.constraints)
                    self.view.addSubview(self.noPeople)
                    self.noPeople.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
                    self.noPeople.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
                    self.noPeople.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 50.0).isActive = true
                    self.noPeople.font = UIFont(name: "HelveticaNeue", size: 25.0)
                    var textTE: String = ""
                    if(role == "Tutor or Teacher")
                    {
                        textTE = "You have no connections. Go to the explore tab to find some learners who are looking for tutors. They are filtered by your subject interests."
                    } else if(role == "Learner, Student, or Parent")
                    {
                        textTE = "You have no connections. Go to the explore tab to find a tutor. They are filtered by your subject interests."
                    }
                    let heighttA = textTE.heightWithConstrainedWidth(width: UIScreen.main.bounds.width - 50.0, font: UIFont(name: "HelveticaNeue", size: 25.0)!)
                    self.noPeople.heightAnchor.constraint(equalToConstant: heighttA).isActive = true
                    self.noPeople.textColor = UIColor.white.withAlphaComponent(0.5)
                    self.noPeople.text = textTE
                    self.noPeople.textAlignment = .center
                    self.noPeople.lineBreakMode = .byWordWrapping
                    self.noPeople.numberOfLines = 0
                    self.view.bringSubviewToFront(self.noPeople)
                    self.loadCircle.isHidden = true
                }
                
                var PP: Int = 0
                let optLeng = connections.count
                
                for (key, value) in connections
                {
                    let _ = value
                    let c = Int(PP)
                    self.emailList[c] = key
                    self.db.child("users/\(key)").observeSingleEvent(of: .value) { snap in
                        if let dict = snap.value as? [String: Any]
                        {
                            self.usernameList[c] = (dict["username"] as? String)!
                            self.nameList[c] = (dict["name"] as? String)!
                            self.roleList[c] = (dict["account_type"] as? String)!
                            self.phoneList[c] = (dict["phone_number"] as? String)!
                            
                            self.db.child("users/\(userEmail!)/connections/\(key)").observeSingleEvent(of: .value) { snap4 in
                                    if let randID = snap4.value as? String
                                    {
                                        self.idList[c] = randID
                                        self.db.child("connections/\(randID)").observeSingleEvent(of: .value) { snap5 in
                                            if let diction = snap5.value as? [String: Any]
                                            {
                                                let conn = (diction["\(userEmail!)"] as? [String: Any])!
                                                self.connStatus[c] = (conn["status"] as? String)!
                                                let timme = (diction["last_message_time"] as? [String: Any])!
                                                self.dateList[c] = (timme["date"] as? String)!
                                                self.timeList[c] = (timme["time"] as? String)!
                                                    
                                                if(c >= optLeng - 1)
                                                {
                                                    self.sortStackViews()
                                                }
                                                self.st.child("profilepics/\(self.usernameList[c]).jpg").getData(maxSize: 4 * 1024 * 1024, completion: { (data, error) in
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
        
        // call button here
        
        mCallButton = UIButton()
        mCallButton.translatesAutoresizingMaskIntoConstraints = false
        mCallButton.removeConstraints(mCallButton.constraints)
        mView.addSubview(mCallButton)
        mCallButton.leadingAnchor.constraint(equalTo: mView.trailingAnchor, constant: -60).isActive = true
        mCallButton.trailingAnchor.constraint(equalTo: mView.trailingAnchor, constant: -30).isActive = true
        mCallButton.topAnchor.constraint(equalTo: mView.topAnchor, constant: 35 + self.view.safeAreaInsets.top).isActive = true
        mCallButton.bottomAnchor.constraint(equalTo: mView.topAnchor, constant: 65 + self.view.safeAreaInsets.top).isActive = true
        mCallButton.setBackgroundImage(UIImage(systemName: "phone"), for: .normal)
        mCallButton.addTarget(self, action: #selector(startCall(_:)), for: .touchUpInside)
        mCallButton.tintColor = UIColor.white
        mCallButton.isHidden = true
        
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
    
    @objc func startCall(_ sender: UIButton!)
    {
        if(phoneInfo! != "nil" && phoneInfo! != "" && phoneInfo!.count > 6)
        {
            let url: URL = URL(string: "tel://\(phoneInfo!)")!
            UIApplication.shared.openURL(url)
        } else
        {
            let alert = UIAlertController(title: "Error", message: "This person doesn't have a phone number added to their account", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "dismiss", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
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
            
            if(wbUP)
            {
                if(wbMode == "color" || wbMode == "size")
                {
                    self.view.layoutIfNeeded()
                    
                    wbMode = wbLastMode
                    if(wbMode == "scroll")
                    {
                        wbSV.panGestureRecognizer.isEnabled = true
                        wbSV.pinchGestureRecognizer?.isEnabled = true
                        wbSV.isUserInteractionEnabled = true
                        toScrollMode(UIButton())
                    } else if(wbMode == "draw")
                    {
                        toDrawMode(UIButton())
                    } else if(wbMode == "erase")
                    {
                        toEraserMode(UIButton())
                    }
                    
                    UIView.animate(withDuration: 0.2, animations: {
                        
                        self.wbssLC[0].isActive = false
                        self.wbssLC[1].isActive = true
                        self.wbSizeSliderView.alpha = 0.0
                        
                        self.wbcsLC[0].isActive = false
                        self.wbcsLC[1].isActive = true
                        self.wbColorSliderView.alpha = 0.0
                        
                        self.view.layoutIfNeeded()
                        
                    }) { _ in
                        self.view.layoutIfNeeded()
                    }
                }
            }
        }
    }
    
    @objc func sendProposal(_ sender: UIButton!)
    {
        if(isMe)
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
            let proposalDateTimeSubject: String = "\(proposalDate)|\(proposalTime)|\(proposalSubject!)|\(messRef.key!)|pending|\(userEmail!)|\(emailInfo!)"
            self.MSVIDList.append(messRef.key!)
            messRef.updateChildValues(["user":"\(userEmail!)", "message":"/t\(proposalDateTimeSubject)", "timestamp/date":"\(stringDate.prefix(10))", "timestamp/time":"\(hour):\(minutes):\(seconds)"])
            
            createTextView(text: "\(proposalDateTimeSubject)", atindex: -1, userself: true, isImage: false, imagee: UIImage(), isProposal: true)
            
            self.view.endEditing(true)
            closePropSession()
            toggleOptionsPopup()
        }
        
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
        if(!togglingOptions && isMe)
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
        if(isMe)
        {
            AppUtility.lockOrientation(.portrait)
        }
    }
    
    @objc func proposeSessionPressed(_ sender: UIButton!)
    {
        if(isMe)
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
        if(isMe)
        {
            closePropSession()
        }
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
                    messRef.updateChildValues(["user":"\(userEmail!)", "message":"/i\(self.passedAutoID)", "timestamp/date":"\(stringDate.prefix(10))", "timestamp/time":"\(hour):\(minutes):\(seconds)"])
                    
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
            messRef.updateChildValues(["user":"\(userEmail!)", "message":"/m\(textView.text!.prefix(500))", "timestamp/date":"\(stringDate.prefix(10))", "timestamp/time":"\(hour):\(minutes):\(seconds)"])
            
            self.view.layoutIfNeeded()
            
            clearText()
            return false
        }
        return true
    }
    
    func refreshChat()
    {
        if(isMe)
        {
            _ = db.child("connections/\(idInfo!)/message_list").observe(.childAdded, with: { snapshotT in
                
                if let value = snapshotT.value
                {
                    let diction = value as! [String: Any]
                    let messageVAR = diction["message"] as? String
                    let userVAR = diction["user"] as? String
                    if(!self.MSVIDList.contains(snapshotT.key))
                    {
                        self.MSVIDList.append(snapshotT.key)
                        let arrrr = Array(messageVAR!)
                        if("\(arrrr[0])\(arrrr[1])" == "/m")
                        {
                            let MESS = "\(messageVAR!.dropFirst(2))"
                            self.createTextView(text: MESS, atindex: -1, userself: (userVAR! == userEmail!), isImage: false, imagee: UIImage(), isProposal: false)
                        } else if("\(arrrr[0])\(arrrr[1])" == "/i")
                        {
                            let MESS = "\(messageVAR!.dropFirst(2))"
                            self.createTextView(text: MESS, atindex: -1, userself: (userVAR! == userEmail!), isImage: true, imagee: UIImage(named: "loadImage"), isProposal: false)
                        
                        } else if("\(arrrr[0])\(arrrr[1])" == "/t")
                        {
                            let MESS = "\(messageVAR!.dropFirst(2))"
                            self.createTextView(text: MESS, atindex: -1, userself: (userVAR! == userEmail!), isImage: false, imagee: UIImage(named: "loadImage"), isProposal: true)
                       
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
                
                if(tempSENDER == userEmail! || tempGOING == "accepted" || tempGOING == "denied")
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
            postImage.setTitle("\(text)", for: .normal)
            postImage.setTitleColor(UIColor.clear, for: .normal)
            postImage.addTarget(self, action: #selector(imagePressed(_:)), for: .touchUpInside)
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
    
    @objc func imagePressed(_ sender: UIButton!)
    {
        
        wbView.removeFromSuperview()
        wbView = UIView()
        self.view.addSubview(wbView)
        self.view.bringSubviewToFront(wbView)
        wbView.translatesAutoresizingMaskIntoConstraints = false
        wbView.removeConstraints(wbView.constraints)
        wbLC = []
        wbLC.append(wbView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor))
        wbLC[0].isActive = false
        wbLC.append(wbView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor))
        wbLC[1].isActive = false
        wbLC.append(wbView.topAnchor.constraint(equalTo: self.view.topAnchor))
        wbLC[2].isActive = false
        wbLC.append(wbView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor))
        wbLC[3].isActive = false
        wbLC.append(wbView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor))
        wbLC[4].isActive = true
        wbLC.append(wbView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor))
        wbLC[5].isActive = true
        wbLC.append(wbView.topAnchor.constraint(equalTo: self.view.bottomAnchor))
        wbLC[6].isActive = true
        wbLC.append(wbView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 200.0))
        wbLC[7].isActive = true
        wbView.backgroundColor = UIColor(displayP3Red: 0.3, green: 0.3, blue: 0.3, alpha: 1.0)
        wbView.alpha = 0.5
        wbView.autoresizesSubviews = true
        
        let wbTopBarView: UIView = UIView()
        wbTopBarView.translatesAutoresizingMaskIntoConstraints = false
        wbTopBarView.removeConstraints(wbTopBarView.constraints)
        wbView.addSubview(wbTopBarView)
        wbTopBarView.trailingAnchor.constraint(equalTo: wbView.trailingAnchor, constant: 0.0).isActive = true
        wbTopBarView.leadingAnchor.constraint(equalTo: wbView.leadingAnchor, constant: 0.0).isActive = true
        wbTopBarView.topAnchor.constraint(equalTo: wbView.topAnchor, constant: 0.0).isActive = true
        wbTopBarView.bottomAnchor.constraint(equalTo: wbView.topAnchor, constant: self.view.safeAreaInsets.top + 50.0).isActive = true
        wbTopBarView.backgroundColor = UIColor.systemIndigo
        
        let wbCloseButton: UIButton! = UIButton()
        wbCloseButton.translatesAutoresizingMaskIntoConstraints = false
        wbCloseButton.removeConstraints(wbCloseButton.constraints)
        wbTopBarView.addSubview(wbCloseButton)
        wbCloseButton.trailingAnchor.constraint(equalTo: wbTopBarView.trailingAnchor, constant: -20.0).isActive = true
        wbCloseButton.leadingAnchor.constraint(equalTo: wbTopBarView.trailingAnchor, constant: -50.0).isActive = true
        wbCloseButton.topAnchor.constraint(equalTo: wbTopBarView.topAnchor, constant: self.view.safeAreaInsets.top + 9.0).isActive = true
        wbCloseButton.bottomAnchor.constraint(equalTo: wbTopBarView.topAnchor, constant: self.view.safeAreaInsets.top + 41.0).isActive = true
        wbCloseButton.tintColor = UIColor.white
        wbCloseButton.setBackgroundImage(UIImage(systemName: "multiply"), for: .normal)
        wbCloseButton.setTitle("", for: .normal)
        wbCloseButton.addTarget(self, action: #selector(closeImagePopup(_:)), for: .touchUpInside)
        
        wbModeView = UIView()
        wbModeView.translatesAutoresizingMaskIntoConstraints = false
        wbModeView.removeConstraints(wbModeView.constraints)
        wbTopBarView.addSubview(wbModeView)
        wbmLC = []
        wbColor = 1.0
        wbSize = 3.0
        
        buttonBarList = []
        
        let wbDrawButton: UIButton! = UIButton()
        wbDrawButton.translatesAutoresizingMaskIntoConstraints = false
        wbDrawButton.removeConstraints(wbCloseButton.constraints)
        buttonBarList.append(wbDrawButton)
        wbTopBarView.addSubview(buttonBarList[0])
        wbDrawButton.trailingAnchor.constraint(equalTo: wbTopBarView.centerXAnchor, constant: -25.0).isActive = true
        wbDrawButton.leadingAnchor.constraint(equalTo: wbTopBarView.centerXAnchor, constant: -55.0).isActive = true
        wbDrawButton.topAnchor.constraint(equalTo: wbTopBarView.topAnchor, constant: self.view.safeAreaInsets.top + 9.0).isActive = true
        wbDrawButton.bottomAnchor.constraint(equalTo: wbTopBarView.topAnchor, constant: self.view.safeAreaInsets.top + 41.0).isActive = true
        wbDrawButton.tintColor = UIColor.white
        wbDrawButton.setBackgroundImage(UIImage(systemName: "pencil"), for: .normal)
        wbDrawButton.setTitle("", for: .normal)
        wbDrawButton.addTarget(self, action: #selector(toDrawMode(_:)), for: .touchUpInside)
        
        let wbScrollButton: UIButton! = UIButton()
        wbScrollButton.translatesAutoresizingMaskIntoConstraints = false
        wbScrollButton.removeConstraints(wbScrollButton.constraints)
        buttonBarList.append(wbScrollButton)
        wbTopBarView.addSubview(buttonBarList[1])
        wbScrollButton.trailingAnchor.constraint(equalTo: wbTopBarView.centerXAnchor, constant: 55.0).isActive = true
        wbScrollButton.leadingAnchor.constraint(equalTo: wbTopBarView.centerXAnchor, constant: 25.0).isActive = true
        wbScrollButton.topAnchor.constraint(equalTo: wbTopBarView.topAnchor, constant: self.view.safeAreaInsets.top + 10.0).isActive = true
        wbScrollButton.bottomAnchor.constraint(equalTo: wbTopBarView.topAnchor, constant: self.view.safeAreaInsets.top + 40.0).isActive = true
        wbScrollButton.tintColor = UIColor.white
        wbScrollButton.setBackgroundImage(UIImage(named: "ScrollIcon"), for: .normal)
        wbScrollButton.setTitle("", for: .normal)
        wbScrollButton.addTarget(self, action: #selector(toScrollMode(_:)), for: .touchUpInside)
        
        wbEraserBut = UIButton()
        wbEraserBut.translatesAutoresizingMaskIntoConstraints = false
        wbEraserBut.removeConstraints(wbEraserBut.constraints)
        buttonBarList.append(wbEraserBut)
        wbTopBarView.addSubview(buttonBarList[2])
        wbEraserBut.trailingAnchor.constraint(equalTo: wbTopBarView.centerXAnchor, constant: 15.0).isActive = true
        wbEraserBut.leadingAnchor.constraint(equalTo: wbTopBarView.centerXAnchor, constant: -15.0).isActive = true
        wbEraserBut.topAnchor.constraint(equalTo: wbTopBarView.topAnchor, constant: self.view.safeAreaInsets.top + 10.0).isActive = true
        wbEraserBut.bottomAnchor.constraint(equalTo: wbTopBarView.topAnchor, constant: self.view.safeAreaInsets.top + 40.0).isActive = true
        wbEraserBut.tintColor = UIColor.white
        wbEraserBut.setBackgroundImage(UIImage(named: "EraserIcon"), for: .normal)
        wbEraserBut.setTitle("", for: .normal)
        wbEraserBut.addTarget(self, action: #selector(toEraserMode(_:)), for: .touchUpInside)
        
        wbEditSizeBut.removeFromSuperview()
        wbEditSizeBut = UIButton()
        wbEditSizeBut.translatesAutoresizingMaskIntoConstraints = false
        wbEditSizeBut.removeConstraints(wbEditSizeBut.constraints)
        wbTopBarView.addSubview(wbEditSizeBut)
        wbEditSizeBut.trailingAnchor.constraint(equalTo: wbTopBarView.centerXAnchor, constant: 95.0).isActive = true
        wbEditSizeBut.leadingAnchor.constraint(equalTo: wbTopBarView.centerXAnchor, constant: 65.0).isActive = true
        wbEditSizeBut.topAnchor.constraint(equalTo: wbTopBarView.topAnchor, constant: self.view.safeAreaInsets.top + 10.0).isActive = true
        wbEditSizeBut.bottomAnchor.constraint(equalTo: wbTopBarView.topAnchor, constant: self.view.safeAreaInsets.top + 40.0).isActive = true
        wbEditSizeBut.tintColor = UIColor.white
        wbEditSizeBut.setImage(UIImage(named: "whiteCircleTransparent"), for: .normal)
        let cvBRUH = (9 - wbSize) + 5.0
        wbEditSizeBut.contentEdgeInsets = UIEdgeInsets(top: cvBRUH, left: cvBRUH, bottom: cvBRUH, right: cvBRUH)
        wbEditSizeBut.contentMode = .scaleAspectFit
        wbEditSizeBut.setTitle("", for: .normal)
        wbEditSizeBut.addTarget(self, action: #selector(toEditSizeMode(_:)), for: .touchUpInside)
        
        wbEditColorBut.removeFromSuperview()
        wbEditColorBut = UIButton()
        wbEditColorBut.translatesAutoresizingMaskIntoConstraints = false
        wbEditColorBut.removeConstraints(wbEditColorBut.constraints)
        wbTopBarView.addSubview(wbEditColorBut)
        wbEditColorBut.trailingAnchor.constraint(equalTo: wbTopBarView.centerXAnchor, constant: -65.0).isActive = true
        wbEditColorBut.leadingAnchor.constraint(equalTo: wbTopBarView.centerXAnchor, constant: -95.0).isActive = true
        wbEditColorBut.topAnchor.constraint(equalTo: wbTopBarView.topAnchor, constant: self.view.safeAreaInsets.top + 10.0).isActive = true
        wbEditColorBut.bottomAnchor.constraint(equalTo: wbTopBarView.topAnchor, constant: self.view.safeAreaInsets.top + 40.0).isActive = true
        wbEditColorBut.tintColor = UIColor.white
        wbEditColorBut.setTitle("", for: .normal)
        wbEditColorBut.backgroundColor = UIColor(cgColor: returnColor(hue: wbColor))
        wbEditColorBut.layer.cornerRadius = 15.0
        wbEditColorBut.layer.borderWidth = 2.0
        wbEditColorBut.layer.borderColor = UIColor.white.cgColor
        wbEditColorBut.addTarget(self, action: #selector(toEditColorMode(_:)), for: .touchUpInside)
        
        wbmLC.append(wbModeView.leadingAnchor.constraint(equalTo: wbDrawButton.leadingAnchor, constant: -7.0))
        wbmLC[0].isActive = false
        wbmLC.append(wbModeView.trailingAnchor.constraint(equalTo: wbDrawButton.trailingAnchor, constant: 7.0))
        wbmLC[1].isActive = false
        wbmLC.append(wbModeView.topAnchor.constraint(equalTo: wbDrawButton.topAnchor, constant: -7.0))
        wbmLC[2].isActive = false
        wbmLC.append(wbModeView.bottomAnchor.constraint(equalTo: wbDrawButton.bottomAnchor, constant: 7.0))
        wbmLC[3].isActive = false
        wbmLC.append(wbModeView.leadingAnchor.constraint(equalTo: wbEditSizeBut.leadingAnchor, constant: -7.0))
        wbmLC[4].isActive = false
        wbmLC.append(wbModeView.trailingAnchor.constraint(equalTo: wbEditSizeBut.trailingAnchor, constant: 7.0))
        wbmLC[5].isActive = false
        wbmLC.append(wbModeView.topAnchor.constraint(equalTo: wbEditSizeBut.topAnchor, constant: -7.0))
        wbmLC[6].isActive = false
        wbmLC.append(wbModeView.bottomAnchor.constraint(equalTo: wbEditSizeBut.bottomAnchor, constant: 7.0))
        wbmLC[7].isActive = false
        wbmLC.append(wbModeView.leadingAnchor.constraint(equalTo: wbEraserBut.leadingAnchor, constant: -7.0))
        wbmLC[8].isActive = false
        wbmLC.append(wbModeView.trailingAnchor.constraint(equalTo: wbEraserBut.trailingAnchor, constant: 7.0))
        wbmLC[9].isActive = false
        wbmLC.append(wbModeView.topAnchor.constraint(equalTo: wbEraserBut.topAnchor, constant: -7.0))
        wbmLC[10].isActive = false
        wbmLC.append(wbModeView.bottomAnchor.constraint(equalTo: wbEraserBut.bottomAnchor, constant: 7.0))
        wbmLC[11].isActive = false
        wbmLC.append(wbModeView.leadingAnchor.constraint(equalTo: wbEditColorBut.leadingAnchor, constant: -7.0))
        wbmLC[12].isActive = false
        wbmLC.append(wbModeView.trailingAnchor.constraint(equalTo: wbEditColorBut.trailingAnchor, constant: 7.0))
        wbmLC[13].isActive = false
        wbmLC.append(wbModeView.topAnchor.constraint(equalTo: wbEditColorBut.topAnchor, constant: -7.0))
        wbmLC[14].isActive = false
        wbmLC.append(wbModeView.bottomAnchor.constraint(equalTo: wbEditColorBut.bottomAnchor, constant: 7.0))
        wbmLC[15].isActive = false
        wbmLC.append(wbModeView.leadingAnchor.constraint(equalTo: wbScrollButton.leadingAnchor, constant: -7.0))
        wbmLC[16].isActive = true
        wbmLC.append(wbModeView.trailingAnchor.constraint(equalTo: wbScrollButton.trailingAnchor, constant: 7.0))
        wbmLC[17].isActive = true
        wbmLC.append(wbModeView.topAnchor.constraint(equalTo: wbScrollButton.topAnchor, constant: -7.0))
        wbmLC[18].isActive = true
        wbmLC.append(wbModeView.bottomAnchor.constraint(equalTo: wbScrollButton.bottomAnchor, constant: 7.0))
        wbmLC[19].isActive = true
        wbModeView.backgroundColor = UIColor(displayP3Red: 0.56, green: 0.54, blue: 0.85, alpha: 1.0)
        wbModeView.layer.cornerRadius = 5.0
        wbModeView.alpha = 0.8
        
        let wbRotateBut: UIButton! = UIButton()
        wbRotateBut.translatesAutoresizingMaskIntoConstraints = false
        wbRotateBut.removeConstraints(wbScrollButton.constraints)
        buttonBarList.append(wbRotateBut)
        wbTopBarView.addSubview(buttonBarList[3])
        wbRotateBut.trailingAnchor.constraint(equalTo: wbTopBarView.leadingAnchor, constant: 60.0).isActive = true
        wbRotateBut.leadingAnchor.constraint(equalTo: wbTopBarView.leadingAnchor, constant: 20.0).isActive = true
        wbRotateBut.topAnchor.constraint(equalTo: wbTopBarView.topAnchor, constant: self.view.safeAreaInsets.top + 5.0).isActive = true
        wbRotateBut.bottomAnchor.constraint(equalTo: wbTopBarView.topAnchor, constant: self.view.safeAreaInsets.top + 45.0).isActive = true
        wbRotateBut.tintColor = UIColor.white
        wbRotateBut.setBackgroundImage(UIImage(named: "TurnLeft"), for: .normal)
        wbRotateBut.setTitle("", for: .normal)
        wbRotateBut.addTarget(self, action: #selector(rotateImageView(_:)), for: .touchUpInside)
        
        wbMode = "scroll"
        wbLastMode = "scroll"
        wbSV.panGestureRecognizer.isEnabled = true
        wbSV.pinchGestureRecognizer?.isEnabled = true
        wbMyPositions = []
        lineList = []
        lineIDList = []
        
        wbSV.removeFromSuperview()
        wbSV = UIScrollView()
        wbSV.translatesAutoresizingMaskIntoConstraints = false
        wbView.addSubview(wbSV)
        wbSV.removeConstraints(wbSV.constraints)
        wbSV.delegate = self
        wbSV.trailingAnchor.constraint(equalTo: wbView.trailingAnchor, constant: 0.0).isActive = true
        wbSV.leadingAnchor.constraint(equalTo: wbView.leadingAnchor, constant: 0.0).isActive = true
        wbSV.topAnchor.constraint(equalTo: wbView.topAnchor, constant: self.view.safeAreaInsets.top + 50.0).isActive = true
        wbSV.bottomAnchor.constraint(equalTo: wbView.bottomAnchor, constant: 0.0).isActive = true
        wbSV.showsHorizontalScrollIndicator = false
        wbSV.showsVerticalScrollIndicator = false
        wbSV.decelerationRate = .fast
        
        wbBackgroundView.removeFromSuperview()
        wbBackgroundView = UIView()
        wbBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        wbSV.addSubview(wbBackgroundView)
        wbBackgroundView.isUserInteractionEnabled = true
        wbBackgroundView.removeConstraints(wbBackgroundView.constraints)
        wbBackgroundView.trailingAnchor.constraint(equalTo: wbSV.contentLayoutGuide.trailingAnchor, constant: 0).isActive = true
        wbBackgroundView.leadingAnchor.constraint(equalTo: wbSV.contentLayoutGuide.leadingAnchor, constant: 0).isActive = true
        wbBackgroundView.topAnchor.constraint(equalTo: wbSV.contentLayoutGuide.topAnchor, constant: 0).isActive = true
        wbBackgroundView.bottomAnchor.constraint(equalTo: wbSV.contentLayoutGuide.bottomAnchor, constant: 0).isActive = true
        wbBackgroundView.widthAnchor.constraint(equalTo: wbSV.frameLayoutGuide.widthAnchor, constant: 0).isActive = true
        wbBackgroundView.heightAnchor.constraint(equalTo: wbSV.frameLayoutGuide.heightAnchor, constant: 0).isActive = true
        wbBackgroundView.backgroundColor = UIColor(displayP3Red: 0.3, green: 0.3, blue: 0.3, alpha: 1.0)
        
        wbImageView.removeFromSuperview()
        wbImageView = UIImageView()
        wbImageView.translatesAutoresizingMaskIntoConstraints = false
        wbBackgroundView.addSubview(wbImageView)
        wbImageView.isUserInteractionEnabled = true
        wbImageView.removeConstraints(wbImageView.constraints)
        wbImageView.centerXAnchor.constraint(equalTo: wbBackgroundView.centerXAnchor).isActive = true
        wbImageView.centerYAnchor.constraint(equalTo: wbBackgroundView.centerYAnchor).isActive = true
        wbImageView.heightAnchor.constraint(equalTo: wbBackgroundView.heightAnchor, constant: -20.0).isActive = true
        wbImageView.widthAnchor.constraint(equalTo: wbBackgroundView.widthAnchor, constant: -20.0).isActive = true
        wbImageView.contentMode = .scaleAspectFit
        wbImageView.image = UIImage()
        wbImageRadians = 0.0
        
        wbSizeSliderView.removeFromSuperview()
        wbSizeSliderView = UIView()
        wbSizeSliderView.translatesAutoresizingMaskIntoConstraints = false
        wbSizeSliderView.removeConstraints(wbSizeSliderView.constraints)
        wbView.addSubview(wbSizeSliderView)
        wbssLC = []
        wbSizeSliderView.leadingAnchor.constraint(equalTo: wbEditSizeBut.leadingAnchor, constant: -7.0).isActive = true
        wbSizeSliderView.trailingAnchor.constraint(equalTo: wbEditSizeBut.trailingAnchor, constant: 7.0).isActive = true
        wbSizeSliderView.topAnchor.constraint(equalTo: wbTopBarView.bottomAnchor, constant: 2.0).isActive = true
        wbssLC.append(wbSizeSliderView.bottomAnchor.constraint(equalTo: wbTopBarView.bottomAnchor, constant: 200.0))
        wbssLC[0].isActive = false
        wbssLC.append(wbSizeSliderView.bottomAnchor.constraint(equalTo: wbTopBarView.bottomAnchor, constant: 22.0))
        wbssLC[1].isActive = true
        wbSizeSliderView.layer.cornerRadius = 10.0
        wbSizeSliderView.alpha = 0.0
        wbSizeSliderView.backgroundColor = UIColor.systemIndigo
        
        wbSizeSlider.removeFromSuperview()
        wbSizeSlider = UISlider()
        wbSizeSlider.translatesAutoresizingMaskIntoConstraints = false
        wbSizeSlider.removeConstraints(wbSizeSlider.constraints)
        wbSizeSliderView.addSubview(wbSizeSlider)
        wbSizeSlider.transform = CGAffineTransform(rotationAngle: .pi / -2.0)
        wbSizeSlider.value = 0.25
        wbSizeSlider.widthAnchor.constraint(equalTo: wbSizeSliderView.heightAnchor, constant: -21.0).isActive = true
        wbSizeSlider.centerXAnchor.constraint(equalTo: wbSizeSliderView.centerXAnchor).isActive = true
        wbSizeSlider.centerYAnchor.constraint(equalTo: wbSizeSliderView.centerYAnchor).isActive = true
        wbSizeSlider.addTarget(self, action: #selector(sizeEdited(_:)), for: .valueChanged)
        
        wbColorSliderView.removeFromSuperview()
        wbColorSliderView = UIView()
        wbColorSliderView.translatesAutoresizingMaskIntoConstraints = false
        wbColorSliderView.removeConstraints(wbColorSliderView.constraints)
        wbView.addSubview(wbColorSliderView)
        wbcsLC = []
        wbColorSliderView.leadingAnchor.constraint(equalTo: wbEditColorBut.leadingAnchor, constant: -7.0).isActive = true
        wbColorSliderView.trailingAnchor.constraint(equalTo: wbEditColorBut.trailingAnchor, constant: 7.0).isActive = true
        wbColorSliderView.topAnchor.constraint(equalTo: wbTopBarView.bottomAnchor, constant: 2.0).isActive = true
        wbcsLC.append(wbColorSliderView.bottomAnchor.constraint(equalTo: wbTopBarView.bottomAnchor, constant: 200.0))
        wbcsLC[0].isActive = false
        wbcsLC.append(wbColorSliderView.bottomAnchor.constraint(equalTo: wbTopBarView.bottomAnchor, constant: 22.0))
        wbcsLC[1].isActive = true
        wbColorSliderView.layer.cornerRadius = 10.0
        wbColorSliderView.alpha = 0.0
        wbColorSliderView.backgroundColor = UIColor.systemIndigo
        
        wbColorSlider.removeFromSuperview()
        wbColorSlider = UISlider()
        wbColorSlider.translatesAutoresizingMaskIntoConstraints = false
        wbColorSlider.removeConstraints(wbColorSlider.constraints)
        wbColorSliderView.addSubview(wbColorSlider)
        wbColorSlider.transform = CGAffineTransform(rotationAngle: .pi / -2.0)
        wbColorSlider.value = 1.0
        wbColorSlider.widthAnchor.constraint(equalTo: wbColorSliderView.heightAnchor, constant: -21.0).isActive = true
        wbColorSlider.centerXAnchor.constraint(equalTo: wbColorSliderView.centerXAnchor).isActive = true
        wbColorSlider.centerYAnchor.constraint(equalTo: wbColorSliderView.centerYAnchor).isActive = true
        wbColorSlider.addTarget(self, action: #selector(colorEdited(_:)), for: .valueChanged)
        
        wbCoverView.removeFromSuperview()
        wbCoverView = UIView()
        wbView.addSubview(wbCoverView)
        wbCoverView.translatesAutoresizingMaskIntoConstraints = false
        wbCoverView.removeConstraints(wbCoverView.constraints)
        wbCoverView.leadingAnchor.constraint(equalTo: wbView.leadingAnchor, constant: 0.0).isActive = true
        wbCoverView.trailingAnchor.constraint(equalTo: wbView.trailingAnchor, constant: 0.0).isActive = true
        wbCoverView.topAnchor.constraint(equalTo: wbView.topAnchor, constant: 0.0).isActive = true
        wbCoverView.bottomAnchor.constraint(equalTo: wbView.bottomAnchor, constant: 0.0).isActive = true
        wbCoverView.backgroundColor = UIColor.black
        wbCoverView.alpha = 0.5
        wbView.bringSubviewToFront(wbCoverView)
        
        wbImageLoaded = false
        drawingLine = false
        loadCircle.isHidden = false
        self.view.bringSubviewToFront(loadCircle)
        let imageTag: String = sender.title(for: .normal)!
        imageDrawingOn = imageTag
        db.child("connections/\(idInfo!)/message_list/\(imageDrawingOn)/lines").removeAllObservers()
        
        st.child("messages/\(idInfo!)/\(imageTag).jpg").getData(maxSize: 25 * 1024 * 1024, completion: { (data, error) in
            if error != nil
            {
                print("error loading image \(error!)")
            }
            if let data = data
            {
                
                if(!self.wbUP || sender.title(for: .normal)! != self.imageDrawingOn)
                {
                    return
                }
                
                self.loadLines()
                
                self.wbImageLoaded = true
                self.loadCircle.isHidden = true
                self.wbImageView.image = UIImage(data: data)
                self.wbSV.minimumZoomScale = 1.0
                self.wbSV.maximumZoomScale = 5.0
                self.wbSV.zoomScale = 1.0
                
                if((self.wbImageView.image?.size.height)! / (self.wbImageView.image?.size.width)! > self.wbBackgroundView.bounds.height / self.wbBackgroundView.bounds.width)
                {
                    self.wbImageHei = self.wbBackgroundView.bounds.height - 20.0
                    self.wbImageWid = self.wbImageHei * (self.wbImageView.image?.size.width)! / (self.wbImageView.image?.size.height)!
                    self.wbHeiToImage = 0.0
                    self.wbWidToImage = (self.wbBackgroundView.bounds.width - self.wbImageWid) / 2.0 - 10.0
                } else
                {
                    self.wbImageWid = self.wbBackgroundView.bounds.width - 20.0
                    self.wbImageHei = self.wbImageWid * (self.wbImageView.image?.size.height)! / (self.wbImageView.image?.size.width)!
                    self.wbWidToImage = 0.0
                    self.wbHeiToImage = (self.wbBackgroundView.bounds.height - self.wbImageHei) / 2.0 - 10.0
                }
                
            }
        })
        
        self.view.layoutIfNeeded()
        
        wbView.isHidden = false
        
        wbUP = true
        
        UIView.animate(withDuration: 0.2, animations: {
            
            self.wbLC[4].isActive = false
            self.wbLC[5].isActive = false
            self.wbLC[6].isActive = false
            self.wbLC[7].isActive = false
            
            self.wbLC[0].isActive = true
            self.wbLC[1].isActive = true
            self.wbLC[2].isActive = true
            self.wbLC[3].isActive = true
            
            self.wbView.alpha = 1.0
            
            self.view.layoutIfNeeded()
            
        }) { _ in
            
            self.view.layoutIfNeeded()
        }
        
    }
    
    @objc func sizeEdited(_ sender: UISlider!)
    {
        wbSize = CGFloat(sender.value + 0.125) * 8.0
        let changevar = (9 - wbSize) + 5.0
        wbEditSizeBut.contentEdgeInsets = UIEdgeInsets(top: changevar, left: changevar, bottom: changevar, right: changevar)
    }
    
    @objc func colorEdited(_ sender: UISlider!)
    {
        wbColor = CGFloat(sender.value)
        wbEditColorBut.backgroundColor = UIColor(cgColor: returnColor(hue: CGFloat(sender.value)))
    }
    
    @objc func toEditColorMode(_ sender: UIButton!)
    {
        
        if(drawingLine)
        {
            let posList = wbMyPositions
            let base = db.child("connections/\(idInfo!)/message_list/\(imageDrawingOn)/lines").childByAutoId()
            lineIDList.append(base.key!)
            base.updateChildValues(["user":"\(userEmail!)", "color":"\(wbColor)", "thickness":"\(wbSize / wbSV.zoomScale)", "points":posList!])
            wbMyPositions = []
            drawingLine = false
        }
        
        if(wbMode != "color")
        {
        
            wbMode = "color"
            wbSV.panGestureRecognizer.isEnabled = false
            wbSV.pinchGestureRecognizer?.isEnabled = false
            wbSV.isUserInteractionEnabled = false
            
            let deactivate: [Int] = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 16, 17, 18, 19]
            let activate: [Int] = [12, 13, 14, 15]
            
            UIView.animate(withDuration: 0.2, animations: {
                
                for b in 0...(deactivate.count - 1)
                {
                    self.wbmLC[deactivate[b]].isActive = false
                }
                
                for b in 0...(activate.count - 1)
                {
                    self.wbmLC[activate[b]].isActive = true
                }
                
                self.wbssLC[0].isActive = false
                self.wbssLC[1].isActive = true
                self.wbSizeSliderView.alpha = 0.0
                
                self.wbcsLC[1].isActive = false
                self.wbcsLC[0].isActive = true
                self.wbColorSliderView.alpha = 1.0
                
                self.view.layoutIfNeeded()
                
            }) { _ in
                self.view.layoutIfNeeded()
            }
        } else
        {
            wbMode = wbLastMode
            if(wbMode == "scroll")
            {
                wbSV.panGestureRecognizer.isEnabled = true
                wbSV.pinchGestureRecognizer?.isEnabled = true
                wbSV.isUserInteractionEnabled = true
                toScrollMode(UIButton())
            } else if(wbMode == "draw")
            {
                toDrawMode(UIButton())
            } else if(wbMode == "erase")
            {
                toEraserMode(UIButton())
            }
            
        }
    }
    
    @objc func toEraserMode(_ sender: UIButton!)
    {
        
        
        wbMode = "erase"
        wbLastMode = "erase"
        wbSV.panGestureRecognizer.isEnabled = false
        wbSV.pinchGestureRecognizer?.isEnabled = false
        wbSV.isUserInteractionEnabled = false
        
        let deactivate: [Int] = [0, 1, 2, 3, 4, 5, 6, 7, 12, 13, 14, 15, 16, 17, 18, 19]
        let activate: [Int] = [8, 9, 10, 11]
        
        UIView.animate(withDuration: 0.2, animations: {
            
            for b in 0...(deactivate.count - 1)
            {
                self.wbmLC[deactivate[b]].isActive = false
            }
            
            for b in 0...(activate.count - 1)
            {
                self.wbmLC[activate[b]].isActive = true
            }
            
            self.wbssLC[0].isActive = false
            self.wbssLC[1].isActive = true
            self.wbSizeSliderView.alpha = 0.0
            
            self.wbcsLC[0].isActive = false
            self.wbcsLC[1].isActive = true
            self.wbColorSliderView.alpha = 0.0
            
            self.view.layoutIfNeeded()
            
        }) { _ in
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func toEditSizeMode(_ sender: UIButton!)
    {
        
        if(drawingLine)
        {
            let posList = wbMyPositions
            let base = db.child("connections/\(idInfo!)/message_list/\(imageDrawingOn)/lines").childByAutoId()
            lineIDList.append(base.key!)
            base.updateChildValues(["user":"\(userEmail!)", "color":"\(wbColor)", "thickness":"\(wbSize / wbSV.zoomScale)", "points":posList!])
            wbMyPositions = []
            drawingLine = false
        }
        
        if(wbMode != "size")
        {
            wbMode = "size"
            wbSV.panGestureRecognizer.isEnabled = false
            wbSV.pinchGestureRecognizer?.isEnabled = false
            wbSV.isUserInteractionEnabled = false
            
            let deactivate: [Int] = [0, 1, 2, 3, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19]
            let activate: [Int] = [4, 5, 6, 7]
            
            UIView.animate(withDuration: 0.2, animations: {
                
                for b in 0...(deactivate.count - 1)
                {
                    self.wbmLC[deactivate[b]].isActive = false
                }
                
                for b in 0...(activate.count - 1)
                {
                    self.wbmLC[activate[b]].isActive = true
                }
                
                self.wbssLC[1].isActive = false
                self.wbssLC[0].isActive = true
                self.wbSizeSliderView.alpha = 1.0
                
                self.wbcsLC[0].isActive = false
                self.wbcsLC[1].isActive = true
                self.wbColorSliderView.alpha = 0.0
                
                self.view.layoutIfNeeded()
                
            }) { _ in
                self.view.layoutIfNeeded()
            }
        } else
        {
            wbMode = wbLastMode
            if(wbMode == "scroll")
            {
                wbSV.panGestureRecognizer.isEnabled = true
                wbSV.pinchGestureRecognizer?.isEnabled = true
                wbSV.isUserInteractionEnabled = true
                toScrollMode(UIButton())
            } else if(wbMode == "draw")
            {
                toDrawMode(UIButton())
            } else if(wbMode == "erase")
            {
                toEraserMode(UIButton())
            }
        }
    }
    
    @objc func rotateImageView(_ sender: UIButton!)
    {
        if(wbUP && wbImageLoaded)
        {
            if(drawingLine)
            {
                let posList = wbMyPositions
                let base = db.child("connections/\(idInfo!)/message_list/\(imageDrawingOn)/lines").childByAutoId()
                lineIDList.append(base.key!)
                base.updateChildValues(["user":"\(userEmail!)", "color":"\(wbColor)", "thickness":"\(wbSize / wbSV.zoomScale)", "points":posList!])
                wbMyPositions = []
                drawingLine = false
            }
            
            let imageHolder = wbImageView.image!
            wbImageView.removeFromSuperview()
            wbImageView = UIImageView()
            wbImageView.translatesAutoresizingMaskIntoConstraints = false
            wbBackgroundView.addSubview(wbImageView)
            wbImageView.isUserInteractionEnabled = true
            wbImageView.removeConstraints(wbImageView.constraints)
            wbImageView.centerXAnchor.constraint(equalTo: wbBackgroundView.centerXAnchor).isActive = true
            wbImageView.centerYAnchor.constraint(equalTo: wbBackgroundView.centerYAnchor).isActive = true
            if(wbImageRadians.truncatingRemainder(dividingBy: .pi) != 0.0)
            {
                wbImageView.heightAnchor.constraint(equalTo: wbBackgroundView.heightAnchor, constant: -20.0).isActive = true
                wbImageView.widthAnchor.constraint(equalTo: wbBackgroundView.widthAnchor, constant: -20.0).isActive = true
            } else
            {
                wbImageView.widthAnchor.constraint(equalTo: wbBackgroundView.heightAnchor, constant: -20.0).isActive = true
                wbImageView.heightAnchor.constraint(equalTo: wbBackgroundView.widthAnchor, constant: -20.0).isActive = true
            }
            
            wbImageView.contentMode = .scaleAspectFit
            wbImageView.image = imageHolder
            wbImageRadians -= .pi / 2.0
            wbImageView.transform = wbImageView.transform.rotated(by: wbImageRadians)
            buttonBarList.forEach { (buttonn) in
                buttonn.transform = buttonn.transform.rotated(by: .pi / -2.0)
            }
            wbSV.zoomScale = 1.0
            lineIDList = []
            wbCoverView.alpha = 0.5
            self.loadLines()
            if(wbImageRadians.truncatingRemainder(dividingBy: .pi) != 0.0)
            {
                if((wbImageView.image?.size.width)! / (wbImageView.image?.size.height)! > wbBackgroundView.bounds.height / wbBackgroundView.bounds.width)
                {
                    wbImageWid = wbBackgroundView.bounds.height - 20.0
                    wbImageHei = wbImageWid * (wbImageView.image?.size.height)! / (wbImageView.image?.size.width)!
                    wbWidToImage = 0.0
                    wbHeiToImage = (wbBackgroundView.bounds.width - wbImageHei) / 2.0 - 10.0
                } else
                {
                    wbImageHei = wbBackgroundView.bounds.width - 20.0
                    wbImageWid = wbImageHei * (wbImageView.image?.size.width)! / (wbImageView.image?.size.height)!
                    wbHeiToImage = 0.0
                    wbWidToImage = (wbBackgroundView.bounds.height - wbImageWid) / 2.0 - 10.0
                }
            } else
            {
                if((wbImageView.image?.size.height)! / (wbImageView.image?.size.width)! > wbBackgroundView.bounds.height / wbBackgroundView.bounds.width)
                {
                    wbImageHei = wbBackgroundView.bounds.height - 20.0
                    wbImageWid = wbImageHei * (wbImageView.image?.size.width)! / (wbImageView.image?.size.height)!
                    wbHeiToImage = 0.0
                    wbWidToImage = (wbBackgroundView.bounds.width - wbImageWid) / 2.0 - 10.0
                } else
                {
                    wbImageWid = wbBackgroundView.bounds.width - 20.0
                    wbImageHei = wbImageWid * (wbImageView.image?.size.height)! / (wbImageView.image?.size.width)!
                    wbWidToImage = 0.0
                    wbHeiToImage = (wbBackgroundView.bounds.height - wbImageHei) / 2.0 - 10.0
                }
            }
        }
    }
    
    @objc func toDrawMode(_ sender: UIButton!)
    {
        
        wbMode = "draw"
        wbLastMode = "draw"
        wbSV.panGestureRecognizer.isEnabled = false
        wbSV.pinchGestureRecognizer?.isEnabled = false
        wbSV.isUserInteractionEnabled = false
        
        let deactivate: [Int] = [4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19]
        let activate: [Int] = [0, 1, 2, 3]
        
        UIView.animate(withDuration: 0.2, animations: {
            
            for b in 0...(deactivate.count - 1)
            {
                self.wbmLC[deactivate[b]].isActive = false
            }
            
            for b in 0...(activate.count - 1)
            {
                self.wbmLC[activate[b]].isActive = true
            }
            
            self.wbssLC[0].isActive = false
            self.wbssLC[1].isActive = true
            self.wbSizeSliderView.alpha = 0.0
            
            self.wbcsLC[0].isActive = false
            self.wbcsLC[1].isActive = true
            self.wbColorSliderView.alpha = 0.0
            
            self.view.layoutIfNeeded()
            
        }) { _ in
            self.view.layoutIfNeeded()
        }
        
    }
    
    @objc func toScrollMode(_ sender: UIButton!)
    {
        
        if(drawingLine)
        {
            let posList = wbMyPositions
            let base = db.child("connections/\(idInfo!)/message_list/\(imageDrawingOn)/lines").childByAutoId()
            lineIDList.append(base.key!)
            base.updateChildValues(["user":"\(userEmail!)", "color":"\(wbColor)", "thickness":"\(wbSize / wbSV.zoomScale)", "points":posList!])
            wbMyPositions = []
            drawingLine = false
        }
        
        wbMode = "scroll"
        wbLastMode = "scroll"
        wbSV.panGestureRecognizer.isEnabled = true
        wbSV.pinchGestureRecognizer?.isEnabled = true
        wbSV.isUserInteractionEnabled = true
        
        let deactivate: [Int] = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15]
        let activate: [Int] = [16, 17, 18, 19]
        
        UIView.animate(withDuration: 0.2, animations: {
            
            for b in 0...(deactivate.count - 1)
            {
                self.wbmLC[deactivate[b]].isActive = false
            }
            
            for b in 0...(activate.count - 1)
            {
                self.wbmLC[activate[b]].isActive = true
            }
            
            self.wbssLC[0].isActive = false
            self.wbssLC[1].isActive = true
            self.wbSizeSliderView.alpha = 0.0
            
            self.wbcsLC[0].isActive = false
            self.wbcsLC[1].isActive = true
            self.wbColorSliderView.alpha = 0.0
            
            self.view.layoutIfNeeded()
            
        }) { _ in
            self.view.layoutIfNeeded()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        if(wbMode == "draw" && wbUP && wbImageLoaded)
        {
            wbMyPositions = []
            if let touch = touches.first
            {
                currLinePath = UIBezierPath()
                currLinePath.removeAllPoints()
                cnol = lineList.count
                lineList.append(CAShapeLayer())
                lineList[cnol].strokeColor = returnColor(hue: wbColor)
                lineList[cnol].lineWidth = wbSize / wbSV.zoomScale
                lineList[cnol].path = currLinePath.cgPath
                lineList[cnol].fillColor = UIColor.clear.cgColor
                lineList[cnol].lineCap = .round
                lineList[cnol].lineJoin = .round
                wbImageView.layer.addSublayer(lineList[cnol])
                
                let position = touch.location(in: wbImageView)
                var modifiedPos = position
                modifiedPos.x -= wbWidToImage
                modifiedPos.y -= wbHeiToImage
                if(modifiedPos.isInRect(rect: CGRect(x: 0, y: 0, width: wbImageWid, height: wbImageHei)))
                {
                    modifiedPos.x *= 10000.0 / wbImageWid
                    modifiedPos.y *= 10000.0 / wbImageHei
                    modifiedPos.x = CGFloat(round(modifiedPos.x)) / 10000.0
                    modifiedPos.y = CGFloat(round(modifiedPos.y)) / 10000.0
                    currLinePath.move(to: CGPoint(x: modifiedPos.x * wbImageWid + wbWidToImage, y: modifiedPos.y * wbImageHei + wbHeiToImage))
                    currLinePath.addLine(to: CGPoint(x: modifiedPos.x * wbImageWid + wbWidToImage, y: modifiedPos.y * wbImageHei + wbHeiToImage - 1.0))
                    lineList[cnol].path = currLinePath.cgPath
                    wbMyPositions.append("\(modifiedPos.x)|\(modifiedPos.y)")
                    wbMyPositions.append("\(modifiedPos.x)|\(modifiedPos.y - 0.0001)")
                    drawingLine = true
                }
                
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        if(wbMode == "draw" && wbUP && wbImageLoaded)
        {
            if let touch = touches.first
            {
                let position = touch.location(in: wbImageView)
                var modifiedPos = position
                modifiedPos.x -= wbWidToImage
                modifiedPos.y -= wbHeiToImage
                if(modifiedPos.isInRect(rect: CGRect(x: 0, y: 0, width: wbImageWid, height: wbImageHei)))
                {
                    modifiedPos.x *= 10000.0 / wbImageWid
                    modifiedPos.y *= 10000.0 / wbImageHei
                    modifiedPos.x = CGFloat(round(modifiedPos.x)) / 10000.0
                    modifiedPos.y = CGFloat(round(modifiedPos.y)) / 10000.0
                    if(wbMyPositions.count == 0)
                    {
                        currLinePath = UIBezierPath()
                        currLinePath.removeAllPoints()
                        cnol = lineList.count
                        lineList.append(CAShapeLayer())
                        lineList[cnol].strokeColor = returnColor(hue: wbColor)
                        lineList[cnol].lineWidth = wbSize / wbSV.zoomScale
                        lineList[cnol].path = currLinePath.cgPath
                        lineList[cnol].fillColor = UIColor.clear.cgColor
                        lineList[cnol].lineCap = .round
                        lineList[cnol].lineJoin = .round
                        wbImageView.layer.addSublayer(lineList[cnol])
                        currLinePath.move(to: CGPoint(x: modifiedPos.x * wbImageWid + wbWidToImage, y: modifiedPos.y * wbImageHei + wbHeiToImage))
                        currLinePath.addLine(to: CGPoint(x: modifiedPos.x * wbImageWid + wbWidToImage, y: modifiedPos.y * wbImageHei + wbHeiToImage - 1.0))
                        lineList[cnol].path = currLinePath.cgPath
                        wbMyPositions.append("\(modifiedPos.x)|\(modifiedPos.y)")
                        wbMyPositions.append("\(modifiedPos.x)|\(modifiedPos.y - 0.0001)")
                        drawingLine = true
                    } else if(wbMyPositions[wbMyPositions.count - 1] != "\(modifiedPos.x)|\(modifiedPos.y)")
                    {
                        currLinePath.addLine(to: CGPoint(x: modifiedPos.x * wbImageWid + wbWidToImage, y: modifiedPos.y * wbImageHei + wbHeiToImage))
                        lineList[cnol].path = currLinePath.cgPath
                        wbMyPositions.append("\(modifiedPos.x)|\(modifiedPos.y)")
                    }
                } else if(wbMyPositions.count > 0)
                {
                    let posList = wbMyPositions
                    let base = db.child("connections/\(idInfo!)/message_list/\(imageDrawingOn)/lines").childByAutoId()
                    lineIDList.append(base.key!)
                    lineList[cnol].setValue(base.key!, forKey: "KEY")
                    base.updateChildValues(["user":"\(userEmail!)", "color":"\(wbColor)", "thickness":"\(wbSize / wbSV.zoomScale)", "points":posList!])
                    wbMyPositions = []
                    drawingLine = false
                }
                
            }
        } else if(wbMode == "erase" && wbUP && wbImageLoaded)
        {
            if let touch = touches.first
            {
                var position = touch.location(in: wbImageView)
                position.x *= 10000.0
                position.y *= 10000.0
                position.x = CGFloat(round(Double(position.x))) / 10000.0
                position.y = CGFloat(round(Double(position.y))) / 10000.0
                guard let sublayers = wbImageView.layer.sublayers as? [CAShapeLayer] else { return }

                for layer in sublayers
                {
                    let newPath = layer.path?.copy(strokingWithWidth: layer.lineWidth + 3.0, lineCap: .round, lineJoin: .round, miterLimit: 0.0)
                    if let path = newPath
                    {
                        if(path.contains(position))
                        {
                            let tempKEY = layer.value(forKey: "KEY") as? String
                            db.child("connections/\(idInfo!)/message_list/\(imageDrawingOn)").observeSingleEvent(of: .value) { thedata in
                                if(thedata.hasChild("lines/\(tempKEY!)"))
                                {
                                    self.db.child("connections/\(self.idInfo!)/message_list/\(self.imageDrawingOn)/lines/\(tempKEY!)").removeValue()
                                }
                            }
                            guard let tempINT = lineList.firstIndex(of: layer) else { return }
                            guard let tempINT2 = lineIDList.firstIndex(of: tempKEY!) else { return }
                            lineIDList[tempINT2] = ""
                            lineList[tempINT].removeFromSuperlayer()
                            lineList[tempINT].isHidden = true
                            lineList[tempINT] = CAShapeLayer()
                        }
                    }
                }
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        if(wbMode == "draw" && wbUP && wbImageLoaded && wbMyPositions.count > 0)
        {
            
            let posList = wbMyPositions
            let base = db.child("connections/\(idInfo!)/message_list/\(imageDrawingOn)/lines").childByAutoId()
            lineIDList.append(base.key!)
            lineList[cnol].setValue(base.key!, forKey: "KEY")
            base.updateChildValues(["user":"\(userEmail!)", "color":"\(wbColor)", "thickness":"\(wbSize / wbSV.zoomScale)", "points":posList!])
            
            //drawLine(points: posList!, lineWidth: wbSize / wbSV.zoomScale, lineColor: UIColor.black.cgColor, addKey: base.key!)
            wbMyPositions = []
            drawingLine = false
        }
    }
    
    func drawLine(points: [String]!, lineWidth: CGFloat, lineColor: CGColor, addKey: String)
    {
        let q = lineList.count
        lineList.append(CAShapeLayer())
        lineList[q].setValue(addKey, forKey: "KEY")
        lineList[q].strokeColor = lineColor
        lineList[q].lineWidth = lineWidth
        let linePath: UIBezierPath = UIBezierPath()
        linePath.removeAllPoints()
        linePath.move(to: CGPoint(x: wbImageWid * CGFloat(truncating: NumberFormatter().number(from: "\(points[0].split(separator: "|")[0])")!) + wbWidToImage, y: wbImageHei * CGFloat(truncating: NumberFormatter().number(from: "\(points[0].split(separator: "|")[1])")!) + wbHeiToImage))
        points.forEach { item in
            let sub = item.split(separator: "|")
            let xcoord = CGFloat(truncating: NumberFormatter().number(from: "\(sub[0])")!) * wbImageWid
            let ycoord = CGFloat(truncating: NumberFormatter().number(from: "\(sub[1])")!) * wbImageHei
            linePath.addLine(to: CGPoint(x: xcoord + wbWidToImage, y: ycoord + wbHeiToImage))
        }
        lineList[q].path = linePath.cgPath
        lineList[q].fillColor = UIColor.clear.cgColor
        lineList[q].lineCap = .round
        lineList[q].lineJoin = .round
        wbImageView.layer.addSublayer(lineList[q])
    }
    
    func loadLines()
    {
        db.child("connections/\(idInfo!)/message_list/\(imageDrawingOn)").observeSingleEvent(of: .value) { (thedata) in
            if(!thedata.hasChild("lines"))
            {
                self.wbCoverView.alpha = 0.0
            }
        }
        db.child("connections/\(idInfo!)/message_list/\(imageDrawingOn)/lines").observe(.childAdded) { datasnap in
            if let value = datasnap.value
            {
                let dict = value as! [String: Any]
                let colorStr = dict["color"] as? String
                let color = CGFloat(truncating: NumberFormatter().number(from: colorStr!)!)
                let lineWid = CGFloat(truncating: NumberFormatter().number(from: (dict["thickness"] as? String)!)!)
                if(!self.lineIDList.contains(datasnap.key))
                {
                    let pOINTS = datasnap.childSnapshot(forPath: "points").children.allObjects as? [DataSnapshot]
                    var dataPoints: [String]! = []
                    for _ in 0...(pOINTS!.count - 1)
                    {
                        dataPoints.append("")
                    }
                    for cHILD in pOINTS!
                    {
                        dataPoints[Int("\(cHILD.key)")!] = (cHILD.value as? String)!
                    }
                    self.drawLine(points: dataPoints, lineWidth: lineWid, lineColor: self.returnColor(hue: color), addKey: datasnap.key)
                    self.lineIDList.append(datasnap.key)
                    self.wbCoverView.alpha = 0.0

                }
            }
        }
        db.child("connections/\(idInfo!)/message_list/\(imageDrawingOn)/lines").observe(.childRemoved) { datasnap in
            if let _ = datasnap.value
            {
                if(self.lineIDList.contains(datasnap.key))
                {
                    guard let sublayers = self.wbImageView.layer.sublayers as? [CAShapeLayer] else { return }

                    for layer in sublayers
                    {
                        if((layer.value(forKey: "KEY") as? String)! == datasnap.key)
                        {
                            let itemof1: Int = self.lineIDList.firstIndex(of: datasnap.key)!
                            let itemof2: Int = self.lineList.firstIndex(of: layer)!
                            self.lineIDList[itemof1] = ""
                            self.lineList[itemof2].isHidden = true
                            self.lineList[itemof2] = CAShapeLayer()
                            self.lineList[itemof2].removeFromSuperlayer()
                        }
                    }
                }
            }
        }
    }
    
    @objc func closeImagePopup(_ sender: UIButton!)
    {
        self.view.layoutIfNeeded()

        loadCircle.isHidden = true
        
        UIView.animate(withDuration: 0.2, animations: {
            
            self.wbLC[0].isActive = false
            self.wbLC[1].isActive = false
            self.wbLC[2].isActive = false
            self.wbLC[3].isActive = false
            
            self.wbLC[4].isActive = true
            self.wbLC[5].isActive = true
            self.wbLC[6].isActive = true
            self.wbLC[7].isActive = true
            
            self.wbView.alpha = 0.5
            
            self.view.layoutIfNeeded()
            
        }) { _ in
            
            self.wbImageView.image = UIImage()
            self.wbBackgroundView.removeFromSuperview()
            self.wbView.removeFromSuperview()
            self.wbView.isHidden = true

            self.wbUP = false
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func yesToProposalPressed(_ sender: UIButton!)
    {
        if(isMe)
        {
            let givenID: String = (sender.titleLabel?.text)!
            
            db.child("connections/\(idInfo!)/message_list/\(givenID)").observeSingleEvent(of: .value) { snap in
                if let value = snap.value
                {
                    let dictionary = value as! [String: Any]
                    let originalData = dictionary["message"] as? String
                    let sepParts = originalData!.split(separator: "|")
                    let newData: String = "\(sepParts[0])|\(sepParts[1])|\(sepParts[2])|\(sepParts[3])|accepted|\(sepParts[5])|\(sepParts[6])"
                    self.db.child("connections/\(self.idInfo!)/message_list/\(givenID)/message").setValue(newData)
                    
                    self.db.child("users/\(userEmail!)/sessions/\(sepParts[3])").setValue(newData)
                    self.db.child("users/\(sepParts[5])/sessions/\(sepParts[3])").setValue(newData)
                    
                    self.loadMessages(id: self.idInfo!)
                }
            }
        }
    }
    
    @objc func noToProposalPressed(_ sender: UIButton!)
    {
        if(isMe)
        {
        
            let givenID: String = (sender.titleLabel?.text)!
            
            db.child("connections/\(idInfo!)/message_list/\(givenID)").observeSingleEvent(of: .value) { snap in
                if let value = snap.value
                {
                    let dictionary = value as! [String: Any]
                    let originalData = dictionary["message"] as? String
                    let sepParts = originalData!.split(separator: "|")
                    let newData: String = "\(sepParts[0])|\(sepParts[1])|\(sepParts[2])|\(sepParts[3])|declined|\(sepParts[5])|\(sepParts[6])"
                    self.db.child("connections/\(self.idInfo!)/message_list/\(givenID)/message").setValue(newData)
                    
                    self.loadMessages(id: self.idInfo!)
                    
                }
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
    
    func returnColor(hue: CGFloat) -> CGColor
    {
        if(hue != 0.0 && hue != 1.0)
        {
            return UIColor(hue: hue, saturation: 1.0, brightness: 1.0, alpha: 1.0).cgColor
        } else if(hue == 0.0)
        {
            return UIColor.white.cgColor
        } else
        {
            return UIColor.black.cgColor
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
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.wbBackgroundView
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

extension CGPoint
{
    func isInRect(rect: CGRect) -> Bool
    {
        if(self.x >= rect.minX && self.x <= rect.maxX && self.y >= rect.minY && self.y <= rect.maxY)
        {
            return true
        } else
        {
            return false
        }
    }
}
