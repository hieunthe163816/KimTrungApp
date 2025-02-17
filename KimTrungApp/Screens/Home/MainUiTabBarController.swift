//
//  MainUiTabBarController.swift
//  KimTrungApp
//
//  Created by HieuNT on 27/02/2024.
//

import UIKit
import ESTabBarController_swift

extension UIImage {
    func resize(to size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        defer { UIGraphicsEndImageContext() }
        self.draw(in: CGRect(origin: .zero, size: size))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    func createSelectionIndicator(color: UIColor, size: CGSize, lineWidth: CGFloat) -> UIImage {
          UIGraphicsBeginImageContextWithOptions(size, false, 0)
          color.setFill()
          UIRectFill(CGRect(x: 0, y: size.height - lineWidth, width: size.width, height: lineWidth))
          let image = UIGraphicsGetImageFromCurrentImageContext()
          UIGraphicsEndImageContext()
          return image!
      }
}

class MainUiTabBarController: ESTabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
//        let myScreen : UITabBarController = self.systemStyle()
//        self.viewControllers = [myScreen]
        // Do any additional setup after loading the view.
        systemStyle()
    }
    
    private func systemStyle() {
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let v1 = storyboard.instantiateViewController(identifier: "HomeViewController")
        let v2 = storyboard.instantiateViewController(identifier: "FavoriteViewController")
        let v3 = storyboard.instantiateViewController(identifier: "OrderViewController")
        let v4 = storyboard.instantiateViewController(identifier: "ProfileMainUiViewController")
        let v5 = storyboard.instantiateViewController(identifier: "CartViewController")
        
        v1.tabBarItem = UITabBarItem(title: "Home", image: UIImage(named: "ic_home_clear")?.withRenderingMode(.alwaysOriginal).resize(to: CGSize(width: 32, height: 32)), selectedImage: UIImage(named: "ic_home_choice")?.withRenderingMode(.alwaysOriginal).resize(to: CGSize(width: 32, height: 32)))
        v2.tabBarItem = UITabBarItem(title: "Favorite", image: UIImage(named: "ic_love")?.withRenderingMode(.alwaysOriginal).resize(to: CGSize(width: 32, height: 32)), selectedImage: UIImage(named: "ic_love")?.withRenderingMode(.alwaysOriginal).resize(to: CGSize(width: 32, height: 32)))
        v3.tabBarItem = UITabBarItem(title: "Cart", image: UIImage(named: "ic_cart")?.withRenderingMode(.alwaysOriginal).resize(to: CGSize(width: 32, height: 32)), selectedImage: UIImage(named: "ic_cart")?.withRenderingMode(.alwaysOriginal).resize(to: CGSize(width: 32, height: 32)))
        v4.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(named: "ic_profile")?.withRenderingMode(.alwaysOriginal).resize(to: CGSize(width: 32, height: 32)), selectedImage: UIImage(named: "ic_profile")?.withRenderingMode(.alwaysOriginal).resize(to: CGSize(width: 32, height: 32)))
        v5.tabBarItem = UITabBarItem(title: "Order", image: UIImage(named: "ic_order")?.withRenderingMode(.alwaysOriginal).resize(to: CGSize(width: 32, height: 32)), selectedImage: UIImage(named: "ic_order")?.withRenderingMode(.alwaysOriginal).resize(to: CGSize(width: 32, height: 32)))
        var listCart : [FoodCart] = []
        listCart = ServiceData.shared.getCartFood()
        v3.tabBarItem.badgeValue = String(listCart.count)
        
        self.tabBar.shadowImage = UIImage()
        self.tabBar.backgroundImage = UIImage()
        self.tabBar.backgroundColor = .white
        self.tabBar.tintColor = UIColor(red: 231/255, green: 151/255, blue: 41/255, alpha: 1.0) // Màu khi được chọn
        let selectionIndicatorView = UIView(frame: CGRect(x: 0, y: 0, width: self.tabBar.frame.width / CGFloat(self.tabBar.items?.count ?? 1), height: 2))
         selectionIndicatorView.backgroundColor = UIColor(red: 231/255, green: 151/255, blue: 41/255, alpha: 1.0)
        self.viewControllers = [v1, v2, v3, v5, v4]
    }
    
    func updateCartBadgeValue() {
        let vcs = self.viewControllers ?? []
        print("đã vào updataCart với number ")
        guard vcs.count > 2 else { return } // Đảm bảo rằng có ít nhất 3 view controller trong tab bar (v3 là tab chứa giỏ hàng)
        let v3 = vcs[2]
        var listCart: [FoodCart] = []
        listCart = ServiceData.shared.getCartFood()
        if listCart.count > 0 {
            v3.tabBarItem.badgeValue = listCart.count > 0 ? String(listCart.count) : nil
        } else {
            v3.tabBarItem.badgeValue = nil
        }
        
        print("đã vào updataCart với number = \(listCart.count)")
    }

    func updateCartBadgeValueWithNumber(number : Int) {
        let vcs = self.viewControllers ?? []
        print("đã vào updataCart với number ")
        guard vcs.count > 2 else { return } // Đảm bảo rằng có ít nhất 3 view controller trong tab bar (v3 là tab chứa giỏ hàng)
        let v3 = vcs[2]
        
        v3.tabBarItem.badgeValue = String(number)
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
