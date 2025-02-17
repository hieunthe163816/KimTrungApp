//
//  AuthService.swift
//  KimTrungApp
//
//  Created by HieuNT on 23/02/2024.
//

import Foundation
import KeychainSwift

class AuthService {
    /// Khởi tạo đối tượng thể hiện của class AuthService
    static var shared = AuthService()
    
    private init() {
       // print("AuthService init")
    }
    
    enum Keys: String {
        case keyAccessToken
    }
    
    /// Muốn lưu accessToken từ API login, register
    func saveAccessToken(accessToken: String) {
        let keychain = KeychainSwift()
        keychain.set(accessToken, forKey: Keys.keyAccessToken.rawValue)
    }
    
    /// Lấy accessToken đã lưu ra để thực hiện logic
    func getAccessToken() -> String? {
        let keychain = KeychainSwift()
        return keychain.get(Keys.keyAccessToken.rawValue)
    }
    
    /// Xóa accesstoken khỏi Keychain
    func clearAccessToken() {
        let keychain = KeychainSwift()
        keychain.delete(Keys.keyAccessToken.rawValue)
    }
    
    /// Check login xem user đã login hay chưa
    /// Nếu mà đã save accessToken thì là đã login.
    /// Nếu chưa thì là chưa login
    var isLoggedIn: Bool {
        let token = getAccessToken()
        
       // print("AccessToken: \(token)")
        
        return token != nil && !(token!.isEmpty)
    }
}
