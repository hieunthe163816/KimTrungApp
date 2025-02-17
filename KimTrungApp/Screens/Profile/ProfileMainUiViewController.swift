//
//  ProfileMainUiViewController.swift
//  KimTrungApp
//
//  Created by HieuNT on 05/03/2024.
//

import UIKit

class ProfileMainUiViewController: UIViewController {

    struct Item {
        var image: String
        var title: String
        var detail: String
        var screenTo: String
    }
    
    var managerItem: [Item] = []
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        managerItem = dummyData()
        tableView.delegate = self
        tableView.dataSource = self
        navigationController?.isNavigationBarHidden = true
        
    }
    
    
    func dummyData() -> [Item]{
        
        let data1 = Item(image: "ic_profile", title: "Profile Setting", detail: "Change your information", screenTo: "")
        let data2 = Item(image: "ic_lock", title: "Change Password", detail: "Change your password", screenTo: "")
        let data3 = Item(image: "ic_logout", title: "Log out", detail: "Back to home screen", screenTo: "")
        
        return [data1,data2,data3]
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

extension ProfileMainUiViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let object = managerItem[indexPath.row]
        
        let nib = UINib(nibName: "SettingInfoTableViewCell", bundle: nil)
        
        if let cell = nib.instantiate(withOwner: nil, options: nil).first as? SettingInfoTableViewCell{
            cell.imageIcon.image = UIImage(named: object.image)
            cell.labelTitle.text = object.title
            cell.labelDetail.text = object.detail
            cell.imgSmallIcon.isHidden = false
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        

        if indexPath.row == 0 {
            let storyboard = UIStoryboard(name: "Home", bundle: nil)
            
            /**
             Step 1.2: Gọi ra instance của 1 viewcontroller bất kỳ dựa vào StoryboardID
             */
            
            let registerViewController: ProfileViewController = storyboard.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
            registerViewController.modalPresentationStyle = .fullScreen
            self.present(registerViewController, animated: true)
        } else if indexPath.row == 1 {
            // Thực hiện các thao tác khi chọn hàng thứ nhất
        } else if indexPath.row == 2 {
            AuthService.shared.clearAccessToken()
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            // Khởi tạo UINavigationController và thiết lập LoginViewController là root view controller
            let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
            let navigationController = UINavigationController(rootViewController: loginVC)
            
            // Thiết lập navigationController làm root view controller cho UIWindow
            if let uwWindow = (UIApplication.shared.delegate as? AppDelegate)?.window {
                uwWindow.rootViewController = navigationController
                uwWindow.makeKeyAndVisible()
            } else {
                print("LỖI")
            }
        }
    }
    
}

