//
//  ViewController.swift
//  Todolist
//
//  Created by Petar Sakotic on 10/21/19.
//  Copyright © 2019 Petar Sakotic. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController {
    
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var infoText: UITextView!
    @IBOutlet weak var getStartedButton: UIButton!
    @IBAction func getStartedBtn(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Authentication", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "AuthenticationViewController") as UIViewController
        present(controller, animated: true, completion: nil)
    }
    
    //MARK: View Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        getStartedButton.layer.cornerRadius = 10.0
        setScreenDescription(title: "Reminders made simple", description: "Lorem ipsum dajfhaishfaiuhf afshaishfiasfh ajkfhaisfhuaß")
        //MARK: SetTheme
        if self.traitCollection.userInterfaceStyle == .dark {
            // User Interface is Dark
            CurrentTheme.current = DarkMode()
        } else {
            // User Interface is Light
            CurrentTheme.current = LightMode()
        }
    }
    //MARK: UI
    func setScreenDescription(title: String, description: String) {
        infoLabel.text = title
        infoText.text = description
        
    }
}

