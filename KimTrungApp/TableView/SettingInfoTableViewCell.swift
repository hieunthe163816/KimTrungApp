//
//  SettingInfoTableViewCell.swift
//  KimTrungApp
//
//  Created by HieuNT on 05/03/2024.
//

import UIKit

class SettingInfoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imgSmallIcon: UIImageView!
    @IBOutlet weak var imageIcon: UIImageView!
    @IBOutlet weak var viewInfo: UIView!
    @IBOutlet weak var labelDetail: UILabel!
    
    @IBOutlet weak var labelTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        if let image = UIImage(named: "ic_down_home") {
            let rotatedImage = image.imageRotated(byDegrees: -90)
            imgSmallIcon.image = rotatedImage
            imageIcon.tintColor = UIColor(red: 231/255, green: 151/255, blue: 41/255, alpha: 1.0)
            labelTitle.textColor = UIColor(red: 231/255, green: 151/255, blue: 41/255, alpha: 1.0)
        }
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {

        // Configure the view for the selected state
    }
    
}

extension UIImage {
    func imageRotated(byDegrees degrees: CGFloat) -> UIImage? {
        let radians = degrees * CGFloat.pi / 180.0
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        let context = UIGraphicsGetCurrentContext()
        context?.translateBy(x: size.width / 2, y: size.height / 2)
        context?.rotate(by: radians)
        draw(in: CGRect(x: -size.width / 2, y: -size.height / 2, width: size.width, height: size.height))
        let rotatedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return rotatedImage
    }
}

