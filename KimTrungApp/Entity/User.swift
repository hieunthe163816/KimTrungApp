//
//  User.swift
//  KimTrungApp
//
//  Created by HieuNT on 09/03/2024.
//

import Foundation

class User {
    var id = ""
    var avatar = ""
    var email = ""
    var phone = ""
    var name = ""
    var log = ""
    var address = ""
    
    init(dict: [String: Any]){
        self.id = dict["id"] as? String ?? ""
        self.avatar = dict["avatar"] as? String ?? ""
        self.email = dict["email"] as? String ?? ""
        self.phone = dict["phone"] as? String ?? ""
        self.name = dict["name"] as? String ?? ""
        self.log = dict["log"] as? String ?? ""
        self.address = dict["address"] as? String ?? ""
    }
   
}
