//
//  LoginViewController.swift
//  LeisureMap
//
//  Created by stu1 on 2018/7/23.
//  Copyright © 2018年 tripim. All rights reserved.
//

import UIKit
import SwiftyJSON

class LoginViewController: UIViewController, UITextFieldDelegate, AsyncReponseDelegate, FileWorkerDelegate {
    

    @IBOutlet weak var txtAccount: UITextField!
    
    @IBOutlet weak var txtPassword: UITextField!
    
    @IBOutlet weak var btnLogin: UIButton!
    

    var fileWorker : FileWorker?
    let storeFileName : String = "store.json"
    
    // MARK: - Views' Event
    
    override func viewDidLoad() {
        super.viewDidLoad()

        AppDelegate.RequestWorker.reponseDelegate = self
        
        fileWorker = FileWorker()
        fileWorker?.fileWorkerDelegate = self
        

        print("viewDidLoad")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print("viewWillAppear")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        print("viewDidAppear")
        
        txtAccount.becomeFirstResponder()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        print("viewWillDisappear")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        print("viewDidDisappear")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
        
    }
    
    // MARK: - UITextFieldDelegate

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
    
    
    // MARK: - AsyncResponseDelegate
    
    
    @IBAction func btnLoginClicked(_ sender: Any) {
        
        let account = txtAccount.text!
        let password = txtPassword.text!
        
        let from = "https://score.azurewebsites.net/api/login/\( account )/\( password )"
        
        AppDelegate.RequestWorker.getResponse(from: from, tag: 1)
        
        DispatchQueue.main.async {
            self.btnLogin.isEnabled = false
        }
        
    }
    
    func readServiceCategory()  {
        let from = "https://score.azurewebsites.net/api/ServiceCategory"
        
        AppDelegate.RequestWorker.getResponse(from: from, tag: 2)
    }
    
    func readStore()  {
        let from = "https://score.azurewebsites.net/api/store"
        
        AppDelegate.RequestWorker.getResponse(from: from, tag: 3)
    }
    
    func receviedReponse(_ sender: AsyncRequestWorker, responseString: String, tag: Int) {
        
        DispatchQueue.main.async {
            self.btnLogin.isEnabled = true
        }
        //print( "\( tag ):\( responseString )" )
        
        switch tag {
        case 1:
            // login
            self.readServiceCategory()
            break
        case 2:
            // ServiceCategory
            
            do{
                
                if let dataFromString = responseString.data(using: .utf8, allowLossyConversion: false) {
                    
                    let json = try JSON(data: dataFromString)
                    
                    let sqliteContext = ServiceCategoryContext()
                    sqliteContext.createdTable()
                    
                    sqliteContext.clearAll()
                    
                    
                    for (_ ,subJson):(String, JSON) in json {
                        
                        let serviceId : Int = subJson["index"].intValue
                        let name : String = subJson["name"].stringValue
                        let imagePath : String = subJson["imagePath"].stringValue
                        
                        sqliteContext.insertData( _serviceId: serviceId, _name: name, _imagepath: imagePath)
                        
                    }
                    
                    let categories = sqliteContext.readData()
                    print(categories)
                }
                
            }catch{
                print(error)
            }
            
            
            
            
            //
            self.readStore()
            break
        case 3:
            
            //
            
            // {"serviceIndex":0,"name":"Cafe00","location":{"address":"","latitude":0.0,"longitude":0.0},"index":0,"imagePath":""}
            

            
            
            self.fileWorker?.writeToFile(content: responseString, fileName: storeFileName, tag: 1)
            
            break
        default:
            break
        }
    }
    
    // MARK: - FileWorkerDelegate
    
    func fileWorkWriteCompleted(_ sender: FileWorker, fileName: String, tag: Int) {
        
        print(fileName)
        
        // store
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "moveToMasterViewSegue", sender: self)
        }
    }
    
    func fileWorkReadCompleted(_ sender: FileWorker, content: String, tag: Int) {
        
    }

}
