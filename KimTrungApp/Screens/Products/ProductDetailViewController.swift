//
//  ProductDetailViewController.swift
//  KimTrungApp
//
//  Created by HieuNT on 13/03/2024.
//

import UIKit
import MGStarRatingView
import FirebaseStorage
import SDWebImage

class ProductDetailViewController: UIViewController {

    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var addImg: UIImageView!
    @IBOutlet weak var subImg: UIImageView!
    @IBOutlet weak var noteView: UIView!
    @IBOutlet weak var priceLb: UILabel!
    @IBOutlet weak var detailLb: UILabel!
    @IBOutlet weak var soldLb: UILabel!
    @IBOutlet weak var starLb: UILabel!
    @IBOutlet weak var dot: UIView!
   //@IBOutlet weak var starView: StarRatingView!
    @IBOutlet weak var productNameLb: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var cancelView: UIView!
   
    @IBOutlet weak var quantityTF: UITextField!
    var data : Food?
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        uploadData()
        quantityTF.text = "1"
        if let data = data{
           // print("data là : \(data)")
            let temp = Double(data.foodStar) ?? 0
               let star = CGFloat(temp)
               // Use star of type CGFloat
//            StarRatingValueChanged(view: starView, value: star)
//            starView.current = star
//            starView.isUserInteractionEnabled = false
//            starView.gestureRecognizers?.forEach { $0.isEnabled = false }
               //print(star)
           }
        
        print("type là : \(type(of: self.tabBarController))")
        
        
        //ServiceData.shared.clearData()
        //ServiceData.shared.setData()
        //print("ServiceData : \(ServiceData.shared.getCartFood()) and Normal data là : ")
//        self.StarRatingValueChanged(view: starView, value: CGFloat(from: data!.foodStar))
        // Do any additional setup after loading the view.
    }
    
    func uploadData(){
        if let data = data{
            priceLb.text = data.foodPrice
            detailLb.text = data.detailsFood
            soldLb.text = "Sold : \(data.soldQuantity)"
            starLb.text = data.foodStar
            productNameLb.text = data.foodName
            test1(link: data.foodImg)
        }
    }
    
    @IBAction func tapCancel(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func click(_ sender: Any) {
        print("on click")
        self.dismiss(animated: true)
    }
    
    
    @IBAction func tapSub(_ sender: Any) {
        self.checkQuantity(quantity: quantityTF.text ?? "", type: false)
        print("on click sub")
    }
    
    @IBAction func tapAdd(_ sender: Any) {
        self.checkQuantity(quantity: quantityTF.text ?? "", type: true)
    }
    
    @IBAction func submitBtn(_ sender: Any) {
       
        ServiceData.shared.addCartFood(y: data!)
        if let mainWindow = UIApplication.shared.keyWindow,
           let tabBarController = mainWindow.rootViewController as? UITabBarController,
           let mainTabBarController = tabBarController as? MainUiTabBarController {
            mainTabBarController.updateCartBadgeValue()
        }
    }
    
    func test1(link: String){
        let storageRef = Storage.storage().reference().child(link)
                
                // Tải ảnh từ URL và hiển thị trong UIImageView
                storageRef.downloadURL { url, error in
                    if let error = error {
                       // print("Error downloading image: \(error.localizedDescription)")
                    } else if let imageURL = url {
                      
                        self.productImage.sd_setImage(with: imageURL, placeholderImage: UIImage(named: "placeholder"), options: [], completed: { (image, error, cacheType, imageURL) in
                            if let error = error {
                                // print(error.localizedDescription)
                            } else {
                                print("Image loaded successfully")
                            }
                        })
                    }
                    }
                }

    
    func setUp(){
        addImg.layer.cornerRadius = 25
        subImg.layer.cornerRadius = 25
        submitBtn.layer.cornerRadius = 12
        noteView.layer.borderWidth = 1
        noteView.layer.borderColor = UIColor.gray.cgColor
        cancelView.layer.cornerRadius = 15
        noteView.layer.cornerRadius = 8
    }

    
    func checkQuantity(quantity: String, type: Bool) {
        if let intQuantity = Int(quantity) {
            var updatedQuantity: Int
            if type {
                updatedQuantity = min(intQuantity + 1, 50)
            } else {
                updatedQuantity = max(intQuantity - 1, 1)
            }
            quantityTF.text = String(updatedQuantity)
        } else {
            quantityTF.text = "1"
        }
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

//extension ProductDetailViewController : StarRatingDelegate{
//    func StarRatingValueChanged(view: MGStarRatingView.StarRatingView, value: CGFloat) {
//    }
//}
