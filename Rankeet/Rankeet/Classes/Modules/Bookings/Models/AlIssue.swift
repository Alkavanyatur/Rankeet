//
//  AlIssue.swift
//  Rankeet
//
//  Created by Alejandro Hernández Matías on 23/4/18.
//  Copyright © 2018 Rankeet. All rights reserved.
//

import UIKit
import ObjectMapper

class AlIssue: Mappable {
    var idIssue: String?
    
    var idUser: String?
    var idLightReservation: String?
    
    var subject: String?
    var body: String?
    
    var creationTime: Date?
    var state: Int?
    
    init(currentDate:Date, idUser:String, idLightReservation:String, subject:String, body:String) {
        self.creationTime = currentDate
        self.idUser = idUser
        self.idLightReservation = idLightReservation
        self.subject = subject
        self.body = body
    }
    
    required init?(map: Map) {
    }
    
    // Mappable
    func mapping(map: Map) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat =  RankeetDefines.ContentServices.dateFormatSendReservation
        
        idIssue <- map["_id"]
        
        idUser <- map["user._id"]
        idLightReservation <- map["lightReservation._id"]
        
        subject <- map["subject"]
        body <- map["body"]
        
        creationTime <- (map["creationTime"], DateFormatterTransform(dateFormatter: dateFormatter))
        state <- map["state"]
    }
}
