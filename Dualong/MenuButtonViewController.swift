//
//  MenuButtonViewController.swift
//  Dualong
//
//  Created by Nolan Bridges on 7/26/20.
//  Copyright © 2020 NiMBLe Interactive. All rights reserved.
//

import UIKit

class MenuButtonViewController: UIViewController
{
    
    @IBOutlet weak var buttonRef: UIButton!
    
    @IBOutlet weak var homeContainerView: UIView!
    
    @IBOutlet weak var connectionsContainerView: UIView!
    
    @IBOutlet weak var exploreContainerView: UIView!
    
    @IBOutlet weak var profileContainerView: UIView!
    
    let viewWid = UIScreen.main.bounds.width
    let viewHei = UIScreen.main.bounds.height
    var barOffset: CGFloat = 0
    var instantiatedSubview: Bool = false
    var menuToggle: Bool = false
    var menuPOS: Double = 0.3
    
    var menuVC: MenuViewController = MenuViewController()
    
    var homeCVR: [NSLayoutConstraint] = []
    var connCVR: [NSLayoutConstraint] = []
    var explCVR: [NSLayoutConstraint] = []
    var profCVR: [NSLayoutConstraint] = []
    var buttCVR: [NSLayoutConstraint] = []

    override func viewDidLoad()
    {
        
        super.viewDidLoad()
        
        homeContainerView.alpha = 1
        connectionsContainerView.alpha = 0
        exploreContainerView.alpha = 0
        profileContainerView.alpha = 0
        
        setupConstraints()
        
        if(!instantiatedSubview)
        {
            menuVC = (storyboard?.instantiateViewController(identifier: "MenuScene"))!
            menuVC.view.frame = CGRect(x: -viewWid * CGFloat(menuPOS), y: 0, width: viewWid * CGFloat(menuPOS), height: viewHei)
            self.view.addSubview(menuVC.view)
            menuVC.view.isHidden = true
            instantiatedSubview = true
        }
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.toHome(notification:)), name: Notification.Name("toHomeNoti"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.toConnections(notification:)), name: Notification.Name("toConnectionsNoti"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.toExplore(notification:)), name: Notification.Name("toExploreNoti"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.toProfile(notification:)), name: Notification.Name("toProfileNoti"), object: nil)
        
    }
    
    @IBAction func menuPressed(_ sender: UIButton)
    {
        
        toggleMenuFunc()
        
    }
    
    func toggleMenuFunc()
    {
        
        menuToggle = !menuToggle
        
        menuVC.view.isHidden = false
        
        barOffset = viewWid * CGFloat(menuPOS) - barOffset
        
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations:
            {
                if(self.menuToggle)
                {
                    self.buttCVR[0].isActive = false
                    self.homeCVR[0].isActive = false
                    self.connCVR[0].isActive = false
                    self.explCVR[0].isActive = false
                    self.profCVR[0].isActive = false
                    
                    self.buttCVR[1].isActive = true
                    self.homeCVR[1].isActive = true
                    self.connCVR[1].isActive = true
                    self.explCVR[1].isActive = true
                    self.profCVR[1].isActive = true
                } else
                {
                    
                    self.buttCVR[1].isActive = false
                    self.homeCVR[1].isActive = false
                    self.connCVR[1].isActive = false
                    self.explCVR[1].isActive = false
                    self.profCVR[1].isActive = false
                    
                    self.buttCVR[0].isActive = true
                    self.homeCVR[0].isActive = true
                    self.connCVR[0].isActive = true
                    self.explCVR[0].isActive = true
                    self.profCVR[0].isActive = true
                }
                
                self.menuVC.view.frame = CGRect(x: -self.viewWid * CGFloat(self.menuPOS) + self.barOffset, y: 0, width: self.viewWid * CGFloat(self.menuPOS), height: self.viewHei)
                
                self.view.layoutIfNeeded()
                
        }, completion: nil)
        
    }
    
    func setupConstraints()
    {
        
        buttonRef.translatesAutoresizingMaskIntoConstraints = false
        homeContainerView.translatesAutoresizingMaskIntoConstraints = false;
        connectionsContainerView.translatesAutoresizingMaskIntoConstraints = false;
        exploreContainerView.translatesAutoresizingMaskIntoConstraints = false;
        profileContainerView.translatesAutoresizingMaskIntoConstraints = false;
        
        buttCVR.append(buttonRef.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20.0))
        buttCVR[0].isActive = true
        buttCVR.append(buttonRef.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20.0 + viewWid * CGFloat(menuPOS)))
        buttCVR[1].isActive = false
        buttonRef.widthAnchor.constraint(equalToConstant: 34.0).isActive = true
        buttonRef.heightAnchor.constraint(equalToConstant: 22.0).isActive = true
        buttonRef.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 15.0).isActive = true
        
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

}

extension Notification.Name
{
    static let toHomeNoti = Notification.Name("toHomeNoti")
    static let toConnectionsNoti = Notification.Name("toConnectionsNoti")
    static let toExploreNoti = Notification.Name("toExploreNoti")
    static let toProfileNoti = Notification.Name("toProfileNoti")
    
}
