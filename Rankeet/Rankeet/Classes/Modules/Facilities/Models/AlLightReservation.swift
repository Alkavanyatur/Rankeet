//
//  AlLightReservation.swift
//  Rankeet
//
//  Created by Alejandro Hernández Matías on 20/3/18.
//  Copyright © 2018 Rankeet. All rights reserved.
//

import UIKit
import ObjectMapper

class AlLightReservationsResult: Mappable {
    
    var total: Int?
    var objects: [AlLightReservation]?
    
    required init?(map: Map) {
    }
    
    // Mappable
    func mapping(map: Map) {

        total <- map["total"]
        objects <- map["objects"]
    }
}


class AlLightReservationExtend: Mappable {
    
    var idExtend: String?
    
    required init?(map: Map) {
    }
    
    // Mappable
    func mapping(map: Map) {
        idExtend <- map["_id"]
    }
}

class AlLightReservation: Mappable, NSCopying {
    
    var idLightingReservation: String?
    
    var idUser: String?
    var nameUser: String?
    var emailUser: String?
    
    var idFacility: String?
    var nameFacility: String?
    var addresFacility: String?
    
    var idField: String?
    var nameField: String?
    var lightPriceField: String?
    
    var refund: Int?
    
    var state: AlLightingReservationState?
    var lightState: Int?
    var timeEnd: Date?
    var timeStart: Date?
    var timeCancelled: Date?
    
    var extend: AlLightReservationExtend?
    
    init(idLightingReservation:String?, idUser:String?, nameUser:String?, emailUser:String?, idFacility:String?, nameFacility:String?, addresFacility:String?, idField:String?, nameField:String?, lightPriceField:String?, refund:Int?, state:AlLightingReservationState?, lightState:Int?, timeEnd:Date?, timeStart:Date?, timeCancelled:Date?, extend:AlLightReservationExtend?) {
        
        self.idLightingReservation = idLightingReservation
        
        self.idUser = idUser
        self.nameUser = nameUser
        self.emailUser = emailUser
        
        self.idFacility = idFacility
        self.nameFacility = nameFacility
        self.addresFacility = addresFacility
        
        self.idField = idField
        self.nameField = nameField
        self.lightPriceField = lightPriceField
        
        self.refund = refund
        
        self.state = state
        self.lightState = lightState
        self.timeEnd = timeEnd
        self.timeStart = timeStart
        self.timeCancelled = timeCancelled
        
        self.extend = extend
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = AlLightReservation(idLightingReservation: idLightingReservation, idUser: idUser, nameUser: nameUser, emailUser: nameUser, idFacility: idFacility, nameFacility: nameFacility, addresFacility: addresFacility, idField: idField, nameField: nameField, lightPriceField: lightPriceField, refund: refund, state: state, lightState: lightState, timeEnd: timeEnd, timeStart: timeStart, timeCancelled: timeCancelled, extend: extend)
        return copy
    }
    
    init(currentStartDate:Date, currentEndDate:Date, currentField:AlField, currentFacility:AlFacility) {
        
        if let currentIdField = currentField.idField{
            
            var currentDateEnd = currentEndDate
            if  currentStartDate > currentDateEnd {
                currentDateEnd = currentDateEnd.add(1.days)
            }
            
            self.timeEnd = currentDateEnd
            self.timeStart = currentStartDate
            self.idField = currentIdField
            self.idFacility = currentFacility.idFacility
            
            self.nameFacility = currentFacility.nameFacility
            self.addresFacility = currentFacility.info?.address ?? ""
            
            self.nameField = currentField.nameField
            
            self.lightPriceField = String(currentField.lightPrice)
        }
    }
    
    required init?(map: Map) {
    }
    
    // Mappable
    func mapping(map: Map) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat =  RankeetDefines.ContentServices.dateFormatSendReservation
        
        idLightingReservation <- map["_id"]
        
        idUser <- map["user._id"]
        nameUser <- map["user.name"]
        emailUser <- map["user.email"]
        
        idFacility <- map["facility._id"]
        nameFacility <- map["facility.name"]
        addresFacility <- map["facility.address"]
        
        idField <- map["field._id"]
        nameField <- map["field.nameLoc"]
        lightPriceField <- map["field.lightPrice"]
        
        refund <- map["refund"]
        state <- map["state"]
        lightState <- map["lightState"]
        
        extend <- map["extend"]
        
        timeEnd <- (map["timeEnd"], DateFormatterTransform(dateFormatter: dateFormatter))
        timeStart <- (map["timeStart"], DateFormatterTransform(dateFormatter: dateFormatter))
        timeCancelled <- (map["timeCancelled"], DateFormatterTransform(dateFormatter: dateFormatter))
    }
}
