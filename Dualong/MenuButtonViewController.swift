//
//  MenuButtonViewController.swift
//  Dualong
//
//  Created by Nolan Bridges on 7/26/20.
//  Copyright © 2020 NiMBLe Interactive. All rights reserved.
//

import UIKit


var menuToggle: Bool = false

class MenuButtonViewController: UIViewController
{
    
    @IBOutlet weak var uploadBarRef: UIProgressView!
    
    @IBOutlet weak var uploadingTextRef: UILabel!
    
    @IBOutlet weak var buttonImageRef: UIImageView!
    
    @IBOutlet weak var buttonRef: UIButton!
    
    @IBOutlet weak var homeContainerView: UIView!
    
    @IBOutlet weak var connectionsContainerView: UIView!
    
    @IBOutlet weak var logOutButtonRef: UIButton!
    
    @IBOutlet weak var exploreContainerView: UIView!
    
    @IBOutlet weak var profileContainerView: UIView!
    
    let viewWid = UIScreen.main.bounds.width
    let viewHei = UIScreen.main.bounds.height
    var barOffset: CGFloat = 0
    var menuPOS: Double = 0.3
    var instantiatedSubview: Bool = false
    var menuONCE: Bool = true
    var CLOSING: Bool = false
    
    var menuVC: MenuViewController = MenuViewController()
    
    var homeCVR: [NSLayoutConstraint] = []
    var connCVR: [NSLayoutConstraint] = []
    var explCVR: [NSLayoutConstraint] = []
    var profCVR: [NSLayoutConstraint] = []
    var buttCVR: [NSLayoutConstraint] = []
    var buimCVR: [NSLayoutConstraint] = []
    var lobuCVR: [NSLayoutConstraint] = []
    var menuCVR: [NSLayoutConstraint] = []
    
    var menuButtonOpacityToggle: Bool = true

