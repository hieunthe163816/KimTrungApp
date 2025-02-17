//
//  RegisterViewController.swift
//  KimTrungApp
//
//  Created by HieuNT on 04/01/2024.
//

import UIKit
import MBProgressHUD
import FirebaseAuth
import MotionToastView
import FirebaseDatabase

class RegisterViewController: UIViewController {

    
    @IBOutlet weak var passwordLine: UIView!
    @IBOutlet weak var emailLine: UIView!
    @IBOutlet weak var nameLine: UIView!
    @IBOutlet weak var errorPassword: UIView!
    @IBOutlet weak var errorEmail: UIView!
    @IBOutlet weak var errorFullname: UIView!
    @IBOutlet weak var passwordErrorLb: UILabel!
    @IBOutlet weak var emailErrorLb: UILabel!
    @IBOutlet weak var nameErrorLb: UILabel!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var showPasswordImage: UIImageView!
    
    @IBOutlet weak var googleBtn: UIView!
    @IBOutlet weak var facebookBtn: UIView!
    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var backBtn: UIButton!
    
    
    private var nameErrorMessage: String? {
        didSet{
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
    private var passwordErrorMessage: String? {
        didSet {
            let isError = passwordErrorMessage != nil
            if isError {
                setupPasswordError()
            } else {
                setupPasswordValid()
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        errorEmail.isHidden = true
        errorFullname.isHidden = true
        errorPassword.isHidden = true
        passwordTF.isSecureTextEntry = true
        navigationController?.isNavigationBarHidden = true
        // Do any additional setup after loading the view.
    }
    
    //các action
    
    
    @IBAction func tapBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    //click đăng nhập
    @IBAction func tapRegister(_ sender: Any) {
        onHandleRegister()
        print("tap regis")
    }
    

    @IBAction func tapForget(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let forgotChooseMethodVC = storyboard.instantiateViewController(withIdentifier: "ForgetPasswordViewController") as! ForgetPasswordViewController
        navigationController?.pushViewController(forgotChooseMethodVC, animated: true)
    }
    
    

    @IBAction func tapShowPassword(_ sender: Any) {
        if passwordTF.isSecureTextEntry == true {
            showPasswordImage.image = UIImage(named: "ic_eye_open")
            passwordTF.isSecureTextEntry = false
        }
        else {
            showPasswordImage.image = UIImage(named: "ic_eye_close")
            passwordTF.isSecureTextEntry = true
        }
    }

//set up btn
    private func setUp(){
        registerBtn.layer.cornerRadius = 10
        facebookBtn.layer.cornerRadius = 10
        googleBtn.layer.cornerRadius = 10
    }
    
    
 //setup email
    
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
    
    
    private func setupPasswordError() {
        
        passwordLine.backgroundColor = .red
        errorPassword.isHidden = false
        passwordErrorLb.text = passwordErrorMessage
       
    }
    
    private func setupPasswordValid() {
        
        passwordLine.backgroundColor = .lightGray
        errorPassword.isHidden = true
        passwordErrorLb.text = nil
        
    }
    
    
    //loading
    func showLoading(isShow: Bool) {
        if isShow {
            MBProgressHUD.showAdded(to: self.view, animated: true)
        } else {
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
    
    //function bắt valid người dùng
    
    private func onHandleRegister() {
        /*
         Validate dữ liệu form
         */
        let name = nameTF.text ?? ""
        let email = emailTF.text ?? ""
        let password = passwordTF.text ?? ""
        
        let isValid = onHandleValidateForm(name: name, email: email, password: password)
        
        guard isValid else {
            /// Không thỏa mã cái điều kiện validate thì không xử lý gì cả.
            return
        }
        /// Thoải mãn validate thì mình thực hiện call API register
        showLoading(isShow: true)
        callApi()
        //callAPIRegister(nickName: name, email: email, password: password)
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegex)
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
        if email.isEmpty {
            emailErrorMessage = "Email can't empty"
        }
        else if (!isValidEmail(email)) {
            emailErrorMessage = "Email invalid"
        }
        else {
            emailErrorMessage = nil
            isEmailValid = true
        }
        
        var isPasswordValid = false
        if password.isEmpty {
            passwordErrorMessage = "Password can't empty"
        }
        else if password.count < 6 {
            passwordErrorMessage = "Password must be at least 6 characters long."
        }
        else {
            passwordErrorMessage = nil
            isPasswordValid = true
        }
        let isValid = isEmailValid && isPasswordValid && isNameValid
        return isValid
    }
    
    //thông báo lỗi khi đăng ký
    private func alertLoginError(title: String? = "Error", message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Try again", style: .cancel)
        alertVC.addAction(okAction)
        present(alertVC, animated: true)
    }
    
    //call api để đăng ký
    private func callApi(){
        Auth.auth().createUser(withEmail: emailTF.text!, password: passwordTF.text!) { result, error in if error != nil {
            self.showLoading(isShow: false)
            self.alertLoginError(message: error!.localizedDescription)
        } else {
            let data = result!
            let currentDate = Date()

            // Tạo một định dạng để định dạng thời gian
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

            // Chuyển đổi thời gian thành chuỗi theo định dạng đã định
            let dateString = dateFormatter.string(from: currentDate)

            //Save user to database
            var logString = "create success account at \(dateString)"
            let value = ["email" : self.emailTF.text!, "name" : self.nameTF.text!, "id": data.user.uid, "log": logString, "avatar" : "","address" : ""]
            let databaseRef = Database.database().reference()
            databaseRef.child("User").child(data.user.uid).setValue(value)
            
            self.showLoading(isShow: false)
            self.MotionToast(message: "Register successful, Please Login.", toastType: .success)
            DispatchQueue.main.asyncAfter(deadline: .now() + 2 ){
                self.navigationController?.popViewController(animated: true)
            }
            
        }
        }
    }
    
}
