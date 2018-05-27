//
//  BookingsDataProvider.swift
//  Rankeet
//
//  Created by Alejandro Hernández Matías on 26/5/18.
//  Copyright © 2018 Rankeet. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper

class BookingsDataProvider: NSObject {
    static let sharedInstance = BookingsDataProvider()
    
    func getLightingReservations(currentIdUser:String,completion:@escaping ([AlLightReservation]?,RankeetError?)->Void){
        let serviceUrl = RankeetDefines.ContentServices.baseUrl+RankeetDefines.ContentServices.Facilities.lightReservations+"?userId="+currentIdUser
        let sessionManager = Alamofire.SessionManager.default
        let parameters:Parameters = [:]
        RankeetLoginDataProvider.sharedInstance.getCurrentuserToken { (token) in
            sessionManager.adapter = RankeetRequestAdapter(authToken: token)
            sessionManager.request(serviceUrl, method: .get, parameters: parameters, encoding: URLEncoding(destination: .queryString), headers: nil).responseString { (response) -> Void in
                
                guard response.response != nil, response.result.isSuccess, let value = response.result.value, response.response?.statusCode == DevDefines.Services.correct_code_http else {
                    completion(nil,RankeetError.unknown)
                    return
                }
                let reservationsResult = Mapper<AlLightReservationsResult>().map(JSONString: value)
                guard reservationsResult != nil, reservationsResult?.objects != nil else{
                    completion(nil,RankeetError.unknown)
                    return
                }
                completion(reservationsResult?.objects,nil)
            }
        }
    }
    func cancelLightingReservation(reason:String, currentIdLightingreservation:String,completion:@escaping (RankeetError?)->Void){
        let serviceUrl = RankeetDefines.ContentServices.baseUrl+RankeetDefines.ContentServices.Facilities.cancelLightReservation
        let sessionManager = Alamofire.SessionManager.default
        var parameters:Parameters = [:]
        parameters["_id"] = currentIdLightingreservation
        parameters["cancelReason"] = reason
        
        RankeetLoginDataProvider.sharedInstance.getCurrentuserToken { (token) in
            sessionManager.adapter = RankeetRequestAdapter(authToken: token)
            sessionManager.request(serviceUrl, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseString { (response) -> Void in
                
                guard response.response != nil, response.result.isSuccess, let value = response.result.value, response.response?.statusCode == DevDefines.Services.correct_code_http else {
                    completion(RankeetError.unknown)
                    return
                }
                let alLightReservation = Mapper<AlLightReservation>().map(JSONString: value)
                guard alLightReservation != nil, let _ = alLightReservation?.idLightingReservation else{
                    completion(RankeetError.unknown)
                    return
                }
                completion(nil)
            }
        }
    }
    
    func createNewIssue(currentIdUser:String,currentIssue:AlIssue,completion:@escaping (RankeetError?)->Void){
        let serviceUrl = RankeetDefines.ContentServices.baseUrl+RankeetDefines.ContentServices.Issues.addIssue
        let sessionManager = Alamofire.SessionManager.default
        var parameters:Parameters = [:]
        parameters["user"] = ["_id":currentIdUser]
        
        if let idReservation = currentIssue.idLightReservation, let currentSubject = currentIssue.subject, let currentBody = currentIssue.body {
            parameters["lightReservation"] = ["_id":idReservation]
            parameters["subject"] = currentSubject
            parameters["body"] = currentBody
        }

        RankeetLoginDataProvider.sharedInstance.getCurrentuserToken { (token) in
            sessionManager.adapter = RankeetRequestAdapter(authToken: token)
            sessionManager.request(serviceUrl, method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseString { (response) -> Void in
                
                guard response.response != nil, response.result.isSuccess, let value = response.result.value, response.response?.statusCode == DevDefines.Services.correct_code_http else {
                    completion(RankeetError.unknown)
                    return
                }
                let alIssue = Mapper<AlIssue>().map(JSONString: value)
                guard alIssue != nil, let _ = alIssue?.idIssue else{
                    completion(RankeetError.unknown)
                    return
                }
                completion(nil)
            }
        }
    }
}
