//
//  OnboardService.swift
//  KimTrungApp
//
//  Created by HieuNT on 23/02/2024.
//

import Foundation

class OnboardService {
    /// Khởi tạo đối tượng thể hiện của class AuthService
    static var shared = OnboardService()
    
    private init() {
        print("OnboardService init")
    }
    
    enum Keys: String {
        case keyOnboard
    }
    
    func markOnboarded() {
        let userDefault = UserDefaults.standard
        userDefault.setValue(true, forKey: Keys.keyOnboard.rawValue)
    }
    
    func isOnboarded() -> Bool {
        let userDefault = UserDefaults.standard
        return userDefault.bool(forKey: Keys.keyOnboard.rawValue)
    }
}