    override func viewDidLoad()
    {
        
        super.viewDidLoad()
        
        homeContainerView.alpha = 1
        connectionsContainerView.alpha = 0
        exploreContainerView.alpha = 0
        profileContainerView.alpha = 0
        
        uploadBarRef.isHidden = true
        uploadingTextRef.isHidden = true
        logOutButtonRef.isHidden = true
        
        setupConstraints()
        if(menuONCE)
        {
            
            menuONCE = false
        }
            
        if(!instantiatedSubview)
        {
            menuVC = (storyboard?.instantiateViewController(identifier: "MenuScene"))!
            menuVC.view.frame = CGRect(x: -viewWid * CGFloat(menuPOS), y: 0, width: viewWid * CGFloat(menuPOS), height: viewHei)
            //menuVC.view.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(menuVC.view)
            /*menuVC.view.removeConstraints(menuVC.view.constraints)
            menuCVR = []
            menuCVR.append(menuVC.view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0.0))
            menuCVR[0].isActive = false
            menuCVR.append(menuVC.view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0.0))
            menuCVR[1].isActive = false
            menuCVR.append(menuVC.view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: -viewWid * CGFloat(menuPOS)))
            menuCVR[2].isActive = true
            menuCVR.append(menuVC.view.trailingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0.0))
            menuCVR[3].isActive = true
            menuVC.view.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0.0).isActive = true
            menuVC.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0.0).isActive = true*/
            
            menuVC.view.isHidden = true
            instantiatedSubview = true
        }
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.toHome(notification:)), name: Notification.Name("toHomeNoti"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.toConnections(notification:)), name: Notification.Name("toConnectionsNoti"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.toExplore(notification:)), name: Notification.Name("toExploreNoti"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.toProfile(notification:)), name: Notification.Name("toProfileNoti"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.uploadBar(notification:)), name: Notification.Name("uploadBar"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(uploadBarComplete(notification:)), name: Notification.Name("uploadBarComplete"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(uploadBarStart(notification:)), name: Notification.Name("uploadBarStart"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(closeMenuTab(notification:)), name: Notification.Name("closeMenuTab"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(openMenuTab(notification:)), name: Notification.Name("openMenuTab"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(logOut(notification:)), name: Notification.Name("logOut"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(setEmail(notification:)), name: .signedin, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(menuTabClosed(notification:)), name: Notification.Name("menuTabClosed"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(toggleMenuOpacity(notification:)), name: Notification.Name("toggleMenuOpacity"), object: nil)
        
        
    }
    
    @objc func setEmail(notification: NSNotification)
    {
        homeContainerView.alpha = 1
        connectionsContainerView.alpha = 0
        exploreContainerView.alpha = 0
        profileContainerView.alpha = 0
        
        uploadBarRef.isHidden = true
        uploadingTextRef.isHidden = true
        

        menuVC.view.isHidden = true
    }
    
    @IBAction func menuPressed(_ sender: UIButton)
    {
        
        toggleMenuFunc()
        
    }
    
    @objc func openMenuTab(notification: NSNotification)
    {
        if(!menuToggle)
        {
            toggleMenuFunc()
        }
    }
    
    func toggleMenuFunc()
    {
        view.endEditing(true)
        
        logOutButtonRef.isHidden = menuToggle
        
        menuToggle = !menuToggle
        
        menuVC.view.isHidden = false
        
        barOffset = viewWid * CGFloat(menuPOS) - barOffset
        
        
        self.view.bringSubviewToFront(logOutButtonRef)
        
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations:
            {
                if(menuToggle)
                {
                    self.buttCVR[0].isActive = false
                    self.buimCVR[0].isActive = false
                    self.lobuCVR[0].isActive = false
                    self.homeCVR[0].isActive = false
                    self.connCVR[0].isActive = false
                    self.explCVR[0].isActive = false
                    self.profCVR[0].isActive = false
                    //self.menuCVR[2].isActive = false
                    //self.menuCVR[3].isActive = false
                    
                    self.buttCVR[1].isActive = true
                    self.buimCVR[1].isActive = true
                    self.lobuCVR[1].isActive = true
                    self.homeCVR[1].isActive = true
                    self.connCVR[1].isActive = true
                    self.explCVR[1].isActive = true
                    self.profCVR[1].isActive = true
                    //self.menuCVR[0].isActive = true
                    //self.menuCVR[1].isActive = true
                } else
                {
                    
                    self.buttCVR[1].isActive = false
                    self.buimCVR[1].isActive = false
                    self.lobuCVR[1].isActive = false
                    self.homeCVR[1].isActive = false
                    self.connCVR[1].isActive = false
                    self.explCVR[1].isActive = false
                    self.profCVR[1].isActive = false
                    //self.menuCVR[0].isActive = false
                    //self.menuCVR[1].isActive = false
                    
                    self.buttCVR[0].isActive = true
                    self.buimCVR[0].isActive = true
                    self.lobuCVR[0].isActive = true
                    self.homeCVR[0].isActive = true
                    self.connCVR[0].isActive = true
                    self.explCVR[0].isActive = true
                    self.profCVR[0].isActive = true
                    //self.menuCVR[2].isActive = true
                    //self.menuCVR[3].isActive = true
                }
                
                self.menuVC.view.frame = CGRect(x: -self.viewWid * CGFloat(self.menuPOS) + self.barOffset, y: 0, width: self.viewWid * CGFloat(self.menuPOS), height: self.viewHei)
                
                self.view.layoutIfNeeded()
                
        }, completion: { _ in
            if(self.CLOSING)
            {
                NotificationCenter.default.post(name: Notification.Name("menuTabClosed"), object: nil)
                self.CLOSING = false
            }
            if(!menuToggle)
            {
                self.menuVC.view.isHidden = true
            }
        })
        
    }
    
    func setupConstraints()
    {
        
        homeCVR.removeAll()
        connCVR.removeAll()
        explCVR.removeAll()
        profCVR.removeAll()
        buttCVR.removeAll()
        buimCVR.removeAll()
        lobuCVR.removeAll()
        
        buttonRef.translatesAutoresizingMaskIntoConstraints = false
        buttonImageRef.translatesAutoresizingMaskIntoConstraints = false
        logOutButtonRef.translatesAutoresizingMaskIntoConstraints = false
        homeContainerView.translatesAutoresizingMaskIntoConstraints = false;
        connectionsContainerView.translatesAutoresizingMaskIntoConstraints = false;
        exploreContainerView.translatesAutoresizingMaskIntoConstraints = false;
        profileContainerView.translatesAutoresizingMaskIntoConstraints = false;
        
        buttonRef.removeConstraints(buttonRef.constraints)
        buttonImageRef.removeConstraints(buttonImageRef.constraints)
        logOutButtonRef.removeConstraints(buttonImageRef.constraints)
        homeContainerView.removeConstraints(homeContainerView.constraints)
        connectionsContainerView.removeConstraints(connectionsContainerView.constraints)
        exploreContainerView.removeConstraints(exploreContainerView.constraints)
        profileContainerView.removeConstraints(profileContainerView.constraints)
        
        buttCVR.append(buttonRef.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 0.0))
        buttCVR[0].isActive = true
        buttCVR.append(buttonRef.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: viewWid * CGFloat(menuPOS)))
        buttCVR[1].isActive = false
        buttonRef.widthAnchor.constraint(equalToConstant: 90).isActive = true
        buttonRef.heightAnchor.constraint(equalToConstant: 45.0).isActive = true
        buttonRef.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 0.0).isActive = true
        
        buimCVR.append(buttonImageRef.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 19.0))
        buimCVR[0].isActive = true
        buimCVR.append(buttonImageRef.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 19.0 + viewWid * CGFloat(menuPOS)))
        buimCVR[1].isActive = false
        buttonImageRef.widthAnchor.constraint(equalToConstant: 44.0).isActive = true
        buttonImageRef.heightAnchor.constraint(equalToConstant: 36.0).isActive = true
        buttonImageRef.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 8.0).isActive = true
        
        lobuCVR.append(logOutButtonRef.centerXAnchor.constraint(equalTo: self.view.leadingAnchor, constant: -viewWid * CGFloat(menuPOS) / 2.0))
        lobuCVR[0].isActive = true
        lobuCVR.append(logOutButtonRef.centerXAnchor.constraint(equalTo: self.view.leadingAnchor, constant: viewWid * CGFloat(menuPOS) / 2.0 - 5.0))
        lobuCVR[1].isActive = false
        logOutButtonRef.centerYAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -55.0).isActive = true
        logOutButtonRef.widthAnchor.constraint(equalToConstant: 45.0).isActive = true
        logOutButtonRef.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
        logOutButtonRef.tintColor = UIColor.white
        logOutButtonRef.alpha = 0.35
        
        homeCVR.append(homeContainerView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor))
        homeCVR[0].isActive = true
        homeCVR.append(homeContainerView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: self.viewWid * CGFloat(menuPOS)))
        homeCVR[1].isActive = false
        homeContainerView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        homeContainerView.widthAnchor.constraint(equalToConstant: viewWid).isActive = true
        homeContainerView.heightAnchor.constraint(equalToConstant: viewHei).isActive = true
        
        connCVR.append(connectionsContainerView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor))
        connCVR[0].isActive = true
        connCVR.append(connectionsContainerView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: self.viewWid * CGFloat(menuPOS)))
        connCVR[1].isActive = false
        connectionsContainerView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        connectionsContainerView.widthAnchor.constraint(equalToConstant: viewWid).isActive = true
        connectionsContainerView.heightAnchor.constraint(equalToConstant: viewHei).isActive = true
        
        explCVR.append(exploreContainerView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor))
        explCVR[0].isActive = true
        explCVR.append(exploreContainerView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: self.viewWid * CGFloat(menuPOS)))
        explCVR[1].isActive = false
        exploreContainerView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        exploreContainerView.widthAnchor.constraint(equalToConstant: viewWid).isActive = true
        exploreContainerView.heightAnchor.constraint(equalToConstant: viewHei).isActive = true
        
        profCVR.append(profileContainerView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor))
        profCVR[0].isActive = true
        profCVR.append(profileContainerView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: self.viewWid * CGFloat(menuPOS)))
        profCVR[1].isActive = false
        profileContainerView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        profileContainerView.widthAnchor.constraint(equalToConstant: viewWid).isActive = true
        profileContainerView.heightAnchor.constraint(equalToConstant: viewHei).isActive = true
    }
    
    @objc private func toHome(notification: NSNotification)
    {
        homeContainerView.alpha = 1
        connectionsContainerView.alpha = 0
        exploreContainerView.alpha = 0
        profileContainerView.alpha = 0
        toggleMenuFunc()
    }
    
    @objc private func toConnections(notification: NSNotification)
    {
        homeContainerView.alpha = 0
        connectionsContainerView.alpha = 1
        exploreContainerView.alpha = 0
        profileContainerView.alpha = 0
        toggleMenuFunc()
    }
    
    @objc private func toExplore(notification: NSNotification)
    {
        homeContainerView.alpha = 0
        connectionsContainerView.alpha = 0
        exploreContainerView.alpha = 1
        profileContainerView.alpha = 0
        toggleMenuFunc()
    }
    
    @objc private func toProfile(notification: NSNotification)
    {
        NotificationCenter.default.post(name: Notification.Name("updateProf"), object: nil)
        homeContainerView.alpha = 0
        connectionsContainerView.alpha = 0
        exploreContainerView.alpha = 0
        profileContainerView.alpha = 1
        toggleMenuFunc()
    }
    
    @objc func uploadBarStart(notification: NSNotification)
    {
        self.uploadBarRef.isHidden = false
        self.uploadingTextRef.isHidden = false
        self.uploadBarRef.alpha = 0.0
        self.uploadingTextRef.alpha = 0.0
        UIView.animate(withDuration: 0.3, animations:
        {
            self.uploadBarRef.alpha = 1.0
            self.uploadingTextRef.alpha = 1.0
        }, completion: nil)
    }
    
    @objc func uploadBar(notification: NSNotification)
    {
        uploadBarRef.progress = Float(uploadProgress)
    }
    
    @objc func uploadBarComplete(notification: NSNotification)
    {
        uploadBarRef.progress = 1.0
        UIView.animate(withDuration: 0.3, animations: {
            self.uploadBarRef.alpha = 0.0
            self.uploadingTextRef.alpha = 0.0
        }) { _ in
            self.uploadBarRef.isHidden = true
            self.uploadingTextRef.isHidden = true
            self.uploadBarRef.progress = 0.01
            uploadProgress = 0.01
        }
    }
    
    @objc func closeMenuTab(notification: NSNotification)
    {
        if(menuToggle)
        {
            toggleMenuFunc()
        }
    }
    
    @IBAction func logOutButton(_ sender: UIButton)
    {
        currScene = "Login"
        NotificationCenter.default.post(name: Notification.Name("logOut"), object: nil)
    }
    
    @objc func logOut(notification: NSNotification)
    {
        CLOSING = true
        toggleMenuFunc()
    }
    
    @objc func menuTabClosed(notification: NSNotification)
    {
        
    }
    
    @objc func toggleMenuOpacity(notification: NSNotification)
    {
        var a: CGFloat = 1.0
        if(menuButtonOpacityToggle)
        {
            a = 0.0
        }
        UIView.animate(withDuration: 0.2, animations: {
            self.buttonImageRef.alpha = a
            self.view.layoutIfNeeded()
        }, completion: { _ in
            self.buttonRef.isHidden = self.menuButtonOpacityToggle
            self.menuButtonOpacityToggle = !self.menuButtonOpacityToggle
        })
    }


}

extension Notification.Name
{
    static let toHomeNoti = Notification.Name("toHomeNoti")
    static let toConnectionsNoti = Notification.Name("toConnectionsNoti")
    static let toExploreNoti = Notification.Name("toExploreNoti")
    static let toProfileNoti = Notification.Name("toProfileNoti")
    static let closeMenuTab = Notification.Name("closeMenuTab")
    static let openMenuTab = Notification.Name("openMenuTab")
    static let menuTabClosed = Notification.Name("menuTabClosed")
    static let reloadStackView = Notification.Name("reloadStackView")
    static let expTurnOffLoading = Notification.Name("expTurnOffLoading")
}
