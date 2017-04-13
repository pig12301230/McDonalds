//
//  PopverController.swift
//  McDonalds
//
//  Created by 莊英祺 on 2016/11/18.
//  Copyright © 2016年 Winston. All rights reserved.
//

import UIKit
import RealmSwift
import FBSDKLoginKit
import FirebaseDatabase
import FirebaseAuth


class LoginController: UIViewController, FBSDKLoginButtonDelegate {
    
     lazy var fbLoginButton:FBSDKLoginButton = {
        let fbLoginButton = FBSDKLoginButton(frame: CGRect(x: 0 , y: 0  , width: 120, height: 30))
        fbLoginButton.center = CGPoint(x: self.backgroundView.frame.size.width/2,
                                       y:self.backgroundView.frame.size.height/2 )
        
        fbLoginButton.readPermissions =   ["public_profile","email","user_friends"]
        fbLoginButton.delegate = self
        return fbLoginButton
    }()
    lazy var loginLabel:UILabel = {
        let loginLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.backgroundView.frame.size.width, height: 50))
        loginLabel.textColor = UIColor.black
        loginLabel.text = "請先登入"
    
        loginLabel.textAlignment = .center
        
        return loginLabel
    }()
    
    lazy var backgroundView:UIView = {
        
        let backgroundView = UIView(frame: CGRect(x: screenSize.width * 0.2  , y: screenSize.height * 0.2 , width: screenSize.width * 0.6, height: screenSize.width * 0.6))
        backgroundView.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        

        return backgroundView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundView.addSubview(fbLoginButton)
        backgroundView.addSubview(loginLabel)
        self.view.addSubview(backgroundView)

        showAnimate()

    }
    
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        
        if(error != nil){
            // 處理error
        }else if(result.isCancelled){
            //do nothing
        }else{
            
            FirebaseModel.sharedFirebaseModel.login()
            print("user logged in")
            self.view.removeFromSuperview()
            self.removeFromParentViewController()
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("log out")
        //fb log out
        FBSDKAccessToken.setCurrent(nil)
        //firebase log out
        try! FIRAuth.auth()?.signOut()
    }
    
       

    func showAnimate(){
        self.view.transform = CGAffineTransform(translationX: 0, y: screenSize.height)
        UIView.animate(withDuration: 0.4, animations: {
            self.view.transform = CGAffineTransform(translationX: 0, y: 200)
        })
    }

    
}
