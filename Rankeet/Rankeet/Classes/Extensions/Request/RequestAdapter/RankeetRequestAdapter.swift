//
//  RankeetRequestAdapter.swift
//  Rankeet
//
//  Created by Alejandro Hernández Matías on 26/5/18.
//  Copyright © 2018 Rankeet. All rights reserved.
//

import UIKit
import Alamofire

class RankeetRequestAdapter: RequestAdapter {
    
    var currentAuthToken:String?
    
    init(authToken:String?) {
        self.currentAuthToken = authToken
    }

    func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        var urlRequest = urlRequest
        
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("*/*", forHTTPHeaderField: "Accept")
        
        let pre = Locale.preferredLanguages[0]
        urlRequest.setValue(pre, forHTTPHeaderField: "lang")
        
        if let authToken = self.currentAuthToken, authToken.count > 0{
            urlRequest.setValue(authToken, forHTTPHeaderField: "auth-token")
        }else{
            urlRequest.setValue("debug", forHTTPHeaderField: "auth-token")
        }
        return urlRequest
    }
}
