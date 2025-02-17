//
//  InfoProductCollectionViewCell.swift
//  KimTrungApp
//
//  Created by HieuNT on 09/01/2024.
//

import UIKit
import FirebaseStorage

class InfoProductCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var soldLb: UILabel!
    @IBOutlet weak var dotView: UIView!
    @IBOutlet weak var starLb: UILabel!
    @IBOutlet weak var priceFoodLb: UILabel!
    @IBOutlet weak var nameFoodTitle: UILabel!
    @IBOutlet weak var precentLb: UILabel!
    @IBOutlet weak var saleView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        dotView.layer.cornerRadius = 2.5
        
    }
    
    func test1(link: String){
        let storageRef = Storage.storage().reference().child(link)
                
                // Tải ảnh từ URL và hiển thị trong UIImageView
                storageRef.downloadURL { url, error in
                    if let error = error {
                       // print("Error downloading image: \(error.localizedDescription)")
                    } else if let imageURL = url {
                      
                        self.imageView.sd_setImage(with: imageURL, placeholderImage: UIImage(named: "placeholder"), options: [], completed: { (image, error, cacheType, imageURL) in
                            if let error = error {
                                // print(error.localizedDescription)
                            } else {
                               // print("Image loaded successfully")
                            }
                        })
                    }
                    }
                }
    
    
    func setDataForCell(foodA: Food?) {
        if let foodD = foodA {
            soldLb.text = "Sold : \(foodD.soldQuantity)"
            starLb.text = foodD.foodStar
            var price : Double = Double(foodD.foodPrice) ?? 0
            var percent : Double = Double(foodD.foodPrecentPrice) ?? 0
            var realPrice = price - price * percent / 100
            priceFoodLb.text = String(realPrice)
            nameFoodTitle.text = foodD.foodName
            precentLb.text = "\(foodD.foodPrecentPrice) %"
            if percent > 0 {
                saleView.isHidden = false
            } else {
                saleView.isHidden = true
            }
            
            var imageURL = foodD.foodImg
            
            test1(link: imageURL)
            
//            self.imageView.sd_setImage(with: URL(string: imageURL), placeholderImage: UIImage(named: "placeholder"), options: [], completed: { (image, error, cacheType, imageURL) in
//                if let error = error {
//                    print(error.localizedDescription)
//                    //self.alertLoginError(title: "Error", message: error.localizedDescription)
//                } else {
//                    print("Image loaded successfully")
//                }
//            })
    }
        }
       
                                   }
                                   
                                   
