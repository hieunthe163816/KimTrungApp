//
//  HomeViewController.swift
//  KimTrungApp
//
//  Created by HieuNT on 27/02/2024.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage
import MBProgressHUD

class HomeViewController: UIViewController {

    @IBOutlet weak var viewSearch: UIView!
    @IBOutlet weak var lbInfoLocation: UILabel!
    @IBOutlet weak var iconLocation: UIImageView!
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var listFood: [Food] = []
    var listFood2: [Food] = []
    
    
    var managerItem: [Item] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        managerItem = dummyData()
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        // Do any additional setup after loading the view.
        tableView.register(UINib(nibName: "BannerTableViewCell", bundle: nil), forCellReuseIdentifier: "BannerTableViewCell")
        tableView.register(UINib(nibName: "FoodInfoTableViewCell", bundle: nil), forCellReuseIdentifier: "FoodInfoTableViewCell")
        //pushDataToFirebase()
        tableView.register(UINib(nibName: "BannerSaleTableViewCell", bundle: nil), forCellReuseIdentifier: "BannerSaleTableViewCell")
        
        getDataByFirebase()
        getDataByFirebaseSale()
    }
    
    
    @IBAction func tapSearch(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "SearchScreen", bundle: nil)
        
        let searchVc = storyBoard.instantiateViewController(identifier: "SearchViewController")
        searchVc.modalPresentationStyle = .fullScreen
        self.present(searchVc, animated: true)
    }
    
    func pushDataToFirebase(){
        let databaseReference = Database.database().reference()
        let value = [ ["foodId": "",
                      "foodName": "20 Chicken McNuggets",
                      "foodImg": "Products/Foods/food_1.png",
                      "foodStar": "4.5",
                      "soldQuantity": "100",
                      "foodPrice": "10.5",
                      "foodPrecentPrice": "10",
                      "detailsFood": "Delicious chicken with lettuce, tomato, and cheese.",
                       "category" : "chicken"],
                      [
                        "foodId": "",
                                      "foodName": "6 Chicken Wings",
                                      "foodImg": "Products/Foods/food2.png",
                                      "foodStar": "4.0",
                                      "soldQuantity": "202",
                                      "foodPrice": "8.5",
                                      "foodPrecentPrice": "0",
                                      "detailsFood": "Delicious chicken with lettuce, tomato, and cheese.",
                                       "category" : "chicken"
                      ],
                      [
                        "foodId": "",
                                      "foodName": "6 Chicken McNuggets",
                                      "foodImg": "Products/Foods/food3.png",
                                      "foodStar": "2.0",
                                      "soldQuantity": "22",
                                      "foodPrice": "2.5",
                                      "foodPrecentPrice": "0",
                                      "detailsFood": "Delicious chicken with lettuce, tomato, and cheese.",
                                       "category" : "chicken"
                      ],
                      [
                        "foodId": "",
                                      "foodName": "Combo 2 chicken and drink",
                                      "foodImg": "Products/Foods/food4.png",
                                      "foodStar": "4.0",
                                      "soldQuantity": "2223",
                                      "foodPrice": "7.5",
                                      "foodPrecentPrice": "0",
                                      "detailsFood": "The best of your choice",
                                       "category" : "combo"
                      ],
                      [
                        "foodId": "",
                                      "foodName": "1 piece of fried chicken",
                                      "foodImg": "Products/Foods/food5.png",
                                      "foodStar": "3.0",
                                      "soldQuantity": "123",
                                      "foodPrice": "1.5",
                                      "foodPrecentPrice": "0",
                                      "detailsFood": "Delicious chicken with lettuce, tomato, and cheese.",
                                       "category" : "chicken"
                      ],
                      [
                        "foodId": "",
                                      "foodName": "3 chicken wings",
                                      "foodImg": "Products/Foods/food6.png",
                                      "foodStar": "4.0",
                                      "soldQuantity": "1223",
                                      "foodPrice": "3.5",
                                      "foodPrecentPrice": "0",
                                      "detailsFood": "Delicious chicken with lettuce, tomato, and cheese.",
                                       "category" : "chicken"
                      ],
                      [
                        "foodId": "",
                                      "foodName": "Special Beef Cheese Burger",
                                      "foodImg": "Products/Foods/food7.png",
                                      "foodStar": "5.0",
                                      "soldQuantity": "123",
                                      "foodPrice": "3.5",
                                      "foodPrecentPrice": "0",
                                      "detailsFood": "Delicious Burger with lettuce, tomato, and cheese.",
                                       "category" : "buger"
                      ],
                      [
                        "foodId": "",
                                      "foodName": "Burger with 2 layers of beef and cheese",
                                      "foodImg": "Products/Foods/food8.png",
                                      "foodStar": "5.0",
                                      "soldQuantity": "123",
                                      "foodPrice": "3.5",
                                      "foodPrecentPrice": "10",
                                      "detailsFood": "Delicious Burger with lettuce, tomato, and cheese.",
                                       "category" : "buger"
                      ],
                      [
                        "foodId": "",
                                      "foodName": "Large Beef and Cheese Burger",
                                      "foodImg": "Products/Foods/food9.png",
                                      "foodStar": "4.0",
                                      "soldQuantity": "1223",
                                      "foodPrice": "2.5",
                                      "foodPrecentPrice": "20",
                                      "detailsFood": "Delicious Burger with lettuce, tomato, and cheese.",
                                       "category" : "buger"
                      ],
                      [
                        "foodId": "",
                                      "foodName": "Special Royal Beef Burger",
                                      "foodImg": "Products/Foods/food10.png",
                                      "foodStar": "2.5",
                                      "soldQuantity": "223",
                                      "foodPrice": "3.5",
                                      "foodPrecentPrice": "0",
                                      "detailsFood": "Delicious Burger with lettuce, tomato, and cheese.",
                                       "category" : "buger"
                      ],
                      [
                        "foodId": "",
                                      "foodName": "Buger Big Mac",
                                      "foodImg": "Food11.png",
                                      "foodStar": "4.5",
                                      "soldQuantity": "2223",
                                      "foodPrice": "6.5",
                                      "foodPrecentPrice": "20",
                                      "detailsFood": "Delicious Burger with lettuce, tomato, and cheese.",
                                       "category" : "buger"
                      ],
                      [
                        "foodId": "",
                                      "foodName": "Cake and coffee",
                                      "foodImg": "Products/Foods/food14.png",
                                      "foodStar": "3.5",
                                      "soldQuantity": "23",
                                      "foodPrice": "4.5",
                                      "foodPrecentPrice": "20",
                                      "detailsFood": "Good combo.",
                                       "category" : "combo"
                      ]
        ]
        
        let foodsRef = databaseReference.child("Foods")
        
        for foodDict in value {
            let childRef = foodsRef.childByAutoId() // Create a new child node with auto-generated ID
            let food = Food(dict: foodDict)
            childRef.setValue(food.dictionaryRepresentation(id: childRef.key!))
        }
    }
   
    func getDataByFirebase(){
        
        let databaseReference = Database.database().reference()
        databaseReference.child("Foods").observe(.childAdded) { snapshot in
            databaseReference.child("Foods").child(snapshot.key).observe(.value) { data in
                dump(data.value)
                if let dict = data.value as? [String: Any] {
                    let food = Food(dict: dict)
                    self.listFood.append(food)
                    //self.stopAnimating()
                    self.tableView.reloadData()
                    databaseReference.child("Foods").child(snapshot.key).removeAllObservers()
                }
            }
        }
    }
   
    func getDataByFirebaseSale() {
        let databaseReference = Database.database().reference()
        databaseReference.child("Foods").observe(.childAdded) { snapshot in
            databaseReference.child("Foods").child(snapshot.key).observe(.value) { data in
                dump(data.value)
                if let dict = data.value as? [String: Any] {
                    
                        let food = Food(dict: dict)
                    if Int(food.foodPrecentPrice) ?? -1 > 0 {
                        self.listFood2.append(food)
                        //self.stopAnimating()
                        self.tableView.reloadData()
                        databaseReference.child("Foods").child(snapshot.key).removeAllObservers()
                    }
                       
                    
                }
            }
        }
        
       // print(self.listFood2.count)
        
    }
    
    
    func showLoading(isShow: Bool) {
        if isShow {
            MBProgressHUD.showAdded(to: self.view, animated: true)
        } else {
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
    
    private func setUp() {
        viewSearch.backgroundColor = UIColor(red: 243/255, green: 243/255, blue: 243/255, alpha: 1.0)
        viewSearch.layer.cornerRadius = 18
        self.iconLocation.tintColor =  UIColor(red: 231/255, green: 151/255, blue: 41/255, alpha: 1.0)
    }

    private func dummyData() -> [Item]{
        let cell1 = Item(typeCell: .banner)
        let cell2 = Item(typeCell: .seller)
        let cell3 = Item(typeCell: .ads)
        let cell4 = Item(typeCell: .falshSell)
        let cell5 = Item(typeCell: .mustTry)
        let cell6 = Item(typeCell: .restaurant)
        
        return [cell1, cell2,cell3,cell4]
    }
    
    enum TypeCell {
        case banner
        case seller
        case ads
        case falshSell
        case mustTry
        case restaurant
    }
    
    struct Item{
        var typeCell: TypeCell
    }

    

}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return managerItem.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let object = managerItem[indexPath.row]

        switch object.typeCell{
            
        case .banner:
            let cellBanner = tableView.dequeueReusableCell(withIdentifier: "BannerTableViewCell", for: indexPath) as! BannerTableViewCell
            return cellBanner
            break
        case .seller:
            let cellFlashSale = tableView.dequeueReusableCell(withIdentifier: "FoodInfoTableViewCell", for: indexPath) as! FoodInfoTableViewCell
            cellFlashSale.cellDelegate = self
            cellFlashSale.updateCellWith(row: listFood)
            cellFlashSale.titleLb.text = "Top Seller"
            return cellFlashSale
            break
            
            
        case .ads:
            let cellSale = tableView.dequeueReusableCell(withIdentifier: "BannerSaleTableViewCell", for: indexPath) as! BannerSaleTableViewCell
            return cellSale
            break
            
        case .falshSell:
          
            let cellFood = tableView.dequeueReusableCell(withIdentifier: "FoodInfoTableViewCell", for: indexPath) as! FoodInfoTableViewCell
            cellFood.titleLb.text = "Flash Sale"
            cellFood.cellDelegate = self
            cellFood.updateCellWith(row: listFood2)
            return cellFood
        case .mustTry:
            break
        case .restaurant:
            break
        }
        
       return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let object = managerItem[indexPath.row]
        
        switch object.typeCell{
            
        case .banner:
            return 145 + 22 + 8 + 2
        case .seller:
            return 286
        case .ads:
            return 150 + 32
        case .falshSell:
            return 286
            break
        case .mustTry:
            break
        case .restaurant:
            break
        }
        
        return 0
    }
    
        
}


extension Food {
    func dictionaryRepresentation(id : String) -> [String: Any] {
        return [
            "foodId": id,
            "foodName": foodName,
            "foodImg": foodImg,
            "foodStar": foodStar,
            "soldQuantity": soldQuantity,
            "foodPrice": foodPrice,
            "foodPrecentPrice": foodPrecentPrice,
            "detailsFood": detailsFood,
            "category": category
        ]
    }
}

extension HomeViewController: CollectionViewCellDelegate {
    func collectionView(collectionviewcell: InfoProductCollectionViewCell?, index: Int, didTappedInTableViewCell: FoodInfoTableViewCell) {
        if let colorsRow = didTappedInTableViewCell.rowFoods {
           let id = colorsRow[index].foodId
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
    }
    

}






