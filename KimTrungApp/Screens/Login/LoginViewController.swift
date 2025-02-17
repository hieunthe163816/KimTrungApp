//
//  LoginViewController.swift
//  KimTrungApp
//
//  Created by HieuNT on 25/12/2023.
//

import UIKit
import MBProgressHUD
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet weak var passwordLine: UIView!
    @IBOutlet weak var emailLine: UIView!
    @IBOutlet weak var errorPassword: UIView!
    @IBOutlet weak var errorEmail: UIView!
    @IBOutlet weak var passwordErrorLb: UILabel!
    @IBOutlet weak var emailErrorLb: UILabel!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var showPasswordImage: UIImageView!
    
    @IBOutlet weak var googleBtn: UIView!
    @IBOutlet weak var facebookBtn: UIView!
    @IBOutlet weak var loginBtn: UIButton!
    
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
        errorEmail.isHidden = true
        errorPassword.isHidden = true
        passwordTF.isSecureTextEntry = true
        setUp()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func onclickRegister(_ sender: Any) {
        /**
         Step 1: Lấy được instance của class RegisterController từ storyboard Main
         Step 2: Gọi navigation controller từ màn login để thực hiện push register controller
         Step 3: Nếu muốn back lại thì sử dụng pop
         */
        
        /// Step 1: Lấy được instance của class RegisterController từ storyboard Main
        /**
         Step 1.1: Khởi tạo đối tượng của storyboard Main
         name: "Main" => Tên file storyboard
         */
        print("click register")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        /**
         Step 1.2: Gọi ra instance của 1 viewcontroller bất kỳ dựa vào StoryboardID
         */
        
        let registerViewController: RegisterViewController = storyboard.instantiateViewController(withIdentifier: "RegisterViewController") as! RegisterViewController
        
        
        /// Có thể ép kiểu từ UIViewController => RegisterViewController
        /// as? => Optional
        /// as! => NẾu mà không ép kiểu được thì sẽ bị crash
        
        /// Step 2: Gọi navigation controller từ màn login để thực hiện push register controller
        navigationController?.pushViewController(registerViewController, animated: true )
    }
    
    
    @IBAction func onclickForgetPassword(_ sender: Any) {
        print("click forgetpassword")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let forgotChooseMethodVC = storyboard.instantiateViewController(withIdentifier: "ForgetPasswordViewController") as! ForgetPasswordViewController
        navigationController?.pushViewController(forgotChooseMethodVC, animated: true)
    }
    
    
    @IBAction func onclickLogin(_ sender: Any) {
        onHandleRegister()
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

    
    
    private func setUp(){
        googleBtn.layer.cornerRadius = 10
        loginBtn.layer.cornerRadius = 10
        facebookBtn.layer.cornerRadius = 10
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
        let email = emailTF.text ?? ""
        let password = passwordTF.text ?? ""
        
        let isValid = onHandleValidateForm( email: email, password: password)
        
        guard isValid else {
            /// Không thỏa mã cái điều kiện validate thì không xử lý gì cả.
            return
        }
        /// Thoải mãn validate thì mình thực hiện call API register
        showLoading(isShow: true)
        callApi()
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with: email)
    }
    
    private func onHandleValidateForm( email: String, password: String) -> Bool {
        
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
        let isValid = isEmailValid && isPasswordValid
        return isValid
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    //thông báo lỗi khi đăng ký
    private func alertLoginError(title: String? = "Error", message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Try again", style: .cancel)
        alertVC.addAction(okAction)
        present(alertVC, animated: true)
    }
    
    //call api để đăng ký
    private func callApi(){
        Auth.auth().signIn(withEmail: emailTF.text!, password: passwordTF.text!) { result, error in if error != nil {
            self.showLoading(isShow: false)
            self.alertLoginError(message: error!.localizedDescription)
            print(error!.localizedDescription)
        } else {
            self.showLoading(isShow: false)
            let userId : String  = result!.user.uid
            AuthService.shared.saveAccessToken(accessToken: userId)
            if let uwWindow = (UIApplication.shared.delegate as? AppDelegate)?.window {
                let storyboard = UIStoryboard(name: "Home", bundle: nil)
                let mainVC = storyboard.instantiateViewController(withIdentifier: "MainUiTabBarController")
                uwWindow.rootViewController = mainVC
                uwWindow.makeKeyAndVisible()
            } else {
                print("LỖI")
            }
        }
        }
    }
}
