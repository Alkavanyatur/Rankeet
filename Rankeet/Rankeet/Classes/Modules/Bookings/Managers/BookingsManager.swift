//
//  BookingsManager.swift
//  Rankeet
//
//  Created by Alejandro Hernández Matías on 26/5/18.
//  Copyright © 2018 Rankeet. All rights reserved.
//

import UIKit

class BookingsManager: NSObject {
    
    func getLightingReservations(completion:@escaping ([AlLightReservation]?,RankeetError?)->Void){
        if let currentUserId = LoginManager().currentUserId(){
            BookingsDataProvider.sharedInstance.getLightingReservations(currentIdUser: currentUserId) { (reservations, error) in
                completion(reservations,error)
            }
        }else{
            completion(nil,RankeetError.noLogin)
        }
    }
    
    func cancelLightingReservation(reason:String, currentIdLightingreservation:String,completion:@escaping (RankeetError?)->Void){
        BookingsDataProvider.sharedInstance.cancelLightingReservation(reason:reason, currentIdLightingreservation: currentIdLightingreservation) { (error) in
            completion(error)
        }
    }
    
    func requestExtendLightingReservation(currentReservation:AlLightReservation,completion:@escaping (AlLightReservation?,RankeetError?)->Void){
        if let currentIdUser = LoginManager().currentUserId() {
            FacilititesDataProvider.sharedInstance.requestMadeLightingReservation(currentIdUser: currentIdUser, currentReservation: currentReservation) { (reservation,error) in
                completion(reservation,error)
            }
        }else{
            completion(nil,RankeetError.unknown)
        }
    }
    
    func createNewIssue(currentIssue:AlIssue,completion:@escaping (RankeetError?)->Void){
        if let currentIdUser = LoginManager().currentUserId() {
            BookingsDataProvider.sharedInstance.createNewIssue(currentIdUser: currentIdUser, currentIssue: currentIssue, completion: { (error) in
                completion(error)
            })
        }else{
            completion(RankeetError.unknown)
        }
    }
}
