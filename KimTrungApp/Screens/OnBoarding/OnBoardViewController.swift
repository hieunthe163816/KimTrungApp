//
//  OnBoardViewController.swift
//  KimTrungApp
//
//  Created by HieuNT on 20/12/2023.
//

import UIKit

class OnBoardViewController: UIViewController {

    @IBOutlet weak var btnMain: UIButton!
    @IBOutlet weak var imgMain: UIImageView!
    
    @IBOutlet weak var lbTitle: UILabel!
    
    @IBOutlet weak var lbContent: UILabel!
    struct DetailScreen {
        var img: String = ""
        var info: String = ""
        var content: String = ""
    }
    
    var listDetails : [DetailScreen] = []
    
    func dummyDetails() -> [DetailScreen] {
        let details1 : DetailScreen = DetailScreen(img: "ImgOnboard1", info: "Welcome", content: "It’s a pleasure to meet you. We are excited that you’re here so let’s get started!")
        let details2 : DetailScreen = DetailScreen(img: "ImgOnboard2", info: "All your favorites.", content: "Order from the best local restaurants with easy, on-demand delivery.")
        let details3 : DetailScreen = DetailScreen(img: "ImgOnboard3", info: "Free delivery offers.", content: "Free delivery for new customers via Apple Pay and others payment methods.")
        let details4 : DetailScreen = DetailScreen(img: "ImgOnboard4", info: "Choose your food", content: "Easily find your type of food craving and you’ll get delivery in wide range.")
        return [details1, details2, details3,details4]
    }
    
    var indexPage : Int = 0
 
    
    @IBOutlet weak var viewSuper: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        listDetails = dummyDetails()
        setUp()
        
        // Do any additional setup after loading the view.
    }
    
    func setUp(){
        btnMain.layer.cornerRadius = 10
        btnMain.setTitle("GET STARTED", for: .normal)
        imgMain.image = UIImage(named: listDetails[0].img)
        lbContent.text = listDetails[0].content
    }
    
    @IBAction func onclickButton(_ sender: Any) {
        indexPage += 1
        imgMain.image = UIImage(named: listDetails[indexPage].img)
        lbContent.text = listDetails[indexPage].content
        lbTitle.text = listDetails[indexPage].info
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

class CircleCutoutView: UIView {
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let path = UIBezierPath(rect: rect)
        let circlePath = UIBezierPath(ovalIn: rect.insetBy(dx: -rect.width, dy: -rect.width))
        
        path.append(circlePath)
        path.usesEvenOddFillRule = true
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        maskLayer.fillRule = .evenOdd
        
        layer.mask = maskLayer
    }
}

