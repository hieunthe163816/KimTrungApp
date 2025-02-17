//
//  OrderDetailsViewController.swift
//  KimTrungApp
//
//  Created by HieuNT on 18/05/2024.
//

import UIKit
import FirebaseDatabase
import MBProgressHUD
import FirebaseStorage

class OrderDetailsViewController: UIViewController {
    @IBOutlet weak var titleImage: UIImageView!
    @IBOutlet weak var constrainHeightTableView: NSLayoutConstraint!
    @IBOutlet weak var titleDetailLb: UILabel!
    @IBOutlet weak var titleLb: UILabel!
    @IBOutlet weak var viewBtn: UIView!
    @IBOutlet weak var viewStack2: UIView!
    @IBOutlet weak var viewStack1: UIView!
    @IBOutlet weak var time2: UILabel!
    @IBOutlet weak var time1: UILabel!
    @IBOutlet weak var orderId: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var shipAddress: UILabel!
    @IBOutlet weak var shipPhone: UILabel!
    @IBOutlet weak var shipName: UILabel!
    @IBOutlet weak var shipDate: UILabel!
    @IBOutlet weak var shipStatus: UILabel!
    @IBOutlet weak var viewShip: UIView!
    
    @IBOutlet weak var titleBtnSubmit: UILabel!
    
    enum statusOrder : String {
        
        case wait = "Shipper is in the process of delivering your order, please wait and pay attention to the phone."
        
        case done = "There is a problem with your order, you can submit a Return/Refund request within 15 minutes"
        
        case cancel = "Thank you for your interest in the product. Hope to be able to serve you next time."
    }
    var idOrder : String?
    var listOrder : Order?
    var orderDetail : [FoodCart] = []
    
    enum caseBtn {
        case wait
        case done
        case cancel
    }
    
    var btnType : caseBtn = .wait
    //ServiceData.shared.convertToFoodList(from: order.listFoodString)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp();
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(UINib(nibName: "HistoryOrderTableViewCell", bundle: nil), forCellReuseIdentifier: "HistoryOrderTableViewCell")
        tableView.register(UINib(nibName: "TotalHistoryTableViewCell", bundle: nil), forCellReuseIdentifier: "TotalHistoryTableViewCell")
        getDataByFirebase()
        // Do any additional setup after loading the view.
    }
    

    
    // Action in here
    
    @IBAction func clickBack(_ sender: Any) {
        self.dismiss(animated: true)
       
    }
    
    @IBAction func tapBuyAgain(_ sender: Any) {
        addToCart()
        self.MotionToast(message: "Products have been added back to cart, Please go to cart to check.", toastType: .success)
    }
    
    
    @IBAction func tapSubmit(_ sender: Any) {
        
        switch btnType {
        case .wait:
           break
        case .done:
            
            self.MotionToast(message: "This feature is under development!", toastType: .warning)
        case .cancel:
            
            addToCart()
            self.MotionToast(message: "Products have been added back to cart, Please go to cart to check.", toastType: .success)
        }
        
    }
    
    func setUpBtn(){
        switch btnType {
        case .wait:
            titleBtnSubmit.text = "Waitting ..."
        case .done:
            titleBtnSubmit.text = "Rate for product"
            
        case .cancel:
            titleBtnSubmit.text = "Buy Again"
            
        }
    }
    // write function in here
    
        // set up func
     
    private func setUp(){
        viewShip.layer.cornerRadius = 5
        viewStack1.layer.borderWidth = 1
        viewStack1.layer.cornerRadius = 8
        viewStack1.layer.borderColor = UIColor.lightGray.cgColor
        viewStack2.layer.cornerRadius = 5
        viewStack2.layer.borderWidth = 1
        viewStack2.layer.borderColor = UIColor.lightGray.cgColor
        viewBtn.layer.cornerRadius = 8
    }
    
    func showLoading(isShow: Bool) {
        if isShow {
            MBProgressHUD.showAdded(to: self.view, animated: true)
        } else {
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
    
    private func alertError(title: String? = "Error", message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Try again", style: .cancel){ _ in
            self.dismiss(animated: true)
        }
        alertVC.addAction(okAction)
        present(alertVC, animated: true)
    }
    
    func getDataByFirebase(){
        
        let userId = AuthService.shared.getAccessToken()
        let databaseReference = Database.database().reference()
        databaseReference.child("Order").observe(.childAdded) { snapshot in
            databaseReference.child("Order").child(snapshot.key).observe(.value) { data,error  in
                dump(data.value)
                if let dict = data.value as? [String: Any] {
                    
                    let food = Order(dict: dict)
                    
                    if  food.id == self.idOrder {
                        print(" id và listOrder là : \(self.idOrder) và \(food.id)")
                        self.listOrder = food
                        
                        self.orderDetail = ServiceData.shared.convertToFoodList(from: food.listFoodString)
                        
                        self.constrainHeightTableView.constant = CGFloat(98 * self.orderDetail.count + 54)
                        print("order detail là : \(self.orderDetail.count) và \(self.orderDetail)")
                        self.tableView.reloadData()
                        self.showLoading(isShow: false)
                    }
                    
                } else {
                    // handle case when data is not found
                    self.showLoading(isShow: false)
                    self.alertError(message: "Can't find your order")
                }
                
            }
            
        }
    }
    
    private func addToCart(){
        ServiceData.shared.addCartFood(lst: orderDetail)
    }
    
    private func getCartById(id: String) {
        let databaseReference = Database.database().reference()
        let orderRef = databaseReference.child("Order")
        showLoading(isShow: true)

        orderRef.child(id).observeSingleEvent(of: .value) { snapshot in
            if let dict = snapshot.value as? [String: Any] {
                let food = Order(dict: dict)
                self.listOrder = food
                print(" id và listOrder là : \(self.idOrder) và \(food.id)")
                self.orderDetail = ServiceData.shared.convertToFoodList(from: food.listFoodString)
                
                self.constrainHeightTableView.constant = CGFloat(98 * self.orderDetail.count)
                self.tableView.reloadData()
                self.showLoading(isShow: false)
            } else {
                // handle case when data is not found
                self.showLoading(isShow: false)
            }
        } withCancel: { error in
            // handle error
            self.showLoading(isShow: false)
            self.alertError(message: error.localizedDescription)
        }
    }
   
    

}

