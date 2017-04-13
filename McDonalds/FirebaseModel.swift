//
//  FirebaseModel.swift
//  McDonalds
//
//  Created by 莊英祺 on 2016/12/30.
//  Copyright © 2016年 Winston. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import FBSDKCoreKit
import FBSDKLoginKit

class FirebaseModel{
    
    static var sharedFirebaseModel = FirebaseModel()
    var datas = [Type]()
    let databaseRef = FIRDatabase.database().reference()
    let storageRef = FIRStorage.storage().reference(forURL: "gs://mcdonalds-84822.appspot.com")
    var userAccount:FIRUser?
    var profileImage:UIImageView? = UIImageView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))

    var credential:FIRAuthCredential?
    
    init() {
        databaseRef.keepSynced(true)
        self.userAccount = FIRAuth.auth()?.currentUser
        FIRAuth.auth()?.addStateDidChangeListener({ auth,user in
            if (user != nil) {
                self.userAccount = user
                self.getData()
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshMenu"), object: nil)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reload"), object: nil)
            }else{
                self.userAccount = nil
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshMenu"), object: nil)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "logout"), object: nil)
            }
        })
    }
    
    func getUser() -> FIRUser?{
        return userAccount
    }

    
    func checkLogin()->Bool{
        if (userAccount != nil){
            return true
        }else{
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "logout"), object: nil)
            return false
        }
    }

    
    
    func getProfileImage(){
        if let url =  self.getUser()?.photoURL!{
            profileImage?.kf.setImage(with: url, placeholder: nil, options: nil, progressBlock: nil, completionHandler: {  image, error,cacheType, imageURL in
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "getPhoto"), object: nil)
            })
        }
    }
    
    
    
    
    
    
    func login(){
        self.credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
        FIRAuth.auth()?.signIn(with: self.credential!, completion: {(user,error) in
            print("logged in to FireBase")
        })
    }
    
    func logOut(){
        FBSDKAccessToken.setCurrent(nil)
        try! FIRAuth.auth()?.signOut()
    }
    
    func getData(){
        if(self.checkLogin()){
            var valueRefHandle = self.databaseRef.child("data").observe(.value, with: { (snapshat) in
                self.datas.removeAll()
                for type in snapshat.children{
                    let couponList = (type as! FIRDataSnapshot).value as! NSDictionary
                    let typeData = Type(snapshat: type as! FIRDataSnapshot)
                    typeData.name = (type as! FIRDataSnapshot).key
                    for coupon in couponList{
                        let data = coupon.value as! NSDictionary
                        let url = data.value(forKey: "imgURL") as! String
                        let img = UIImageView()
                        img.kf.setImage(with: URL(string: url), placeholder: nil, options: nil, progressBlock: nil, completionHandler: {  image, error,cacheType, imageURL in
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reload"), object: nil)
                        })
//                        img.kf.setImage(with: URL(string: url))
                        let couponData = Coupon(data: data,image: img)
                        
                        
                        typeData.coupons.append(couponData)
                        //save data to realm
                        //                        CouponRealmData.saveToRealm(addType: (type as! FIRDataSnapshot).key as! String, addCouponName: data.value(forKey: "name") as! String , imagePath: data.value(forKey: "imgURL") as! String)
                    }
                    self.datas.append(typeData)
                    
                }
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reload"), object: nil)
                
            })
        }else{
            print("please login first")
        }
    }

    func removeData(type:String, couponName:String,addUser:String) -> Bool{
        if( getUser()?.email == addUser){
            self.databaseRef.child("data").child(type).child(couponName).removeValue()
            return true
        }else{
            return false
        }
    }
    
    func addData(){
        
    }
    
}
