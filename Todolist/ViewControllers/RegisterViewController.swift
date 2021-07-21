//
//  RegisterViewController.swift
//  Todolist
//
//  Created by Petar Sakotic on 12/18/19.
//  Copyright © 2019 Petar Sakotic. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var emailAdressTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var repeatPasswordTextField: UITextField!
    @IBOutlet weak var registerButtonOutlet: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUi()
    }
    //MARK: Config UI
    private func configureUi(){
        registerButtonOutlet.layer.cornerRadius = 10.0
        emailAdressTextField.text = nil
        passwordTextField.text = nil
        repeatPasswordTextField.text = nil
        emailAdressTextField.placeholder = "User Name"
        passwordTextField.placeholder = "Password"
        repeatPasswordTextField.placeholder = "Repeat password"
    }
    func showMainScreen(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "MainScreen")
        present(controller, animated: true, completion: nil)
    }
    private func presentError(message: String){
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    //MARK: IBAction
    @IBAction func registerButton(_ sender: Any) {
        AuthenticateMenager.shared.createUser(email: emailAdressTextField.text!, password: passwordTextField.text!, repeatPassword: repeatPasswordTextField.text!,
                                              errorHandler: { (error) in
                                                self.presentError(message: error.localizedDescription)
        },
                                              successHandler: {
                                                self.showMainScreen()
                                                GoogleAnalyticsManager.shared.customEvent(eventName: .registeredUser, eventParams: [:])
        })
    }
}

extension RegisterViewController: AuthenticationStateProtocol {
    func logInState(state: AuthenticationState) {
        switch state {
        case .logInProgress:
            view.isUserInteractionEnabled = false
        case .idle:
            view.isUserInteractionEnabled = true
        case .logedIn(let authData):
            view.isUserInteractionEnabled = true
            UserManager.shared.initUser(id: authData.id, username: authData.username!)
            showMainScreen()
        case .failed(let error):
            view.isUserInteractionEnabled = true
        case .logOut:
            break
        case .registred(let authData):
            UserManager.shared.initUser(id: authData.id, username: authData.username!)
        }
    }
}
