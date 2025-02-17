//
//  Order.swift
//  KimTrungApp
//
//  Created by HieuNT on 03/04/2024.
//

import Foundation



class Order {
    var id = ""
    var userId = ""
    var dateOrder = ""
    var dateSuccess = ""
    var location = ""
    var status = ""
    var total = ""
    var listFoodString = ""
    
    init(dict : [String : Any ]) {
        self.id = dict["orderId"] as? String ?? ""
        self.dateOrder = dict["dateOrder"] as? String ?? ""
        self.dateSuccess = dict["dateOrder"] as? String ?? ""
        self.location = dict["location"] as? String ?? ""
        self.status = dict["status"] as? String ?? ""
        self.userId = dict["userId"] as? String ?? ""
        self.total = dict["total"] as? String ?? ""
        self.listFoodString = dict["listFoodString"] as? String ?? ""
    }
}
