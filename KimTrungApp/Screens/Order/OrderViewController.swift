//
//  OrderViewController.swift
//  KimTrungApp
//
//  Created by HieuNT on 27/02/2024.
//

import UIKit
import FirebaseDatabase
import MBProgressHUD
import KeychainSwift



class OrderViewController: UIViewController {
    
    
    @IBOutlet weak var fatherView: UIView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var noteView: UIView!
    @IBOutlet weak var totalLine: UIView!
    @IBOutlet weak var locationLine: UIView!
    var myView : UIView = UIView()
    @IBOutlet weak var totalLb: UILabel!
    var listCart : [FoodCart] = ServiceData.shared.getCartFood()
    var total : Double = ServiceData.shared.getCartFoodTotal()
    
    override func viewWillAppear(_ animated: Bool) {
        if let mainWindow = UIApplication.shared.keyWindow,
           let tabBarController = mainWindow.rootViewController as? UITabBarController,
           let mainTabBarController = tabBarController as? MainUiTabBarController {
            mainTabBarController.tabBar.isHidden = true
        }
        listCart = ServiceData.shared.getCartFood()
        total = ServiceData.shared.getCartFoodTotal()
        totalLb.text = "Total :   \(total)$"
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        noteView.layer.cornerRadius = 8
        btnSubmit.layer.cornerRadius = 8
        setUp(myView: totalLine, num: 2)
        setUp(myView: locationLine, num: 6)
        
        tableView.separatorStyle = .none
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.delegate = self
        tableView.dataSource = self
        totalLb.text = "Total :   \(total)$"
        //myView.removeFromSuperview()
     
    }
    
    
    func addView(customView : UIView) {
        customView.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        customView.translatesAutoresizingMaskIntoConstraints = false
        customView.backgroundColor = .white
        
        let imageEmpty = UIImage(named: "imageEmpty")
        let imageView = UIImageView(image: imageEmpty)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleToFill
        customView.addSubview(imageView)
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Cart is empty"
        label.font = UIFont(name: "Poppins", size: 28)
        let fontDescriptor = UIFontDescriptor(name: "Poppins", size: 28).withSymbolicTraits(.traitBold)
           let semiBoldFont = UIFont(descriptor: fontDescriptor!, size: 25)
           
           label.font = UIFontMetrics.default.scaledFont(for: semiBoldFont)
           label.adjustsFontForContentSizeCategory = true
        label.textColor = UIColor(red: 0.93119, green: 0.655, blue: 0.212083, alpha: 0.6)
        label.textAlignment = .center
        customView.addSubview(label)
        
        // Constraint: Image View
        
        let labelCenterXConstraint = NSLayoutConstraint(item: label, attribute: .centerX, relatedBy: .equal, toItem: customView, attribute: .centerX, multiplier: 1.0, constant: 0)
        customView.addConstraint(labelCenterXConstraint)
        
        let labelCenterYConstraint = NSLayoutConstraint(item: label, attribute: .centerY, relatedBy: .equal, toItem: customView, attribute: .centerY, multiplier: 1.0, constant: 0)
        customView.addConstraint(labelCenterYConstraint)
        
        imageView.widthAnchor.constraint(equalToConstant: 250).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 250).isActive = true
        
        let imageViewCenterXConstraint = NSLayoutConstraint(item: imageView, attribute: .centerX, relatedBy: .equal, toItem: customView, attribute: .centerX, multiplier: 1.0, constant: 0)
        customView.addConstraint(imageViewCenterXConstraint)
        
       
        
        // Constraint: Label
        
       
        
