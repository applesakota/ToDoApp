//
//  AuthenticateMenager.swift
//  Todolist
//
//  Created by Petar Sakotic on 12/17/19.
//  Copyright © 2019 Petar Sakotic. All rights reserved.
//

import Foundation
import Firebase
import FBSDKCoreKit
import FBSDKLoginKit

enum AuthenticateManagerError: Error {
    case serverError(Error)
    case wrongEmail
    case wrongPassword
    case passwordMustContain
    case errorCreatingUser
    case emailNotValid
    case passwordIsEmpty
    case passwordDontMatch
    case errorLogInWithFacebook
    case facebookLogInCancel
    case signOutError
    case customError(String)
}
extension AuthenticateManagerError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .wrongEmail:
            return NSLocalizedString("Wrong Email Adress", comment: "")
        case .wrongPassword:
            return NSLocalizedString("Wrong Password", comment: "")
        case .passwordMustContain:
            return NSLocalizedString("Password Must Contain Special Caracter", comment: "")
        case .errorCreatingUser:
            return NSLocalizedString("Error creating user", comment: "")
        case .emailNotValid:
            return NSLocalizedString("Email not valid", comment: "")
        case .passwordIsEmpty:
            return NSLocalizedString("Password is empty", comment: "")
        case .serverError(let error):
            return error.localizedDescription
        case .passwordDontMatch:
            return NSLocalizedString("Passwords don't Match", comment: "")
        case .errorLogInWithFacebook:
            return NSLocalizedString("Error loging with Facebook", comment: "")
        case .facebookLogInCancel:
            return NSLocalizedString("Facebook login is Cancel", comment: "")
        case .signOutError:
            return NSLocalizedString("Error sign up", comment: "")
        case .customError(let error):
            return error
        }
    }
}
struct AuthData {
    let id : String
    let username : String?
}
enum AuthenticationState {
    case registred(AuthData)
    case logedIn(AuthData)
    case failed(AuthenticateManagerError)
    case logInProgress
    case idle
    case logOut
}
protocol AuthenticationStateProtocol: class {
    func logInState(state: AuthenticationState)
}
class AuthenticateMenager: NSObject {
    
    weak var stateDelegate: AuthenticationStateProtocol?
    static let shared = AuthenticateMenager()
    //MARK: Public
    func createUser(email: String, password: String, repeatPassword: String, errorHandler:@escaping ErrorHandler, successHandler:@escaping ()->Void){
        if isPasswordRepeated(password: password, repeatPassword: repeatPassword) != nil {
            errorHandler(AuthenticateManagerError.passwordDontMatch)
        }
        if isEmailValid(email: email) == false {
            errorHandler(AuthenticateManagerError.emailNotValid)
        }
        if password.isEmpty {
            errorHandler(AuthenticateManagerError.passwordIsEmpty)
            return
        }
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            if error != nil {
                errorHandler(AuthenticateManagerError.serverError(error!))
            } else {
                if let user = authResult?.user {
                    UserManager.shared.initUser(id: user.uid, username: user.email)
                    successHandler()
                } else {
                    errorHandler(AuthenticateManagerError.serverError(error!))
                }
            }
        }
    }
    func signIn(email: String, password: String) {
        self.stateDelegate?.logInState(state: .logInProgress)
        if let error = validatePassword(password: password) {
            self.stateDelegate?.logInState(state: .failed(error))
            return
        } else if email.isEmpty {
            self.stateDelegate?.logInState(state: .failed(.emailNotValid))
            return
        }
        Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
            if error != nil {
                self.stateDelegate?.logInState(state: .failed(.serverError(error!)))
                return
            } else {
                if let id = authResult?.user.uid {
                    self.stateDelegate?.logInState(state: .logedIn(AuthData(id: id, username: authResult?.user.email)))
                } else {
                    self.stateDelegate?.logInState(state: .failed(.customError("Failed to get user id")))
                }
            }
        }
    }
    func singOut() -> Error? {
        do {
            try Auth.auth().signOut()
        } catch {
            return AuthenticateManagerError.signOutError
        }
        return nil
    }
    // MARK: Private
    private func validateEmail(email: String) -> AuthenticateManagerError? {
        if isEmailValid(email: email) != true {
            return AuthenticateManagerError.emailNotValid
        }
        return AuthenticateManagerError.wrongEmail
    }
    private func validatePassword(password: String) -> AuthenticateManagerError? {
        if isPasswordValid(password: password) != true {
            return AuthenticateManagerError.passwordMustContain
        }
        return nil
    }
    private func isPasswordValid(password: String) -> Bool {
        return password.count >= 6
    }
    private func isEmailValid(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    private func isPasswordRepeated(password: String,repeatPassword: String) -> Error? {
        if password != repeatPassword {
            return AuthenticateManagerError.passwordDontMatch
        }
        return nil
    }
    func getUserEmail() -> String {
        if Auth.auth().currentUser != nil {
            let user = Auth.auth().currentUser
            if let user = user {
                return user.email ?? "unknown"
            }
        }
        return "unknown"
    }
}
extension AuthenticateMenager: LoginButtonDelegate {
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        if error != nil {
            self.stateDelegate?.logInState(state: .failed(.serverError(error!)))
        }
        if let result = result, result.isCancelled {
            self.stateDelegate?.logInState(state: .failed(.facebookLogInCancel))
            return
        }
        let credential = FacebookAuthProvider.credential(withAccessToken: AccessToken.current!.tokenString)
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if let error = error {
                // ...
                self.stateDelegate?.logInState(state: .failed(.serverError(error)))
                return
            }
        }
        
    }
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
    }
}
//extension AuthenticateMenager: GIDSignInDelegate {
//    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
//        self.stateDelegate?.logInState(state: .logInProgress)
//        if let error = error {
//            self.stateDelegate?.logInState(state: .failed(.serverError(error)))
//            return
//        }
//        guard let authentication = user.authentication else { return }
//        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
//                                                       accessToken: authentication.accessToken)
//        Auth.auth().signIn(with: credential) { (authResult, error) in
//            if error != nil {
//                self.stateDelegate?.logInState(state: .failed(.serverError(error!)))
//                return
//            } else {
//                if let id = authResult?.user.uid {
//                    self.stateDelegate?.logInState(state: .logedIn(AuthData(id: id, username: authResult?.user.email)))
//                } else {
//                    self.stateDelegate?.logInState(state: .failed(.customError("Failed to get user id")))
//                }
//            }
//        }
//    }
//    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
//    }
//}
