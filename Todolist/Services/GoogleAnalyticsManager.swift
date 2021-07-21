//
//  GoogleAnalyticsManager.swift
//  Todolist
//
//  Created by Petar Sakotic on 1/21/20.
//  Copyright © 2020 Petar Sakotic. All rights reserved.
//

import Foundation
import Firebase

enum EventName: String{
    case userLogIn = "userLogIn"
    case userLogOut = "userLogOut"
    case clickOnGetStartedBtn = "clickOnGetStartedButton"
    case registeredUser = "userRegistered"
    case userDeleteTask = "userDeleteTask"
    case userClickOnAddTask = "userClickOnAddTask"
    case userAddedTask = "userAddedTask"
    case userClickOnEditTask = "userClickOnEditTask"
    case userEditedTask = "userEditedTask"
}
class GoogleAnalyticsManager {
    
    static let shared = GoogleAnalyticsManager()
    
    func customEvent(eventName: EventName, eventParams: [String:Any]){
        Analytics.logEvent(eventName.rawValue, parameters: eventParams)
    }
    func setScreen(screenName: String) {
        Analytics.setScreenName(screenName, screenClass: nil)
    }
}
protocol GetScreenNameProtocol {
    var screenName: String {get}
    func sendScreenNameToFirebase()
}
extension GetScreenNameProtocol where Self: UIViewController {
    func sendScreenNameToFirebase() {
        GoogleAnalyticsManager.shared.setScreen(screenName: screenName)
    }
}

