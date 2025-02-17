//
//  SearchViewController.swift
//  KimTrungApp
//
//  Created by HieuNT on 10/04/2024.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage
import MBProgressHUD

class SearchViewController: UIViewController {

    @IBOutlet weak var viewText: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchTf: UITextField!
    @IBOutlet weak var viewTxt: UIView!
    @IBOutlet weak var btnSearch: UIButton!
    var listFood : [Food] = []
    
    var searchText = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        viewTxt.layer.borderWidth = 2
        viewTxt.layer.borderColor = btnSearch.backgroundColor?.cgColor
        //print(btnSearch.backgroundColor?.cgColor)
        viewText.layer.borderColor = btnSearch.backgroundColor?.cgColor
        // Radius của góc bo tròn
        btnSearch.clipsToBounds = true
        viewTxt.clipsToBounds = true
        viewText.clipsToBounds = true
        // Do any additional setup after loading the view.
        let cornerRadius: CGFloat = 10.0 // Bán kính bo tròn
        let maskPath = UIBezierPath(roundedRect: btnSearch.bounds,
                                    byRoundingCorners: [.topRight, .bottomRight],
                                    cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
        let maskPath2 = UIBezierPath(roundedRect: viewTxt.bounds,
                                    byRoundingCorners: [.topLeft, .bottomLeft],
                                    cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
        
        let maskPath3 = UIBezierPath(roundedRect: viewText.bounds,
                                    byRoundingCorners: [.topLeft, .bottomLeft],
                                    cornerRadii: CGSize(width: 10  , height: 10))
        let maskLayer = CAShapeLayer()
        let maskLayer2 = CAShapeLayer()
        let maskLayer3 = CAShapeLayer()
        maskLayer3.path = maskPath3.cgPath
        maskLayer2.path = maskPath2.cgPath
    
        maskLayer.path = maskPath.cgPath
        btnSearch.layer.mask = maskLayer
        viewTxt.layer.mask = maskLayer2
        viewText.layer.mask = maskLayer3
       // searchTf.layer.cornerRadius = 11
        
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        // Register the xib for collection view cell
        let cellNib = UINib(nibName: "InfoProductCollectionViewCell", bundle: nil)
        collectionView.register(UINib(nibName: "InfoProductCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "InfoProductCollectionViewCell")
    }
    
    @IBAction func tapBack(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func tapSearch(_ sender: Any) {
        searchText = searchTf.text ?? ""
        if searchText.isEmpty {
            getDataByFirebaseSale()
        } else {
            getDataByFirebaseSearch(key: searchText)
        }
    }
    
    
    
    func getDataByFirebaseSale() {
        let databaseReference = Database.database().reference()
        databaseReference.child("Foods").observe(.childAdded) { snapshot in
            databaseReference.child("Foods").child(snapshot.key).observe(.value) { data  in
                dump(data.value)
                if let dict = data.value as? [String: Any] {
                    
                        let food = Food(dict: dict)
                    
                        self.listFood.append(food)
                        //self.stopAnimating()
                        self.collectionView.reloadData()
                        databaseReference.child("Foods").child(snapshot.key).removeAllObservers()
                }
            }
        }
        
       // print(self.listFood2.count)
        
    }
    
    func getDataByFirebaseSearch(key : String) {
        let databaseReference = Database.database().reference()
        databaseReference.child("Foods").observe(.childAdded) { snapshot in
            databaseReference.child("Foods").child(snapshot.key).observe(.value) { data  in
                dump(data.value)
                if let dict = data.value as? [String: Any] {
                    
                    let food = Food(dict: dict)
                    let name = key.lowercased()
                    if food.foodName.lowercased().contains(name){
                        self.listFood.append(food)
                        //self.stopAnimating()
                        self.collectionView.reloadData()
                        databaseReference.child("Foods").child(snapshot.key).removeAllObservers()
                    }
                }
            }
        }
        
       // print(self.listFood2.count)
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    var check = true
    
}

extension SearchViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listFood.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "InfoProductCollectionViewCell", for: indexPath) as? InfoProductCollectionViewCell {
            cell.layer.cornerRadius = 12
            cell.layer.borderWidth = 1.0
            cell.layer.borderColor = UIColor.gray.withAlphaComponent(0.4).cgColor
            let cornerRadius: CGFloat = 12
            let maskLayer = CAShapeLayer()
            maskLayer.path = UIBezierPath(roundedRect: cell.saleView.bounds,
                                          byRoundingCorners: [.bottomRight],
                                          cornerRadii: CGSize(width: cornerRadius, height: cornerRadius)).cgPath
            cell.saleView.layer.mask = maskLayer
            
            var dataF = self.listFood[indexPath.row] ?? nil
            
            cell.setDataForCell(foodA: dataF)
            //            cell.colorView.backgroundColor = self.rowWithColors?[indexPath.item].color ?? UIColor.black
//            cell.nameLabel.text = self.rowWithColors?[indexPath.item].name ?? ""
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
      let itemSize = (collectionView.frame.width) / 2
      return CGSize(width: itemSize, height: itemSize)
    }

    
}

extension SearchViewController: CustomCollectionViewLayoutDelegate {
  func collectionView(
    _ collectionView: UICollectionView,
    heightForPhotoAtIndexPath indexPath:IndexPath) -> CGFloat {
    return 180 //photos[indexPath.item].image.size.height
  }
}
