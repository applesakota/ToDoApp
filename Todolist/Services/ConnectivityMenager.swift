//
//  ConnectivityMenager.swift
//  Todolist
//
//  Created by Petar Sakotic on 11/13/19.
//  Copyright © 2019 Petar Sakotic. All rights reserved.
//

import Foundation
import Alamofire

class ConnectivityMenager {
    class func isConnectedToInternet() -> Bool {
        return NetworkReachabilityManager()?.isReachable ?? false
    }
}
