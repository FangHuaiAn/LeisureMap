//
//  LoginViewController.swift
//  LeisureMap
//
//  Created by stu1 on 2018/7/23.
//  Copyright © 2018年 tripim. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate, AsyncReponseDelegate {
    
    @IBOutlet weak var txtAccount: UITextField!
    
    @IBOutlet weak var txtPassword: UITextField!
    
    @IBOutlet weak var btnLogin: UIButton!
    
    var requestWorker : AsyncRequestWorker?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // http://score.azurewebsites.net/api/login/acc/pwd
        
        requestWorker = AsyncRequestWorker()
        requestWorker?.reponseDelegate = self
        

        print("viewDidLoad")
        
    }
    
    @IBAction func btnLoginClicked(_ sender: Any) {
        
        let account = txtAccount.text!
        let password = txtPassword.text!
        
        let from = "https://score.azurewebsites.net/api/login/\( account )/\( password )"

        self.requestWorker?.getResponse(from: from, tag: 1)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print("viewWillAppear")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        print("viewDidAppear")
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        print("viewWillDisappear")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        print("viewDidDisappear")
    }
    

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        // a
        
        let accept = "abcdeABCDE"
        let cs = NSCharacterSet(charactersIn: accept).inverted
        // ['a', 'b', 'c']
        
        //                a  a
        let filtered = string.components(separatedBy: cs).joined(separator: "")
        //["a", "b", "c"]
        
        
        if( string != filtered){
            return false
        }

        
        // Max Length
        
        var maxLength : Int = 0
        
        
        if textField.tag == 1 {
            maxLength = 4
        }
        
        if textField.tag == 2 {
            maxLength = 5
        }

        
        let currentString : NSString = textField.text! as NSString
        
        let newString : NSString = currentString.replacingCharacters(in: range, with: string) as NSString
        
        return newString.length <= maxLength
        

    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField.tag == 1 {
            
            textField.resignFirstResponder()
            
            txtPassword.becomeFirstResponder()
            
        }
        
        if textField.tag == 2 {
            textField.resignFirstResponder()
        }
        
        return true
    }
    
    
    // MARK: AsyncResponseDelegate
    
    func receviedReponse(_ sender: AsyncRequestWorker, responseString: String, tag: Int) {
        print(responseString)
        
        
//        DispatchQueue.main.async {
//            self.performSegue(withIdentifier: "moveToLoginViewSegue", sender: self)
//        }
        
    }

}
