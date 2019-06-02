//
//  SplashViewController.swift
//  LeisureMap
//
//  Created by stu1 on 2018/7/23.
//  Copyright © 2018年 tripim. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController, AsyncReponseDelegate {
    
    var appVersion : String = ""
    
    @IBOutlet weak var lbVersion: UILabel!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        
        
        
        //
        appVersion = "" + (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String)!
        
        lbVersion.text = appVersion
        
        //
        AppDelegate.RequestWorker.reponseDelegate = self
        
        let from = "https://score.azurewebsites.net/api/version/\(  String( describing: appVersion) )"
        
        AppDelegate.RequestWorker.getResponse(from: from, tag: 1)
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: AsyncResponseDelegate
    
    func receviedReponse(_ sender: AsyncRequestWorker, responseString: String, tag: Int) {
        print(responseString)
        
        //
        let defaults : UserDefaults = UserDefaults.standard
        
        defaults.set(responseString, forKey: "serviceVersion")
        
        defaults.synchronize()
        
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "moveToLoginViewSegue", sender: self)
        }
        
    }

}
