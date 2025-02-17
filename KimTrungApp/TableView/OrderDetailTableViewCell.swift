import UIKit
import FirebaseDatabase
import FirebaseStorage

protocol DeleteCellProtocol: class {
    func deleteButtonTapped(at indexPath: Int)
    
    func tapCellAt(at indexPath: Int)
    // other delegate methods that you can define to perform action in viewcontroller
}


class OrderDetailTableViewCell: UITableViewCell {
    weak var delegate: DeleteCellProtocol?
    @IBOutlet weak var imgFood: UIImageView!
    var indexCell : Int = 0
    var foodid = ""
    @IBOutlet weak var priceLb: UILabel!
    @IBOutlet weak var nameFood: UILabel!
    @IBOutlet weak var numberDetail: UILabel!
    private var deleteButtonLeadingConstraint: NSLayoutConstraint!
    private var deleteButton: UIButton!
    private var swipeGestureRecognizer: UISwipeGestureRecognizer!
    private var swipeGestureRecognizer1: UISwipeGestureRecognizer!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imgFood.layer.cornerRadius = 8
        imgFood.layer.borderWidth = 1
        imgFood.layer.borderColor = UIColor.lightGray.cgColor
        imgFood.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imgFood.widthAnchor.constraint(equalTo: imgFood.heightAnchor),
            imgFood.centerXAnchor.constraint(equalTo: imgFood.centerXAnchor),
            imgFood.centerYAnchor.constraint(equalTo: imgFood.centerYAnchor)
        ])
        
        // Configure the delete button
        deleteButton = UIButton()
        deleteButton.backgroundColor = .red
        deleteButton.setTitle("Delete", for: .normal)
        deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        addSubview(deleteButton)
        
        // Add layout constraints for the delete button
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        deleteButtonLeadingConstraint = deleteButton.leadingAnchor.constraint(equalTo: trailingAnchor)
        NSLayoutConstraint.activate([
            deleteButton.widthAnchor.constraint(equalToConstant: 80),
            deleteButton.topAnchor.constraint(equalTo: topAnchor),
            deleteButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            deleteButtonLeadingConstraint
        ])
        
        // Create a swipe gesture recognizer
        swipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture(_:)))
        swipeGestureRecognizer.direction = .left
        //swipeGestureRecognizer.cancelsTouchesInView = false
        addGestureRecognizer(swipeGestureRecognizer)
        swipeGestureRecognizer1 = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGestureRight(_:)))
        swipeGestureRecognizer1.direction = .right
       // swipeGestureRecognizer1.cancelsTouchesInView = false
        addGestureRecognizer(swipeGestureRecognizer1)
        
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:)))
        addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc private func handleTapGesture(_ gestureRecognizer: UITapGestureRecognizer) {
        self.delegate?.tapCellAt(at: indexCell)
    }
    
    @objc private func handleSwipeGesture(_ gestureRecognizer: UISwipeGestureRecognizer) {
        if gestureRecognizer.state == .ended {
            let isDeleting = deleteButtonLeadingConstraint.constant == 0
            
            UIView.animate(withDuration: 0.3) {
                if isDeleting {
                    self.deleteButtonLeadingConstraint.constant = -self.deleteButton.bounds.width
                } else {
                    self.deleteButtonLeadingConstraint.constant = 0
                }
                self.layoutIfNeeded()
            }
        } else {
            print("click đây")
        }
    }
    
    @objc private func handleSwipeGestureRight(_ gestureRecognizer: UISwipeGestureRecognizer) {
        if gestureRecognizer.state == .ended {
            deleteButtonLeadingConstraint.constant = deleteButton.bounds.width
            UIView.animate(withDuration: 0.3) {
                self.layoutIfNeeded()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.deleteButtonLeadingConstraint.constant = 0
                UIView.animate(withDuration: 0.3) {
                    self.layoutIfNeeded()
                }
            }
        }
    }
    
    @objc private func deleteButtonTapped() {
        
        self.delegate?.deleteButtonTapped(at: indexCell)
        // You can handle the delete button tap event here
        // For example, you can use delegate pattern or closures to pass this event information to the view controller
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        print ("choice cell \(indexCell)")
    }
    
    func setData(x: FoodCart) {
        numberDetail.text = "\(x.soldQuantity) X"
        nameFood.text = x.foodName
        let price = (Double(x.foodPrice) ?? 0) * (100 - (Double(x.foodPrecentPrice) ?? 0)) / 100
        let totalPrice = price * (Double(x.soldQuantity) ?? 0)
        priceLb.text = String(totalPrice)
        loadImage(from: x.foodImg)
    }
    
    func loadImage(from link: String) {
        let storageRef = Storage.storage().reference().child(link)
                
        storageRef.downloadURL { url, error in
            if let error = error {
                // Handle the error
                print("Error downloading image: \(error.localizedDescription)")
            } else if let imageURL = url {
                self.imgFood.sd_setImage(with: imageURL, placeholderImage: UIImage(named: "placeholder"), options: [], completed: { (image, error, cacheType, imageURL) in
                    if let error = error {
                        // Handle the error
                        print(error.localizedDescription)
                    } else {
                        print("Image loaded successfully")
                    }
                })
            }
        }
    }
}
