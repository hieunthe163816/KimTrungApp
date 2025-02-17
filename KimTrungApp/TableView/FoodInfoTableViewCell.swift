//
//  FoodInfoTableViewCell.swift
//  KimTrungApp
//
//  Created by HieuNT on 02/03/2024.
//

import UIKit


protocol CollectionViewCellDelegate: class {
    func collectionView(collectionviewcell: InfoProductCollectionViewCell?, index: Int, didTappedInTableViewCell: FoodInfoTableViewCell)
    // other delegate methods that you can define to perform action in viewcontroller
}


class FoodInfoTableViewCell: UITableViewCell {

    
    
    weak var cellDelegate: CollectionViewCellDelegate?
    
    var rowFoods: [Food]?
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var titleLb: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.itemSize = CGSize(width: 162, height: 244)
        flowLayout.minimumLineSpacing = 2.0
        flowLayout.minimumInteritemSpacing = 12.0
        flowLayout.collectionView?.layer.cornerRadius = 12
        flowLayout.collectionView?.layer.borderWidth = 1.0
        flowLayout.collectionView?.layer.masksToBounds = true
        self.collectionView.collectionViewLayout = flowLayout
        self.collectionView.showsHorizontalScrollIndicator = false
        
        // Comment if you set Datasource and delegate in .xib
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
        // Register the xib for collection view cell
        let cellNib = UINib(nibName: "InfoProductCollectionViewCell", bundle: nil)
        collectionView.register(UINib(nibName: "InfoProductCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "InfoProductCollectionViewCell")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension FoodInfoTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // The data we passed from the TableView send them to the CollectionView Model
    func updateCellWith(row: [Food]) {
        self.rowFoods = row
        self.collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? InfoProductCollectionViewCell
       // print("I'm tapping the \(rowFoods?[indexPath.row].foodId)")
        
       
        self.cellDelegate?.collectionView(collectionviewcell: cell, index: indexPath.item, didTappedInTableViewCell: self)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.rowFoods?.count ?? 0
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    // Set the data for each cell (color and color name)
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
            
            var dataF = self.rowFoods?[indexPath.row] ?? nil
            
            cell.setDataForCell(foodA: dataF)
            //            cell.colorView.backgroundColor = self.rowWithColors?[indexPath.item].color ?? UIColor.black
//            cell.nameLabel.text = self.rowWithColors?[indexPath.item].name ?? ""
            return cell
        }
        return UICollectionViewCell()
    }
    
    // Add spaces at the beginning and the end of the collection view
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8.0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8.0
    }
}
