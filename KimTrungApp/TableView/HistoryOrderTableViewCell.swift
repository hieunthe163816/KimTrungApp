//
//  HistoryOrderTableViewCell.swift
//  KimTrungApp
//
//  Created by HieuNT on 30/05/2024.
//

import UIKit

class HistoryOrderTableViewCell: UITableViewCell {

    @IBOutlet weak var lbFree: UILabel!
    @IBOutlet weak var priceLb: UILabel!
   
    @IBOutlet weak var quantityLb: UILabel!
    @IBOutlet weak var viewFree: UIView!
    @IBOutlet weak var detailHis: UILabel!
    @IBOutlet weak var nameHis: UILabel!
    @IBOutlet weak var imageHis: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        viewFree.layer.cornerRadius = 4
        viewFree.layer.borderWidth = 1
        viewFree.layer.borderColor = lbFree.textColor.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        

        // Configure the view for the selected state
    }
    
}
