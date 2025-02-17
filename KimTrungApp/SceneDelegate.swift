//
//  SceneDelegate.swift
//  KimTrungApp
//
//  Created by HieuNT on 19/12/2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        /**
         Khởi tạo window từ windownScene
         */
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        
        /// Vứt cho appDelegate nó giữ để sau mình lấy ra cho dễ
        (UIApplication.shared.delegate as? AppDelegate)?.window = window
        
        if AuthService.shared.isLoggedIn {
            goToMain()
        } else {
            //nếu chưa onboard cho onboard
            
            print(OnboardService.shared.isOnboarded())
            
            if OnboardService.shared.isOnboarded()  {
                // Nếu chưa login thì cho vào login
                print("Chưa login cho vào màn login")
                goToLoginByCach1()
                
            } else {
                print("Nếu chưa onboard cho onboard")
                goToOnboard()
            }
           
        }
    }
    
    private func goToMain() {
        // Chưa đã login thì cho vào main
        print("Đã login rồi. Cho vào main")
        
        /// Get keywindown ra
        /// Set rootViewcontroller cho keywindown
        /**
         1/ Khởi storyboard
         2/ Lấy ra màn hình main
         
         // Tạo instance của màn hình đích
         let destinationVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DestinationViewController") as! DestinationViewController

         // Chuyển đổi màn hình
         self.navigationController?.pushViewController(destinationVC, animated: true)
         */
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let mainVC = storyboard.instantiateViewController(withIdentifier: "MainUiTabBarController") as! MainUiTabBarController
        
        window!.rootViewController = mainVC// Đưa cho windown 1 viewcontroller
        /// Make visible keywindown
        window!.makeKeyAndVisible()
    }
    
    private func goToOnboard() {
        // Chưa đã login thì cho vào main
        print("Đã login rồi. Cho vào main")
        
        /// Get keywindown ra
        /// Set rootViewcontroller cho keywindown
        /**
         1/ Khởi storyboard
         2/ Lấy ra màn hình main
         */
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let onboardVC = storyboard.instantiateViewController(withIdentifier: "OnBoardViewController")
        
        window!.rootViewController = onboardVC// Đưa cho windown 1 viewcontroller
        /// Make visible keywindown
        window!.makeKeyAndVisible()
    }
    
    /// Cách 1: Add login vc vào trong UINavigationController bằng code
    private func goToLoginByCach1() {
        /// Get keywindown ra
        /// Set rootViewcontroller cho keywindown
        /**
         1/ Khởi storyboard
         2/ Lấy ra màn hình main
         */
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
        
        let loginNavigation = UINavigationController(rootViewController: loginVC)
        
        window!.rootViewController = loginNavigation// Đưa cho windown 1 viewcontroller
        /// Make visible keywindown
        window!.makeKeyAndVisible()
    }
    
    /// Cách 2: Gọi thằng UINavigation đã embed trong main storyboard ra
    private func goToLoginByCach2() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let authNav = storyboard.instantiateViewController(withIdentifier: "AuthNavigation")
        window!.rootViewController = authNav// Đưa cho windown 1 viewcontroller
        /// Make visible keywindown
        window!.makeKeyAndVisible()
    }
    
}

