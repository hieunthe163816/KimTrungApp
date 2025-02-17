//
//  ForgetPasswordViewController.swift
//  KimTrungApp
//
//  Created by HieuNT on 22/01/2024.
//

import UIKit
import MBProgressHUD
import FirebaseAuth

class ForgetPasswordViewController: UIViewController {

    @IBOutlet weak var forgetBtn: UIButton!
    
    @IBOutlet weak var emailLine: UIView!
    @IBOutlet weak var errorEmail: UIView!
    @IBOutlet weak var emailErrorLb: UILabel!
    @IBOutlet weak var emailTF: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        errorEmail.isHidden = true
        navigationController?.isNavigationBarHidden = true
        forgetBtn.layer.cornerRadius = 10
        // Do any additional setup after loading the view.
    }
    
    
   
    
    @IBAction func tapBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
 
    
    @IBAction func tapForget(_ sender: Any) {
        onHandleRegister()
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
        
        
        let isValid = onHandleValidateForm(email: email)
        
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
    
    private func onHandleValidateForm( email: String) -> Bool {
        var isNameValid = false
        
        
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
        
       
        let isValid = isEmailValid
        return isValid
    }
    
    
    private func callApi(){
        Auth.auth().sendPasswordReset(withEmail: emailTF.text!) {
            error in
            if error != nil {
                self.showLoading(isShow: false)
                self.alertLoginError(message: error!.localizedDescription)
            } else {
                self.showLoading(isShow: false)
                self.alertLoginSuccess(message: "We have sent you a link to your Gmail. Please reset it using the provided link and log in using the new password." )
            }
        }
    }
    
    
    private func alertLoginError(title: String? = "Error", message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Try again", style: .cancel)
        alertVC.addAction(okAction)
        present(alertVC, animated: true)
    }
    
    private func alertLoginSuccess(title: String? = "Success", message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel){
            _ in self.navigationController?.popViewController(animated: true)
        }
        alertVC.addAction(okAction)
        present(alertVC, animated: true)
    }
}