        imageView.bottomAnchor.constraint(equalTo: label.topAnchor, constant: 16).isActive = true
        
    }
    
    func showLoading(isShow: Bool) {
        if isShow {
            MBProgressHUD.showAdded(to: self.view, animated: true)
        } else {
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }

    
    @IBAction func tapBuy(_ sender: Any) {
 
        self.showLoading(isShow: true)

        let currentDate = Date()

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateString = formatter.string(from: currentDate)

        var userId = AuthService.shared.getAccessToken()
        var keychain = KeychainSwift()
        var listString = ServiceData.shared.getCartFoodString()

        let orderDict: [String: Any] = [
            "userId": userId,
            "dateOrder": dateString,
            "location": "HaNoi, VietNam",
            "status": "Wait",
            "total": String(total),
            "listFoodString": listString
        ]

        let databaseReference = Database.database().reference()
        let orderRef = databaseReference.child("Order")

        // Generate a new child auto ID for the order
        let childRef = orderRef.childByAutoId()

        // Get the new order ID from the child reference's key
        let orderId = childRef.key ?? ""

        // Add the orderId to the orderDict
        var orderDictWithId = orderDict
        orderDictWithId["orderId"] = orderId

        childRef.setValue(orderDictWithId) { (error, _) in
            self.showLoading(isShow: false)
            if let error = error {
                print("Error adding order to the database: \(error)")
                self.alertLoginError(message: String(error.localizedDescription))
            } else {
                ServiceData.shared.clearData()
                self.MotionToast(message: "Order successfully, please follow!", toastType: .success)
                DispatchQueue.main.asyncAfter(deadline: .now() + 2 ){
                    if let mainWindow = UIApplication.shared.keyWindow,
                       let tabBarController = mainWindow.rootViewController as? UITabBarController,
                       let mainTabBarController = tabBarController as? MainUiTabBarController {
                        mainTabBarController.tabBar.isHidden = false
                        mainTabBarController.selectedIndex = 3
                    }
                }
                print("Order added successfully with ID: \(orderId)")
            }
        }
    }
    
//    let orderCart = Order(dict: ["userId" : userId,
//                                         "dateOrder" :   String(dateOrder),
//                                         "location" : "HaNoi, VietNam",
//                                         "status" : "Wait" ,
//                                         "total" : String(total),
//                                         "listFoods" : listCart
//                                        ])
    
    @IBAction func tapBack(_ sender: Any) {
        if let mainWindow = UIApplication.shared.keyWindow,
           let tabBarController = mainWindow.rootViewController as? UITabBarController,
           let mainTabBarController = tabBarController as? MainUiTabBarController {
            mainTabBarController.tabBar.isHidden = false
            
            tabBarController.selectedIndex = 0
        }
    }
    
    private func alertLoginError(title: String? = "Error", message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Try again", style: .cancel)
        alertVC.addAction(okAction)
        present(alertVC, animated: true)
    }
    
    func setUp( myView : UIView, num : Int!){
        
       
        myView.layer.backgroundColor = .none
        let shapeLayer = CAShapeLayer()
               shapeLayer.strokeColor = UIColor.lightGray.cgColor
               shapeLayer.lineWidth = 1
               shapeLayer.lineDashPattern = [NSNumber(value: num), NSNumber(value: num)] 
        // Đặt độ dài và khoảng cách của đoạn line
               
               let path = CGMutablePath()
        path.addLines(between: [CGPoint(x: myView.bounds.minX, y: myView.bounds.minY / 2), CGPoint(x: myView.bounds.width, y: myView.bounds.height / 2)]) // Vẽ line ngang giữa view
               
               shapeLayer.path = path
        myView.layer.addSublayer(shapeLayer)
    }
    
    
}

extension OrderViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
       print("đang select nè")
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     
        if listCart.count == 0 {
            if myView == myView {
                addView(customView: myView)
                fatherView.addSubview(myView)
                myView.leadingAnchor.constraint(equalTo: fatherView.leadingAnchor, constant: 0).isActive = true
                myView.trailingAnchor.constraint(equalTo: self.fatherView.trailingAnchor, constant: 0).isActive = true
                myView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 0).isActive = true
                
                // Constraint: Bottom edge to btnSubmit with 32 spacing
                myView.bottomAnchor.constraint(equalTo: fatherView.bottomAnchor, constant: 0).isActive = true
            } else {
                let myView = UIView()
                addView(customView: myView)
                fatherView.addSubview(myView)
                myView.leadingAnchor.constraint(equalTo: fatherView.leadingAnchor, constant: 0).isActive = true
                myView.trailingAnchor.constraint(equalTo: self.fatherView.trailingAnchor, constant: 0).isActive = true
                myView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 0).isActive = true
                
                // Constraint: Bottom edge to btnSubmit with 32 spacing
                myView.bottomAnchor.constraint(equalTo: fatherView.bottomAnchor, constant: 0).isActive = true
            }
        } else {
            //print(listCart.count)
            
                myView.removeFromSuperview()
            
        }
        
        return listCart.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let nib = UINib(nibName: "OrderDetailTableViewCell", bundle: nil)
        if let cell = nib.instantiate(withOwner: nil, options: nil).first as? OrderDetailTableViewCell{
            cell.setData(x: listCart[indexPath.row])
            cell.indexCell = indexPath.row
            cell.delegate = self
            
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height = tableView.bounds.height / 3
        return height
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
   
    
    
}

extension OrderViewController : DeleteCellProtocol{
   
    
    func tapCellAt(at indexPath: Int) {
           let id = listCart[indexPath].foodId
            let storyboard = UIStoryboard(name: "Home", bundle: nil)
            let screenVC = storyboard.instantiateViewController(withIdentifier: "ProductDetailViewController") as! ProductDetailViewController
            let databaseReference = Database.database().reference()
            let userReference = databaseReference.child("Foods")
            
            self.showLoading(isShow: true)
            
            
            userReference.queryOrdered(byChild: "foodId").queryEqual(toValue: id).observe(.childAdded) { snapshot in
                databaseReference.child("Foods").child(snapshot.key).observeSingleEvent(of: .value) {
                    dataSnapshot,error  in
                    if let dict = dataSnapshot.value as? [String: Any] {
                        let user = Food(dict: dict)
                       
                        let food : Food = user
                        screenVC.data = food
                        // Xử lý thông tin người dùng
                        //print("Thông tin người dùng là: \(user.email)")
                        //print(self.userGetData.email)
                        //print("nhận data thành công")
                        self.showLoading(isShow: false)
                        screenVC.modalPresentationStyle = .fullScreen
                        self.present(screenVC, animated: true)
                    }
                }
               
            }
           
           // performSegue(withIdentifier: "detailsviewcontrollerseg", sender: self)
            // You can also do changes to the cell you tapped using the 'collectionviewcell'
        }
    
    
    func deleteButtonTapped(at indexPath: Int) {
        print("đã xoá cell \(indexPath)")
        ServiceData.shared.deleteFood(x: indexPath)
        listCart = ServiceData.shared.getCartFood()
        tableView.reloadData()
        total = ServiceData.shared.getCartFoodTotal()
        totalLb.text = "Total :   \(total)$"
    }
    
    
}