extension OrderDetailsViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderDetail.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row < orderDetail.count {
            var cellOrder = tableView.dequeueReusableCell(withIdentifier: "HistoryOrderTableViewCell", for: indexPath) as! HistoryOrderTableViewCell
            cellOrder.nameHis.text = orderDetail[indexPath.row].foodName
            cellOrder.quantityLb.text = "X \(orderDetail[indexPath.row].soldQuantity)"
            let originalPrice = Double(orderDetail[indexPath.row].foodPrice) ?? 0
            let discountPercent = Double(orderDetail[indexPath.row].foodPrecentPrice) ?? 0
            let discountedPrice = originalPrice - (originalPrice * discountPercent/100)
            let totalPrice = discountedPrice * (Double(orderDetail[indexPath.row].soldQuantity) ?? 0)
            cellOrder.priceLb.text = "\(totalPrice) $"
            if self.listOrder?.status == "Wait" {
                self.shipStatus.text = "The deliver is on the way"
                self.shipDate.text = self.listOrder?.dateOrder
                self.titleLb.text = "Order is on its way"
                self.titleDetailLb.text = "Shipper is in the process of delivering your order, please wait and pay attention to the phone."
                self.btnType = .wait
               // self.shipName.text = "Order is on its way"
            } else if self.listOrder?.status == "Done" {
                self.shipStatus.text = "Delivery success"
                self.shipDate.text = self.listOrder?.dateOrder
                self.titleLb.text = "The order is successfully"
               // self.shipName.text = "The order is successfully"
                self.titleDetailLb.text = "There is a problem with your order, you can submit a Return/Refund request within 15 minutes"
                self.btnType = .done
            } else {
                self.shipStatus.text = "The order was canceled"
                self.shipDate.text = self.listOrder?.dateOrder
                self.titleLb.text = "The order is canceled"
                self.titleDetailLb.text = "Thank you for your interest in the product. Hope to be able to serve you next time."
                self.btnType = .cancel
               // self.shipName.text = "The order is canceled"
            }
            
            self.setUpBtn()
            let storageRef = Storage.storage().reference().child(orderDetail[indexPath.row].foodImg)
                    
            storageRef.downloadURL { url, error in
                if let error = error {
                    // Handle the error
                    print("Error downloading image: \(error.localizedDescription)")
                } else if let imageURL = url {
                    cellOrder.imageHis.sd_setImage(with: imageURL, placeholderImage: UIImage(named: "placeholder"), options: [], completed: { (image, error, cacheType, imageURL) in
                        if let error = error {
                            // Handle the error
                            print(error.localizedDescription)
                        } else {
                            print("Image loaded successfully")
                        }
                    })
                }
            }
            return cellOrder
        } else {
            var cellTotal = tableView.dequeueReusableCell(withIdentifier: "TotalHistoryTableViewCell", for: indexPath) as! TotalHistoryTableViewCell
            var total = ServiceData.shared.getCartFoodTotalSt(listCart: orderDetail)
            cellTotal.price.text = "\(total.0) $"
            return cellTotal
        }
        
        return UITableViewCell()
    }
    
}
