//
//  HomeViewController.swift
//  Dualong
//
//  Created by Nolan Bridges on 7/25/20.
//  Copyright © 2020 NiMBLe Interactive. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseDatabase

class HomeViewController: UIViewController
{
    
    let st = Storage.storage().reference()
    let db = Database.database().reference()
    
    var isMe: Bool = true
    
    var loadCircle = UIView()
    var circle = UIBezierPath()
    var displayLink: CADisplayLink!
    var shapeLayer: CAShapeLayer!
    var time = CACurrentMediaTime()
    var ogtime = CACurrentMediaTime()
    
    var SV: UIScrollView = UIScrollView()
    var sStackView: UIStackView = UIStackView()
    
    var isOnDashboard: Bool = false

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        if(isMe)
        {
            let homecloseTap = UITapGestureRecognizer(target: self, action: #selector(closeMenu))
            homecloseTap.cancelsTouchesInView = false
            view.addGestureRecognizer(homecloseTap)
            
            setupLoadCircle()
            displayLink = CADisplayLink(target: self, selector: #selector(loadAnimations))
            displayLink.add(to: RunLoop.main, forMode: .default)
            
            isOnDashboard = true
            
            instantiateDashboard()
            
            NotificationCenter.default.addObserver(self, selector: #selector(loggingOut(notification:)), name: Notification.Name("logOut"), object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(toHomeNotiFunc(notification:)), name: Notification.Name("toHomeNoti"), object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(awayFromDash(notification:)), name: Notification.Name("toConnectionsNoti"), object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(awayFromDash(notification:)), name: Notification.Name("toProfileNoti"), object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(awayFromDash(notification:)), name: Notification.Name("toExploreNoti"), object: nil)
        }
        
    }
    
    func loadDashboard()
    {
        sStackView.isHidden = true
        loadCircle.isHidden = false
        self.view.bringSubviewToFront(loadCircle)
        
        sStackView.subviews.forEach { vieww in
            sStackView.removeArrangedSubview(vieww)
        }
        
        self.addStatView()
        
        db.child("users/\(userEmail!)/sessions").observeSingleEvent(of: .value) { (datasnap) in
            if let children = datasnap.children.allObjects as? [DataSnapshot]
            {
                if(children.count > 0)
                {
                    var cou: Int = 0
                    var couOffset: Int = 0
                    for child in children
                    {
                        let actCOU = Int(cou)
                        let DaTa = child.value as? String
                        
                        let dataSubTwo: String = "\(DaTa!.dropFirst(2))"
                        let dataParts: [Substring] = dataSubTwo.split(separator: "|")
                        let oNE = "\(dataParts[0])"
                        let tWO = "\(dataParts[1])"
                        let tempDATE = oNE.split(separator: "-")
                        let tempTIME = tWO.split(separator: ":")
                        
                        let date = Date()
                        var calendar = Calendar.current
                        calendar.timeZone = TimeZone(abbreviation: "PDT")!
                        let year = calendar.component(.year, from: date)
                        let month = calendar.component(.month, from: date)
                        let day = calendar.component(.day, from: date)
                        let hour = calendar.component(.hour, from: date)
                        let minutes = calendar.component(.minute, from: date)
                        let seconds = calendar.component(.second, from: date)
                        
                        if(Int(year) > Int(tempDATE[0])!)
                        {
                            couOffset += 1
                        } else if(Int(year) == Int(tempDATE[0])!)
                        {
                            if(Int(month) > Int(tempDATE[1])!)
                            {
                                couOffset += 1
                            } else if(Int(month) == Int(tempDATE[1])!)
                            {
                                if(Int(day) > Int(tempDATE[2])!)
                                {
                                    couOffset += 1
                                } else if(Int(day) == Int(tempDATE[2])!)
                                {
                                    if(Int(hour) > Int(tempTIME[0])!)
                                    {
                                        couOffset += 1
                                    } else if(Int(hour) == Int(tempTIME[0])!)
                                    {
                                        if(Int(minutes) > Int(tempTIME[1])!)
                                        {
                                            couOffset += 1
                                        } else if(Int(minutes) == Int(tempTIME[1])!)
                                        {
                                            if(Int(seconds) >= Int(tempTIME[2])!)
                                            {
                                                couOffset += 1
                                            } else
                                            {
                                                self.createNewSessionStack(cc: actCOU, data: DaTa!, offset: couOffset)
                                            }
                                        } else
                                        {
                                            self.createNewSessionStack(cc: actCOU, data: DaTa!, offset: couOffset)
                                        }
                                    } else
                                    {
                                        self.createNewSessionStack(cc: actCOU, data: DaTa!, offset: couOffset)
                                    }
                                } else
                                {
                                    self.createNewSessionStack(cc: actCOU, data: DaTa!, offset: couOffset)
                                }
                            } else
                            {
                                self.createNewSessionStack(cc: actCOU, data: DaTa!, offset: couOffset)
                            }
                        } else
                        {
                            self.createNewSessionStack(cc: actCOU, data: DaTa!, offset: couOffset)
                        }
                        cou += 1
                    }
                    if(cou == couOffset)
                    {
                        self.addNoTutoringSessionPopup()
                    }
                } else
                {
                    self.addNoTutoringSessionPopup()
                }

                self.loadCircle.isHidden = true
            } else
            {
                self.loadCircle.isHidden = true
            }
        }
        
        self.view.layoutIfNeeded()
        
        sStackView.isHidden = false
        
        self.view.layoutIfNeeded()
        
    }
    
    func createNewSessionStack(cc: Int, data: String, offset: Int)
    {
        let dataSubTwo: String = "\(data.dropFirst(2))"
        let dataParts: [Substring] = dataSubTwo.split(separator: "|")
        let oNE = "\(dataParts[0])"
        let tWO = "\(dataParts[1])"
        let tempDATE = oNE.split(separator: "-")
        let tempTIME = tWO.split(separator: ":")
        let tempSUBJECT = "\(dataParts[2])"
        let tempID = "\(dataParts[3])"
        let _ = tempID
        let tempSENDER = "\(dataParts[5])"
        let tempRECEIVER = "\(dataParts[6])"
        let viewWidth = UIScreen.main.bounds.width - 50.0
        let subHeight = tempSUBJECT.heightWithConstrainedWidth(width: viewWidth, font: UIFont(name: "HelveticaNeue", size: 25.0)!) + 1.0
        let viewHeight = 94.0 + subHeight
        var timeMOD: String = "AM"
        if(Int("\(tempTIME[0])")! > 11 && Int("\(tempTIME[0])")! < 24)
        {
            timeMOD = "PM"
        }
        let monthsOfYear: [String]! = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
        let timeTEXT: String = "\(monthsOfYear[Int("\(tempDATE[1])")! - 1]) \(tempDATE[2]), \(tempDATE[0]) at \((Int("\(tempTIME[0])")!) % 12):\(tempTIME[1]) \(timeMOD)"
        
        let sessionView: UIView = UIView()
        sessionView.translatesAutoresizingMaskIntoConstraints = false
        sessionView.removeConstraints(sessionView.constraints)
        sessionView.heightAnchor.constraint(equalToConstant: viewHeight).isActive = true
        sessionView.backgroundColor = UIColor(displayP3Red: 116.0 / 255.0, green: 114.0 / 255.0, blue: 233.0 / 255.0, alpha: 1)
        sessionView.layer.cornerRadius = 20.0
        
        let postLabel: UILabel = UILabel()
        postLabel.translatesAutoresizingMaskIntoConstraints = false
        postLabel.removeConstraints(postLabel.constraints)
        sessionView.addSubview(postLabel)
        postLabel.trailingAnchor.constraint(equalTo: sessionView.trailingAnchor, constant: -20.0).isActive = true
        postLabel.leadingAnchor.constraint(equalTo: sessionView.leadingAnchor, constant: 20.0).isActive = true
        postLabel.topAnchor.constraint(equalTo: sessionView.topAnchor, constant: 15.0).isActive = true
        postLabel.bottomAnchor.constraint(equalTo: sessionView.topAnchor, constant: 15.0 + subHeight).isActive = true
        postLabel.text = tempSUBJECT
        postLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 25.0)
        postLabel.textColor = UIColor.white
        postLabel.lineBreakMode = .byWordWrapping
        postLabel.numberOfLines = 0
        postLabel.textAlignment = .left
        
        let postBottomLabel: UILabel = UILabel()
        postBottomLabel.translatesAutoresizingMaskIntoConstraints = false
        postBottomLabel.removeConstraints(postBottomLabel.constraints)
        sessionView.addSubview(postBottomLabel)
        postBottomLabel.trailingAnchor.constraint(equalTo: sessionView.trailingAnchor, constant: -20.0).isActive = true
        postBottomLabel.leadingAnchor.constraint(equalTo: sessionView.leadingAnchor, constant: 20.0).isActive = true
        postBottomLabel.topAnchor.constraint(equalTo: sessionView.topAnchor, constant: 21.0 + subHeight).isActive = true
        postBottomLabel.bottomAnchor.constraint(equalTo: sessionView.topAnchor, constant: 45.0 + subHeight).isActive = true
        postBottomLabel.text = timeTEXT
        postBottomLabel.font = UIFont(name: "HelveticaNeue", size: 20.0)
        postBottomLabel.textColor = UIColor.white
        postBottomLabel.lineBreakMode = .byWordWrapping
        postBottomLabel.numberOfLines = 0
        postBottomLabel.textAlignment = .left
        
        let veryBotLabel: UILabel = UILabel()
        veryBotLabel.translatesAutoresizingMaskIntoConstraints = false
        veryBotLabel.removeConstraints(veryBotLabel.constraints)
        sessionView.addSubview(veryBotLabel)
        veryBotLabel.trailingAnchor.constraint(equalTo: sessionView.trailingAnchor, constant: -20.0).isActive = true
        veryBotLabel.leadingAnchor.constraint(equalTo: sessionView.leadingAnchor, constant: 20.0).isActive = true
        veryBotLabel.topAnchor.constraint(equalTo: sessionView.topAnchor, constant: 53.0 + subHeight).isActive = true
        veryBotLabel.bottomAnchor.constraint(equalTo: sessionView.topAnchor, constant: 74.0 + subHeight).isActive = true
        if(tempSENDER == userEmail!)
        {
            if(role == "Tutor or Teacher")
            {
                veryBotLabel.text = "Tutoring: loading..."
                db.child("users/\(tempRECEIVER)/name").observeSingleEvent(of: .value) { namesnap in
                    if let value = namesnap.value
                    {
                        veryBotLabel.text = "Tutoring \((value as? String)!)"
                    }
                }
            } else if(role == "Student, Learner, or Parent")
            {
                veryBotLabel.text = "Learning from: loading..."
                db.child("users/\(tempRECEIVER)/name").observeSingleEvent(of: .value) { namesnap in
                    if let value = namesnap.value
                    {
                        veryBotLabel.text = "Learning from \((value as? String)!)"
                    }
                }
            }
        } else
        {
            if(role == "Tutor or Teacher")
            {
                veryBotLabel.text = "Tutoring: loading..."
                db.child("users/\(tempSENDER)/name").observeSingleEvent(of: .value) { namesnap in
                    if let value = namesnap.value
                    {
                        veryBotLabel.text = "Tutoring \((value as? String)!)"
                    }
                }
            } else if(role == "Student, Learner, or Parent")
            {
                veryBotLabel.text = "Learning from: loading..."
                db.child("users/\(tempSENDER)/name").observeSingleEvent(of: .value) { namesnap in
                    if let value = namesnap.value
                    {
                        veryBotLabel.text = "Learning from \((value as? String)!)"
                    }
                }
            }
        }
        veryBotLabel.font = UIFont(name: "HelveticaNeue-Light", size: 17.0)
        veryBotLabel.textColor = UIColor.white
        veryBotLabel.lineBreakMode = .byWordWrapping
        veryBotLabel.numberOfLines = 0
        veryBotLabel.textAlignment = .left
        
        sStackView.insertArrangedSubview(sessionView, at: cc + 2 - offset)
        
        self.view.layoutIfNeeded()
    }
    
    @objc func toHomeNotiFunc(notification: NSNotification)
    {
        if(!isOnDashboard && isMe)
        {
            isOnDashboard = true
            loadDashboard()
        }
    }
    
    @objc func awayFromDash(notification: NSNotification)
    {
        if(isMe)
        {
            isOnDashboard = false
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
    
    func addStatView()
    {
        let statsView: UIView = UIView()
        statsView.translatesAutoresizingMaskIntoConstraints = false
        statsView.removeConstraints(statsView.constraints)
        statsView.heightAnchor.constraint(equalToConstant: 225.0).isActive = true
        sStackView.insertArrangedSubview(statsView, at: 0)
        statsView.backgroundColor = UIColor(displayP3Red: 116.0 / 255.0, green: 114.0 / 255.0, blue: 233.0 / 255.0, alpha: 1)
        statsView.layer.cornerRadius = 20.0
        
        let statsLabel: UILabel = UILabel()
        statsLabel.translatesAutoresizingMaskIntoConstraints = false
        statsLabel.removeConstraints(statsLabel.constraints)
        statsView.addSubview(statsLabel)
        statsLabel.leadingAnchor.constraint(equalTo: statsView.leadingAnchor, constant: 20.0).isActive = true
        statsLabel.trailingAnchor.constraint(equalTo: statsView.trailingAnchor, constant: -20.0).isActive = true
        statsLabel.topAnchor.constraint(equalTo: statsView.topAnchor, constant: 15.0).isActive = true
        statsLabel.bottomAnchor.constraint(equalTo: statsView.topAnchor, constant: 41.0).isActive = true
        statsLabel.text = "Your Stats"
        statsLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 25.0)
        statsLabel.textColor = UIColor.white
        statsLabel.textAlignment = .left
        
        let connectionsNum: UILabel = UILabel()
        connectionsNum.translatesAutoresizingMaskIntoConstraints = false
        connectionsNum.removeConstraints(connectionsNum.constraints)
        statsView.addSubview(connectionsNum)
        connectionsNum.leadingAnchor.constraint(equalTo: statsView.leadingAnchor, constant: 20.0).isActive = true
        connectionsNum.trailingAnchor.constraint(equalTo: statsView.trailingAnchor, constant: -20.0).isActive = true
        connectionsNum.topAnchor.constraint(equalTo: statsView.topAnchor, constant: 50.0).isActive = true
        connectionsNum.bottomAnchor.constraint(equalTo: statsView.topAnchor, constant: 100.0).isActive = true
        connectionsNum.text = "loading..."
        db.child("users/\(userEmail!)/connections").observeSingleEvent(of: .value) { (SNAP) in
            if let childrenq = SNAP.children.allObjects as? [DataSnapshot]
            {
                for childq in childrenq
                {
                    connections["\(childq.key)"] = (childq.value as? String)!
                }
                connectionsNum.text = "\(connections.count)"
                connectionsNum.font = UIFont(name: "HelveticaNeue", size: 50.0)
            }
        }
        connectionsNum.font = UIFont(name: "HelveticaNeue", size: 30.0)
        connectionsNum.textColor = UIColor.white
        connectionsNum.textAlignment = .center
        connectionsNum.layer.borderColor = UIColor.white.cgColor
        connectionsNum.layer.borderWidth = 0.0
        
        let connectionsLabel: UILabel = UILabel()
        connectionsLabel.translatesAutoresizingMaskIntoConstraints = false
        connectionsLabel.removeConstraints(connectionsLabel.constraints)
        statsView.addSubview(connectionsLabel)
        connectionsLabel.leadingAnchor.constraint(equalTo: statsView.leadingAnchor, constant: 20.0).isActive = true
        connectionsLabel.trailingAnchor.constraint(equalTo: statsView.trailingAnchor, constant: -20.0).isActive = true
        connectionsLabel.topAnchor.constraint(equalTo: statsView.topAnchor, constant: 100.0).isActive = true
        connectionsLabel.bottomAnchor.constraint(equalTo: statsView.topAnchor, constant: 120.0).isActive = true
        connectionsLabel.text = "connections"
        connectionsLabel.font = UIFont(name: "HelveticaNeue", size: 20.0)
        connectionsLabel.textColor = UIColor.white
        connectionsLabel.textAlignment = .center
        connectionsLabel.layer.borderColor = UIColor.white.cgColor
        connectionsLabel.layer.borderWidth = 0.0
        
        let pastSessNum: UILabel = UILabel()
        pastSessNum.translatesAutoresizingMaskIntoConstraints = false
        pastSessNum.removeConstraints(pastSessNum.constraints)
        statsView.addSubview(pastSessNum)
        pastSessNum.leadingAnchor.constraint(equalTo: statsView.leadingAnchor, constant: 20.0).isActive = true
        pastSessNum.trailingAnchor.constraint(equalTo: statsView.trailingAnchor, constant: -20.0).isActive = true
        pastSessNum.topAnchor.constraint(equalTo: statsView.topAnchor, constant: 135.0).isActive = true
        pastSessNum.bottomAnchor.constraint(equalTo: statsView.topAnchor, constant: 185.0).isActive = true
        pastSessNum.text = "loading..."
        db.child("users/\(userEmail!)/sessions").observeSingleEvent(of: .value) { (datasnap) in
            if let children = datasnap.children.allObjects as? [DataSnapshot]
            {
                if(children.count > 0)
                {
                    var couOffset: Int = 0
                    for child in children
                    {
                        let DaTa = child.value as? String
                        
                        let dataSubTwo: String = "\(DaTa!.dropFirst(2))"
                        let dataParts: [Substring] = dataSubTwo.split(separator: "|")
                        let oNE = "\(dataParts[0])"
                        let tWO = "\(dataParts[1])"
                        let tempDATE = oNE.split(separator: "-")
                        let tempTIME = tWO.split(separator: ":")
                        
                        let date = Date()
                        var calendar = Calendar.current
                        calendar.timeZone = TimeZone(abbreviation: "PDT")!
                        let year = calendar.component(.year, from: date)
                        let month = calendar.component(.month, from: date)
                        let day = calendar.component(.day, from: date)
                        let hour = calendar.component(.hour, from: date)
                        let minutes = calendar.component(.minute, from: date)
                        let seconds = calendar.component(.second, from: date)
                        
                        if(Int(year) > Int(tempDATE[0])!)
                        {
                            couOffset += 1
                        } else if(Int(year) == Int(tempDATE[0])!)
                        {
                            if(Int(month) > Int(tempDATE[1])!)
                            {
                                couOffset += 1
                            } else if(Int(month) == Int(tempDATE[1])!)
                            {
                                if(Int(day) > Int(tempDATE[2])!)
                                {
                                    couOffset += 1
                                } else if(Int(day) == Int(tempDATE[2])!)
                                {
                                    if(Int(hour) > Int(tempTIME[0])!)
                                    {
                                        couOffset += 1
                                    } else if(Int(hour) == Int(tempTIME[0])!)
                                    {
                                        if(Int(minutes) > Int(tempTIME[1])!)
                                        {
                                            couOffset += 1
                                        } else if(Int(minutes) == Int(tempTIME[1])!)
                                        {
                                            if(Int(seconds) >= Int(tempTIME[2])!)
                                            {
                                                couOffset += 1
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    pastSessNum.text = "\(couOffset)"
                    pastSessNum.font = UIFont(name: "HelveticaNeue", size: 50.0)
                }
            }
        }
        pastSessNum.font = UIFont(name: "HelveticaNeue", size: 30.0)
        pastSessNum.textColor = UIColor.white
        pastSessNum.textAlignment = .center
        pastSessNum.layer.borderColor = UIColor.white.cgColor
        pastSessNum.layer.borderWidth = 0.0
        
        let pastSessLabel: UILabel = UILabel()
        pastSessLabel.translatesAutoresizingMaskIntoConstraints = false
        pastSessLabel.removeConstraints(pastSessLabel.constraints)
        statsView.addSubview(pastSessLabel)
        pastSessLabel.leadingAnchor.constraint(equalTo: statsView.leadingAnchor, constant: 20.0).isActive = true
        pastSessLabel.trailingAnchor.constraint(equalTo: statsView.trailingAnchor, constant: -20.0).isActive = true
        pastSessLabel.topAnchor.constraint(equalTo: statsView.topAnchor, constant: 185.0).isActive = true
        pastSessLabel.bottomAnchor.constraint(equalTo: statsView.topAnchor, constant: 205.0).isActive = true
        pastSessLabel.text = "past tutoring sessions"
        pastSessLabel.font = UIFont(name: "HelveticaNeue", size: 20.0)
        pastSessLabel.textColor = UIColor.white
        pastSessLabel.textAlignment = .center
        
        let upcomingView: UIView = UIView()
        upcomingView.translatesAutoresizingMaskIntoConstraints = false
        upcomingView.removeConstraints(upcomingView.constraints)
        sStackView.insertArrangedSubview(upcomingView, at: 1)
        let upcomingViewText: String = "Upcoming tutoring sessions"
        let upcomingViewHeight = upcomingViewText.heightWithConstrainedWidth(width: UIScreen.main.bounds.width - 50.0, font: UIFont(name: "HelveticaNeue-Bold", size: 30.0)!) + 10.0
        upcomingView.heightAnchor.constraint(equalToConstant: upcomingViewHeight).isActive = true
        
        let upcomingLabel: UILabel = UILabel()
        upcomingLabel.translatesAutoresizingMaskIntoConstraints = false
        upcomingLabel.removeConstraints(upcomingLabel.constraints)
        upcomingView.addSubview(upcomingLabel)
        upcomingLabel.leadingAnchor.constraint(equalTo: upcomingView.leadingAnchor, constant: 15.0).isActive = true
        upcomingLabel.trailingAnchor.constraint(equalTo: upcomingView.trailingAnchor, constant: -15.0).isActive = true
        upcomingLabel.topAnchor.constraint(equalTo: upcomingView.topAnchor).isActive = true
        upcomingLabel.bottomAnchor.constraint(equalTo: upcomingView.bottomAnchor).isActive = true
        upcomingLabel.text = "Upcoming tutoring sessions"
        upcomingLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 30.0)
        upcomingLabel.numberOfLines = 0
        upcomingLabel.lineBreakMode = .byWordWrapping
        upcomingLabel.textColor = UIColor.white
        upcomingLabel.textAlignment = .left
    }
    
    func addNoTutoringSessionPopup()
    {
        let upcomingView: UIView = UIView()
        upcomingView.translatesAutoresizingMaskIntoConstraints = false
        upcomingView.removeConstraints(upcomingView.constraints)
        sStackView.addArrangedSubview(upcomingView)
        var upcomingViewText: String = ""
        if(role == "Tutor or Teacher")
        {
            upcomingViewText = "You have no upcoming tutoring sessions. Go to the explore tab to create connections with learners who have requested tutoring"
        } else
        {
            upcomingViewText = "You have no upcoming tutoring sessions. Go to the explore tab to put out a tutoring request or find a tutor"
        }
        
        let upcomingViewHeight = upcomingViewText.heightWithConstrainedWidth(width: UIScreen.main.bounds.width - 50.0, font: UIFont(name: "HelveticaNeue", size: 20.0)!) + 10.0
        upcomingView.heightAnchor.constraint(equalToConstant: upcomingViewHeight).isActive = true
        
        let upcomingLabel: UILabel = UILabel()
        upcomingLabel.translatesAutoresizingMaskIntoConstraints = false
        upcomingLabel.removeConstraints(upcomingLabel.constraints)
        upcomingView.addSubview(upcomingLabel)
        upcomingLabel.leadingAnchor.constraint(equalTo: upcomingView.leadingAnchor, constant: 20.0).isActive = true
        upcomingLabel.trailingAnchor.constraint(equalTo: upcomingView.trailingAnchor, constant: -20.0).isActive = true
        upcomingLabel.topAnchor.constraint(equalTo: upcomingView.topAnchor).isActive = true
        upcomingLabel.bottomAnchor.constraint(equalTo: upcomingView.bottomAnchor).isActive = true
        upcomingLabel.text = upcomingViewText
        upcomingLabel.font = UIFont(name: "HelveticaNeue", size: 20.0)
        upcomingLabel.numberOfLines = 0
        upcomingLabel.lineBreakMode = .byWordWrapping
        upcomingLabel.textColor = UIColor.white
        upcomingLabel.alpha = 0.6
        upcomingLabel.textAlignment = .center
        
        self.view.layoutIfNeeded()
    }
    
    func instantiateDashboard()
    {
        SV = UIScrollView()
        SV.translatesAutoresizingMaskIntoConstraints = false
        SV.removeConstraints(SV.constraints)
        self.view.addSubview(SV)
        SV.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 5.0).isActive = true
        SV.trailingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: UIScreen.main.bounds.width - 5.0).isActive = true
        SV.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 105.0).isActive = true
        SV.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -5.0).isActive = true
        
        sStackView = UIStackView()
        sStackView.translatesAutoresizingMaskIntoConstraints = false
        sStackView.removeConstraints(sStackView.constraints)
        SV.addSubview(sStackView)
        sStackView.axis = .vertical
        sStackView.alignment = .fill
        sStackView.distribution = .fill
        sStackView.spacing = 5.0
        sStackView.leadingAnchor.constraint(equalTo: SV.contentLayoutGuide.leadingAnchor).isActive = true
        sStackView.trailingAnchor.constraint(equalTo: SV.contentLayoutGuide.trailingAnchor).isActive = true
        sStackView.topAnchor.constraint(equalTo: SV.contentLayoutGuide.topAnchor).isActive = true
        sStackView.bottomAnchor.constraint(equalTo: SV.contentLayoutGuide.bottomAnchor).isActive = true
        sStackView.widthAnchor.constraint(equalTo: SV.frameLayoutGuide.widthAnchor).isActive = true
        sStackView.subviews.forEach { vieww in
            sStackView.removeArrangedSubview(vieww)
        }
        
        sStackView.isHidden = true
        
        loadDashboard()
        
        self.view.layoutIfNeeded()
    }
    
    @objc func closeMenu()
    {
        if(menuToggle && isMe)
        {
            NotificationCenter.default.post(name: Notification.Name("closeMenuTab"), object: nil)
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool
    {
        let isControllTapped = touch.view is UIControl
        return !isControllTapped
    }
    
    @objc func loggingOut(notification: NSNotification)
    {
        if(isMe)
        {
            isMe = false
        }
    }
}
