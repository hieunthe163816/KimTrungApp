//
//  Food.swift
//  KimTrungApp
//
//  Created by HieuNT on 03/03/2024.
//

import Foundation

class Food{
    var foodId = ""
    var foodName = ""
    var foodImg = ""
    var foodStar = ""
    var soldQuantity = ""
    var foodPrice = ""
    var foodPrecentPrice = ""
    var detailsFood = ""
    var category = ""
    
    init(dict: [String: Any]){
        [
            self.foodId = dict["foodId"] as? String ?? "",
            self.foodName = dict["foodName"] as? String ?? "",
            self.foodImg = dict["foodImg"] as? String ?? "",
            self.foodStar = dict["foodStar"] as? String ?? "",
            self.soldQuantity = dict["soldQuantity"] as? String ?? "",
            self.foodPrice = dict["foodPrice"] as? String ?? "",
            self.foodPrecentPrice = dict["foodPrecentPrice"] as? String ?? "",
            self.detailsFood = dict["detailsFood"] as? String ?? "",
            self.category = dict["category"] as? String ?? ""
        ]
    }
}
