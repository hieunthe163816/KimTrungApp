//
//  CartViewController.swift
//  KimTrungApp
//
//  Created by HieuNT on 07/04/2024.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage

class CartViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var historyView: UIView!
    @IBOutlet weak var deliverView: UIView!
    
    @IBOutlet weak var stackView: UIStackView!
    
    var listOrder : [Order] = []
    var isDeliver = true
    override func viewDidLoad() {
        super.viewDidLoad()
        
        stackView.layer.cornerRadius = 12
        stackView.layer.borderWidth = 1
        stackView.layer.borderColor = UIColor(red: 0.93119, green: 0.655, blue: 0.212083, alpha: 1).cgColor
        setUp(viewSet: historyView)
        setUp(viewSet: deliverView)
        setDone(view1: deliverView, view2: historyView)
        tableView.separatorStyle = .none
        tableView.separatorInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "OrderTableViewCell", bundle: nil), forCellReuseIdentifier: "OrderTableViewCell")
        tableView.register(UINib(nibName: "SpaceTableViewCell", bundle: nil), forCellReuseIdentifier: "SpaceTableViewCell")
        // Do any additional setup after loading the view.
        getDataByFirebase()
    }
    
    func setUp( viewSet: UIView){
        viewSet.layer.cornerRadius = 12
//        viewSet.layer.borderWidth = 1
//        viewSet.layer.borderColor = UIColor(red: 0.93119, green: 0.655, blue: 0.212083, alpha: 1).cgColor
        
    }
    
    func setDone(view1: UIView, view2: UIView) {
        UIView.animate(withDuration: 0.2) {
            view1.backgroundColor = UIColor(red: 0.93119, green: 0.655, blue: 0.212083, alpha: 1)
            view2.backgroundColor = .white
        }
    }
    
    func getDataByFirebase(){
        listOrder.removeAll()
        let userId = AuthService.shared.getAccessToken()
        let databaseReference = Database.database().reference()
        databaseReference.child("Order").observe(.childAdded) { snapshot in
            databaseReference.child("Order").child(snapshot.key).observe(.value) { data in
                dump(data.value)
                if let dict = data.value as? [String: Any] {
                    
                    let food = Order(dict: dict)
                    if food.userId == userId && (food.status.elementsEqual("Wait") || food.status.elementsEqual("Deliver")){
                        self.listOrder.append(food)
                        //print("food là : \(food.userId) và")
                        self.tableView.reloadData()
                        databaseReference.child("Order").child(snapshot.key).removeAllObservers()
                    }
                    
                    //self.stopAnimating()
                    
                    
                }
                //print("List order = \(self.listOrder.count)")
            }
            
        }
    }
    
    func getDataByFirebaseDone(){
        listOrder.removeAll()
        let userId = AuthService.shared.getAccessToken()
        let databaseReference = Database.database().reference()
        databaseReference.child("Order").observe(.childAdded) { snapshot in
            databaseReference.child("Order").child(snapshot.key).observe(.value) { data in
                dump(data.value)
                if let dict = data.value as? [String: Any] {
                    
                    let food = Order(dict: dict)
                    if food.userId == userId && (food.status.elementsEqual("Done") || food.status.elementsEqual("Cancel")){
                        self.listOrder.append(food)
                        //print("food là : \(food.userId) và")
                        self.tableView.reloadData()
                        databaseReference.child("Order").child(snapshot.key).removeAllObservers()
                    }
                    
                    //self.stopAnimating()
                    
                    
                }
                print("List order = \(self.listOrder.count)")
            }
            
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

    @IBAction func tapDeliver(_ sender: Any) {
        isDeliver = true
        setDone(view1: deliverView, view2: historyView)
        getDataByFirebase()
    }
    
    @IBAction func tapHistory(_ sender: Any) {
        isDeliver = false
        setDone(view1: historyView, view2: deliverView)
        getDataByFirebaseDone()
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

extension CartViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOrder.count + 1
    }
    
    //incomingMessageBackground
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SpaceTableViewCell", for: indexPath) as! SpaceTableViewCell
            
            return cell
        }
       
        var cellFood = tableView.dequeueReusableCell(withIdentifier: "OrderTableViewCell", for: indexPath) as! OrderTableViewCell
        var order = listOrder[indexPath.row - 1]
        
        var orderDetail = ServiceData.shared.convertToFoodList(from: order.listFoodString)
        cellFood.foodLb.text = orderDetail[0].foodName
        cellFood.statusLb.text = order.status
        let storageRef = Storage.storage().reference().child(orderDetail[0].foodImg)
        cellFood.dateLb.text = String(order.dateOrder.split(separator: " ")[0])
        //order.dateOrder.split(separator: " ")
        storageRef.downloadURL { url, error in
            if let error = error {
                // Handle the error
                print("Error downloading image: \(error.localizedDescription)")
            } else if let imageURL = url {
                cellFood.imageFood.sd_setImage(with: imageURL, placeholderImage: UIImage(named: "placeholder"), options: [], completed: { (image, error, cacheType, imageURL) in
                    if let error = error {
                        // Handle the error
                        print(error.localizedDescription)
                    } else {
                        print("Image loaded successfully")
                    }
                })
            }
        }
        
       
        cellFood.orderLb.text = order.id
        var total = ServiceData.shared.getCartFoodTotalSt(listCart: orderDetail)
        cellFood.totalLb.text = "\(total.0) $"
        cellFood.mealLb.text = "\(total.1) items"
        
        
        
        return cellFood
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // order lấy ra từ list trừ 1 đi
       // var order = listOrder[indexPath.row - 1]
        //self.alertError(message: order.id)
        let storyBoard = UIStoryboard(name: "SearchScreen", bundle: nil)
        
        let screenVC = storyBoard.instantiateViewController(identifier: "OrderDetailsViewController") as! OrderDetailsViewController
        var order = listOrder[indexPath.row - 1]
        screenVC.idOrder = order.id
        screenVC.modalPresentationStyle = .fullScreen
        self.present(screenVC, animated: true)
//        print(indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 252
    }
    
    // Override phương thức tableView(_:willDisplay:forRowAt:) để thiết lập khoảng cách giữa các cell
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // Thiết lập khoảng cách giữa các cell
        cell.contentView.layoutMargins = UIEdgeInsets(top: 50, left: 16, bottom: 50, right: 50)
    }


}


