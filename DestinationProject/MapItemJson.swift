//
//  MapItemJson.swift
//  DestinationProject
//
//  Created by yaojinhai on 2020/9/14.
//  Copyright © 2020 yaojinhai. All rights reserved.
//

import UIKit

import MapKit

struct MapItemJson: Codable {
    let name: String
    let bankName: String
    let perRMB: Int // 一次多少元
    var listCount: [DetialItemJson]!

    var address: String?

    var sendTime: String?
    

    var perRMBString: String {
        if let t = sendTime?.realText {
            return t + "号-" + perRMB.description + "元/天"
        }
       return perRMB.description + "元/天"
    }
    
    
    init(name: String,bankName: String,perRMB: Int,sendTime: String?,address: String?) {
        self.name = name;
        self.bankName = bankName
        self.perRMB = perRMB;
        self.address = address
        self.sendTime = sendTime
        listCount = [DetialItemJson]()
    }
}


enum PriceStateType: Int, Codable{
    case isNotMe = 0
    case isMyself = 1
}


struct DetialItemJson: Codable {
    
   
    var date: String
    var price: String?
    
    
    
    var priceState: String {
        isMySelf ? "已结账" : "未结账"
    }
    
    var isMySelf: Bool {
        stateInt == .isMyself
    }
    
    var stateInt: PriceStateType? // 0为结账 1 已经结账 
    
    var reaseSateInt: PriceStateType {
        isMySelf ? .isNotMe : .isMyself
    }
    
    init(price: String?) {
        self.price = price
        stateInt = .isNotMe
        date = DetialItemJson.forrmaterDate()
    }

    var priceInt: Int? {
        Int(price ?? "")
    }

 
    
}

extension DetialItemJson {
    
    static func forrmaterDate(date: Date = Date()) -> String {
        let formater = DateFormatter()
        formater.dateFormat = "yyyy年MM月dd日 EEEE";
        formater.locale = Locale(identifier: "zh-Hans_US")
        formater.calendar = .init(identifier: .gregorian);
        return formater.string(from: date)
    } 
    static func forrmaterTime(date: Date = Date()) -> String {
        let formater = DateFormatter()
        formater.dateFormat = "HH:mm";
        formater.locale = Locale(identifier: "zh-Hans_US")
        formater.calendar = .init(identifier: .gregorian);
        return formater.string(from: date)
    } 
}
