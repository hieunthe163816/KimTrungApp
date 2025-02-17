//
//  ProfileViewController.swift
//  KimTrungApp
//
//  Created by HieuNT on 27/02/2024.
//

import UIKit
import MBProgressHUD
import FirebaseDatabase
import FirebaseStorage
import SDWebImage

class ProfileViewController: UIViewController {

    @IBOutlet weak var btnDone: UIButton!
    @IBOutlet weak var btnChangeProfile: UIButton!
    @IBOutlet weak var iconCamera: UIImageView!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var btnBack: UIButton!
    
    
    @IBOutlet weak var passwordLine: UIView!
    @IBOutlet weak var errorPassword: UIView!
    @IBOutlet weak var passwordErrorLb: UILabel!
    @IBOutlet weak var passwordTF: UITextField!

    
    @IBOutlet weak var emailLine: UIView!
    @IBOutlet weak var nameLine: UIView!
    @IBOutlet weak var errorEmail: UIView!
    @IBOutlet weak var errorFullname: UIView!
    @IBOutlet weak var emailErrorLb: UILabel!
    @IBOutlet weak var nameErrorLb: UILabel!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var nameTF: UITextField!
    
    
    let imagePicker = UIImagePickerController()
    var isEdit: Bool = true
    var choiceImage: UIImage?
    var userGetData : User!
    
    private var nameErrorMessage: String? {
        didSet{
            print("đã set")
            let isError = nameErrorMessage != nil
            
            if isError{
                setupNameError()            }else{
                setupNameValid()            }
        }
    }
    
