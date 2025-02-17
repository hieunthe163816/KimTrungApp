//
//  BannerTableViewCell.swift
//  KimTrungApp
//
//  Created by HieuNT on 02/03/2024.
//

import UIKit

class BannerTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    var screenMan: Int = Int(UIScreen.main.bounds.width) - 32
    var screenWidth: CGFloat!
    let screenHeight = 145
    var views = [UIImageView]()
    
    var timer: Timer!
    var listImg : [String] = ["banner1","banner2","banner3"]
    override func awakeFromNib() {
        super.awakeFromNib()
        //screenWidth = self.bounds.width
        screenWidth = CGFloat(screenMan)
        // Initialization code
        dummyData()
        //print(views)
        setupItem(views: views)
        pageControl.currentPage = 0
        scrollView.delegate = self
        setUpPageControl(numberPage: 3)
        timer = Timer.scheduledTimer(withTimeInterval: 10, repeats: true, block: { [weak self] (_) in
            guard let strongSelf = self else { return }
            if strongSelf.pageControl.currentPage < strongSelf.views.count-1 {
                strongSelf.pageControl.currentPage += 1
            } else {
                strongSelf.pageControl.currentPage = 0
            }
            
            strongSelf.scrollView.contentOffset = CGPoint(x: strongSelf.screenWidth * CGFloat(strongSelf.pageControl.currentPage),
                                                          y: 0)
        })
    }

    func dummyData() {
        let img1 = UIImage(named: "banner1")?.withRenderingMode(.alwaysOriginal)
        let img2 = UIImage(named: "banner2")?.withRenderingMode(.alwaysOriginal)
        let img3 = UIImage(named: "banner3")?.withRenderingMode(.alwaysOriginal)
        
        let cornerRadius: CGFloat = 12.0
        
        views.append(contentsOf: [img1, img2, img3].compactMap { image in
            let imageView = UIImageView(image: image)
            imageView.layer.cornerRadius = cornerRadius
            imageView.layer.masksToBounds = true
            return imageView
        })
        
        // Use the image views as needed
        for imageView in views {
            // Add the image view to the view hierarchy or perform other operations
            scrollView.addSubview(imageView)
        }
    }
    func setupItem(views: [UIImageView]){
        scrollView.frame = CGRect(x: 0, y: 0,
                                  width: Int(screenWidth),
                                  height: screenHeight)
        scrollView.contentSize = CGSize(width: Int(screenWidth) * Int(views.count),
                                        height: 145)
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        for i in 0..<views.count {
                 let imageView = views[i]
                 imageView.frame = CGRect(x: Int(screenWidth) * i, y: 0, width: Int(screenWidth), height: 145)
            //print("scroll view: \(scrollView.frame)  imageView: \(imageView.frame)  and screenWidth : \(screenWidth)  and screen màn hình : \(screenMan)")
                 scrollView.addSubview(imageView)
             }
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func setUpPageControl(numberPage: Int){
        pageControl.numberOfPages = numberPage
    }
    
}
    
    extension BannerTableViewCell: UIScrollViewDelegate{
        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            let pageIndex = round(scrollView.contentOffset.x/screenWidth)
            pageControl.currentPage = Int(pageIndex)
        }
    }


