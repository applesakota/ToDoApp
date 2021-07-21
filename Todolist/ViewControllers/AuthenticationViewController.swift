//
//  AuthenticationViewController.swift
//  Todolist
//
//  Created by Petar Sakotic on 12/17/19.
//  Copyright © 2019 Petar Sakotic. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase


class AuthenticationViewController: UIViewController {
    
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var logInButtonOutlet: UIButton!
    @IBOutlet weak var registerOutletButton: UIButton!
    @IBOutlet weak var cancelBarButton: UIBarButtonItem!
    @IBOutlet weak var fbLogInButton: FBLoginButton!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        logInButtonOutlet.layer.cornerRadius = 10.0
        registerOutletButton.layer.cornerRadius = 10.0
        configureUi()
        self.userNameTextField.delegate = self
        self.passwordTextField.delegate = self
        fbLogInButton.delegate = AuthenticateMenager.shared
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    //MARK: Config UI
    private func configureUi() {
        userNameTextField.text = nil
        passwordTextField.text = nil
        userNameTextField.placeholder = "User Name"
        passwordTextField.placeholder = "Password"
        AuthenticateMenager.shared.stateDelegate = self
    }
    func showMainScreen(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "MainScreen")
        present(controller, animated: true, completion: nil)
    }
    //MARK: Alert
    private func presentError(message: String){
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    //MARK: Button Action
    @IBAction func logInButtonAction(_ sender: Any) {
        AuthenticateMenager.shared.signIn(email: userNameTextField.text!, password: passwordTextField.text!)
    }
    @IBAction func cancelBarButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "SplashScreen")
        present(controller, animated: true, completion: nil)
    }
}
extension AuthenticationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
extension AuthenticationViewController: AuthenticationStateProtocol {
    func logInState(state: AuthenticationState) {
        switch state {
        case .logInProgress:
            indicatorView.startAnimating()
            view.isUserInteractionEnabled = false
        case .idle:
            indicatorView.stopAnimating()
            view.isUserInteractionEnabled = true
        case .logedIn(let authData):
            indicatorView.stopAnimating()
            view.isUserInteractionEnabled = true
            UserManager.shared.initUser(id: authData.id, username: authData.username!)
            showMainScreen()
        case .failed(let error):
            presentError(message: "\(error)")
            indicatorView.stopAnimating()
            view.isUserInteractionEnabled = true
        case .logOut:
            break
        case .registred(let authData):
            indicatorView.stopAnimating()
            view.isUserInteractionEnabled = true
            UserManager.shared.initUser(id: authData.id, username: authData.username!)
        }
    }
}
