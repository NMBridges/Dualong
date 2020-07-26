//
//  HomeViewController.swift
//  Dualong
//
//  Created by Nolan Bridges on 7/25/20.
//  Copyright © 2020 NiMBLe Interactive. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController
{

    override func viewDidLoad()
    {
        super.viewDidLoad()

        
    }
    
    @IBAction func menuButtonPressed(_ sender: UIBarButtonItem)
    {
        guard let menuViewController = storyboard?.instantiateViewController(withIdentifier: "BarMenuViewController") else { return }
        present(menuViewController, animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