    private var emailErrorMessage: String? {
        didSet {
            let isError = emailErrorMessage != nil
            if isError {
                setupEmailError()
            } else {
                setupEmailValid()
            }
        }
    }
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //test1()
        getDataByFirebase()
        //print("tại main \(userGetData!.name)")
        upLoadData()
        setUp()
        //getDataByFirebase1()
        errorEmail.isHidden = true
        errorFullname.isHidden = true
        errorPassword.isHidden = true
        navigationController?.isNavigationBarHidden = true
        // Do any additional setup after loading the view.
    }
    
    func test1(){
        let storageRef = Storage.storage().reference().child("Products/Foods/food2.png")
                
                // Tải ảnh từ URL và hiển thị trong UIImageView
                storageRef.downloadURL { url, error in
                    if let error = error {
                        //print("Error downloading image: \(error.localizedDescription)")
                    } else if let imageURL = url {
                        // Sử dụng URLSession để tải ảnh từ URL
                        URLSession.shared.dataTask(with: imageURL) { data, _, error in
                            if let error = error {
                               // print("Error downloading image data: \(error.localizedDescription)")
                            } else if let imageData = data {
                                // Chuyển đổi dữ liệu ảnh thành UIImage và cập nhật UIImageView trên luồng chính
                                DispatchQueue.main.async {
                                    let image = UIImage(data: imageData)
                                    self.imgProfile.image = image
                                }
                            }
                        }.resume()
                    }
                }
    }
    // các action
  
    @IBAction func tapCancel(_ sender: Any) {
        upLoadData()
        noClickChange()
    }
    
    
    @IBAction func tapChangeImage(_ sender: Any) {
        changeImage()
    }
    
    
    
    @IBAction func tapBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func upLoadData(){
        print("vào hàm upload")
        if let dataU = self.userGetData{
            //print("đã vào if và \(dataU.name)")
            self.nameTF.text = dataU.name
            self.emailTF.text = dataU.phone
            self.passwordTF.text = dataU.address
            changeImageByLink(link: dataU.avatar)
        }
    }
    
    @IBAction func tapChange(_ sender: Any) {
        
        if (isEdit == true){

               clickChanged()
            
        } else{
            
            let successForm = onHandleValidateForm(name: nameTF.text!, email: emailTF.text ?? "", password: passwordTF.text ?? "")
            
            if successForm {
                noClickChange()
                
                let status = checkChangeTF()
                
                if status {
                    showLoading(isShow: true)
                    var avatarLink = userGetData.avatar
                    functionA { avatarLink in
                        self.functionB(avatarLink: avatarLink)
                        
                    }
                }
                
            }
            
        }
        
    }
    
    func changeImageByLink(link : String){
        let imageURL = link
        self.showLoading(isShow: true)
        if link == "" {
            self.imgProfile.image = UIImage(named: "ic_profile")
        } else {
            // Sử dụng SDWebImage để tải và hiển thị ảnh
            self.imgProfile.sd_setImage(with: URL(string: imageURL), placeholderImage: UIImage(named: "placeholder"), options: [], completed: { (image, error, cacheType, imageURL) in
                if let error = error {
                    self.alertLoginError(title: "Error", message: error.localizedDescription)
                } else {
                    print("Image loaded successfully")
                }
            })
        }
        self.showLoading(isShow: false)
    }
    
    func changeImage(){
        let alert = UIAlertController(title: "Choice Your Avatar", message: nil,  preferredStyle: .actionSheet)
        let action = UIAlertAction(title: "Photo Library", style: .default) {
            action in self.imagePicker.sourceType = .photoLibrary
            self.imagePicker.delegate = self
            self.present(self.imagePicker, animated: true)
        }
        let actionCancel = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(action)
        alert.addAction(actionCancel)
        present(alert,animated: true, completion: nil)
    }
    
    
    func setUp(){
        btnChangeProfile.layer.cornerRadius = 10
        iconCamera.backgroundColor = .white
        iconCamera.layer.cornerRadius = 15
        var toadoImg = imgProfile.frame
        iconCamera.center = CGPoint(x: Double(toadoImg.maxX - 10), y: Double(toadoImg.maxY - 10))
        
        passwordTF.isEnabled = false
        nameTF.isEnabled = false
        emailTF.isEnabled = false
        btnBack.isHidden = false
        iconCamera.isHidden = true
        btnDone.isHidden = true
        btnDone.imageView?.contentMode = .scaleAspectFit
        imgProfile.layer.cornerRadius = 60
        
    }
    
    func functionA(completion: @escaping (String) -> Void) {
        let dispatchGroup = DispatchGroup()
        var backLink = userGetData.avatar

        if let avatar = self.choiceImage, let data = avatar.jpegData(compressionQuality: 0.3) {
            let databaseReference = Database.database().reference()
            let imageName = databaseReference.childByAutoId().key!
            let imageStorageRef = Storage.storage().reference()
            let imageFolder = imageStorageRef.child("Avatar").child(imageName)

            dispatchGroup.enter()
            imageFolder.putData(data, metadata: nil) { meta, error in
                if let error = error {
                    self.alertLoginError(message: error.localizedDescription)
                } else {
                    self.MotionToast(message: "Update information successful", toastType: .success)
                    
                    imageFolder.downloadURL { url, error in
                        if let error = error {
                            self.alertLoginError(message: error.localizedDescription)
                        } else {
                            backLink = url?.absoluteString ?? ""
                        }
                        
                        dispatchGroup.leave()
                    }
                }
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            completion(backLink)
        }
    }

    func functionB(avatarLink: String) {
        let databaseReference = Database.database().reference()
        
        // Thực hiện các tác vụ của hàm B
        print("Function B")
        var newUserData: [String: Any] = [
            "name": self.nameTF.text,
            "phone": self.emailTF.text,
            "address": self.passwordTF.text,
            "avatar": avatarLink
        ]
        
        let userId = AuthService.shared.getAccessToken()!
        let userReference = databaseReference.child("User").child(userId)
        
        userReference.updateChildValues(newUserData) { (error, _) in
            if let error = error {
                // Handle the error
                print("Failed to update user data: \(error.localizedDescription)")
            } else {
                // Update successful
                print("User data updated successfully")
                
                // Update the local User object with the new data
                let updatedUser = User(dict: newUserData)
                // Access the updated properties
                print("Updated user name: \(updatedUser.name)")
                print("Updated user email: \(updatedUser.email)")
                self.userGetData = User(dict: ["name": self.nameTF.text,
                                               "phone": self.emailTF.text,
                                               "address": self.passwordTF.text,
                                               "avatar": avatarLink])
            }
            
            self.showLoading(isShow: false)
        }
    }

    // Sử dụng:
    
    
    private func alertLoginError(title: String? = "Error", message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Try again", style: .cancel)
        alertVC.addAction(okAction)
        present(alertVC, animated: true)
    }
    
    func checkChangeTF() -> Bool{
        if nameTF.text == userGetData.name {
            return true
        }
        
        if passwordTF.text == userGetData.address {
            return true
        }
        
        if emailTF.text == userGetData.phone {
            return true
        }
        return false
    }
    
    func noClickChange(){
        nameTF.isEnabled = false
        emailTF.isEnabled = false
        passwordTF.isEnabled = false
        btnBack.isHidden = false
        iconCamera.isHidden = true
        btnDone.isHidden = true
        btnBack.isHidden = false
        isEdit = true
        btnChangeProfile.setTitle("Change Profile", for: .normal)
    }
    
    func clickChanged(){
        nameTF.isEnabled = true
        emailTF.isEnabled = true
        passwordTF.isEnabled = true
        btnDone.isHidden = false
        iconCamera.isHidden = false
        btnBack.isHidden = true
        btnChangeProfile.setTitle("Save information", for: .normal)
        isEdit = false
    }
    
    
    func showLoading(isShow: Bool) {
        if isShow {
            MBProgressHUD.showAdded(to: self.view, animated: true)
        } else {
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
    
    
    
    private func setupNameError() {
        
        nameLine.backgroundColor = .red
        errorFullname.isHidden = false
        nameErrorLb.text = nameErrorMessage
       
    }
    
    private func setupNameValid() {
        
        nameLine.backgroundColor = .lightGray
        errorFullname.isHidden = true
        nameErrorLb.text = nil
        
    }
    
    private func setupEmailError() {
        
        emailLine.backgroundColor = .red
        errorEmail.isHidden = false
        emailErrorLb.text = emailErrorMessage
       
    }
    
    private func setupEmailValid() {
        
        emailLine.backgroundColor = .lightGray
        errorEmail.isHidden = true
        emailErrorLb.text = nil
        
    }
    
    
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "^(0|\\+84)(3[2-9]|5[2689]|7[0|6-9]|8[1-9]|9[0-9])\\d{7}$"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        print(email)
        if email.elementsEqual("") {
            return true
        }
        return emailTest.evaluate(with: email)
    }
    
    private func onHandleValidateForm(name: String, email: String, password: String) -> Bool {
        var isNameValid = false
        if name.isEmpty {
            nameErrorMessage = "Name can't empty"
        } else {
            isNameValid = true
        }
        
        var isEmailValid = false
        if (!isValidEmail(email)) {
            emailErrorMessage = "Numbers phone invalid"
        }
        else {
            emailErrorMessage = nil
            isEmailValid = true
        }
        
        let isValid = isEmailValid && isNameValid
        return isValid
    }
    
    
    func getDataByFirebase() {
        showLoading(isShow: true)
        let databaseReference = Database.database().reference()
        let userReference = databaseReference.child("User")
        
        let id = AuthService.shared.getAccessToken()
        
        print("id là: \(id)")
        
        userReference.queryOrdered(byChild: "id").queryEqual(toValue: id).observe(.childAdded) { snapshot in
            databaseReference.child("User").child(snapshot.key).observeSingleEvent(of: .value) { dataSnapshot in
                if let dict = dataSnapshot.value as? [String: Any] {
                    let user = User(dict: dict)
                    // Xử lý thông tin người dùng
                    //print("Thông tin người dùng là: \(user.email)")
                    self.userGetData = user
                    //print(self.userGetData.email)
                    print("nhận data thành công")
                    self.upLoadData()
                    self.showLoading(isShow: false)
                }
            }
        }
    }

    
    
}


extension ProfileViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let choiceImages = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            choiceImage = choiceImages
            imgProfile.image = choiceImages
            self.dismiss(animated: true)
        }
    }
    
}

