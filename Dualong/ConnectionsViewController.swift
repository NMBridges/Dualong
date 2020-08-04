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

class ConnectionsViewController: UIViewController
{
    let st = Storage.storage().reference()
    let db = Database.database().reference()
    var isMe: Bool = true
    
    var SV: UIScrollView = UIScrollView()
    var stackView: UIStackView = UIStackView()
    
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

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        if(isMe)
        {
            let conncloseTap = UITapGestureRecognizer(target: self, action: #selector(closeMenu))
            conncloseTap.cancelsTouchesInView = false
            view.addGestureRecognizer(conncloseTap)
            
            instantiateScrollView()
            
            NotificationCenter.default.addObserver(self, selector: #selector(loggingOut(notification:)), name: Notification.Name("logOut"), object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(loadConnectionsNoti(notification:)), name: Notification.Name("toConnectionsNoti"), object: nil)
        }
        
    }
    
    func addStackViewMember(cc: Int)
    {
        let VIEW = UIView()
        let BUTTON = UIButton()
        let LABEL = UILabel()
        let IMAGEVIEW = UIImageView()
        let barHeight = CGFloat(100.0)
        
        VIEW.translatesAutoresizingMaskIntoConstraints = false
        VIEW.removeConstraints(VIEW.constraints)
        stackView.addArrangedSubview(VIEW)
        VIEW.heightAnchor.constraint(equalToConstant: barHeight).isActive = true
        VIEW.layer.cornerRadius = UIScreen.main.bounds.width * 0.03
        VIEW.backgroundColor = UIColor.red
        
        BUTTON.translatesAutoresizingMaskIntoConstraints = false
        BUTTON.removeConstraints(BUTTON.constraints)
        VIEW.addSubview(BUTTON)
        BUTTON.leadingAnchor.constraint(equalTo: VIEW.leadingAnchor).isActive = true
        BUTTON.trailingAnchor.constraint(equalTo: VIEW.trailingAnchor).isActive = true
        BUTTON.topAnchor.constraint(equalTo: VIEW.topAnchor).isActive = true
        BUTTON.bottomAnchor.constraint(equalTo: VIEW.bottomAnchor).isActive = true
        BUTTON.backgroundColor = UIColor.clear
        BUTTON.setTitle("\(cc)", for: .normal)
        BUTTON.setTitleColor(UIColor.clear, for: .normal)
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
        
        for q in 0...(itemOrder.count - 1)
        {
            addStackViewMember(cc: q)
        }
        
    }
    
    func loadConnections()
    {
        stackView.subviews.forEach { subview in
            stackView.removeArrangedSubview(subview)
        }
        
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
        }
        
        // creating arrays with values, then sorting, then adding to stack view
        
        var PP: Int = 0
        let optLeng = connections.count
        
        for (key, value) in connections
        {
            
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
        
        stackView = UIStackView()
        SV.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.removeConstraints(stackView.constraints)
        stackView.leadingAnchor.constraint(equalTo: SV.contentLayoutGuide.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: SV.contentLayoutGuide.trailingAnchor).isActive = true
        stackView.topAnchor.constraint(equalTo: SV.contentLayoutGuide.topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: SV.contentLayoutGuide.bottomAnchor).isActive = true
        stackView.widthAnchor.constraint(equalTo: SV.frameLayoutGuide.widthAnchor).isActive = true
        stackView.spacing = 5.0
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.axis = .vertical
    }
    
    @objc func closeMenu()
    {
        if(menuToggle && isMe)
        {
            NotificationCenter.default.post(name: Notification.Name("closeMenuTab"), object: nil)
        }
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
