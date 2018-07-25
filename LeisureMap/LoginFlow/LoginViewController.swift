//
//  LoginViewController.swift
//  LeisureMap
//
//  Created by stu1 on 2018/7/23.
//  Copyright © 2018年 tripim. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var txtAccount: UITextField!
    
    @IBOutlet weak var txtPassword: UITextField!
    
    @IBOutlet weak var btnLogin: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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

}
