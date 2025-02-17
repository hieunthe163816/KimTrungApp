//
//  OrderTableViewCell.swift
//  KimTrungApp
//
//  Created by HieuNT on 25/04/2024.
//

import UIKit

class OrderTableViewCell: UITableViewCell {

    @IBOutlet weak var orderBtn: UIButton!
    @IBOutlet weak var headView: UIView!
    @IBOutlet weak var orderLb: UILabel!
    @IBOutlet weak var dateLb: UILabel!
    @IBOutlet weak var buttonView: UIView!
    @IBOutlet weak var contenView: UIView!
    @IBOutlet weak var statusLb: UILabel!
    @IBOutlet weak var mealLb: UILabel!
    @IBOutlet weak var totalLb: UILabel!
    @IBOutlet weak var SuperView: UIView!
    @IBOutlet weak var foodLb: UILabel!
    @IBOutlet weak var imageFood: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        headView.layer.cornerRadius = 12
        buttonView.layer.cornerRadius = 10
        contenView.layer.cornerRadius = 12
        orderBtn.layer.cornerRadius = 12
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
