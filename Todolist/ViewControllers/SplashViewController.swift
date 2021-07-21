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
    //MARK: View Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewController()
        getStartedButton.layer.cornerRadius = 10.0
        setScreenDescription(title: "Reminders made simple", description: "Your favourite TODO App")
        //MARK: SetTheme
        if self.traitCollection.userInterfaceStyle == .dark {
            CurrentTheme.current = DarkMode()
        } else {
            CurrentTheme.current = LightMode()
        }
    }
    //MARK: UI
    func setScreenDescription(title: String, description: String) {
        infoLabel.text = title
        infoText.text = description
    }
    func setViewController() {
        if UserManager.shared.getLastSignInUser() != nil {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "HomeScreen")
            controller.modalPresentationStyle = .fullScreen
            DispatchQueue.main.async {
                self.present(controller, animated: true, completion: nil)
            }
        }
    }
    //MARK: Button actions
    @IBAction func getStartedBtn(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Authentication", bundle: nil)
        let controller = storyboard.instantiateInitialViewController()!
        present(controller, animated: true, completion: nil)
        GoogleAnalyticsManager.shared.customEvent(eventName: .clickOnGetStartedBtn, eventParams: [:])
    }
}
extension SplashViewController: GetScreenNameProtocol {
    var screenName: String {
        get {
            return "SplashScreen"
        }
    }
}

