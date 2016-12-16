//
//  CouponRealmData.swift
//  McDonalds
//
//  Created by 莊英祺 on 2016/11/19.
//  Copyright © 2016年 Winston. All rights reserved.
//

import Foundation
import RealmSwift

class CouponRealmData{
    
    static let realmData = try! Realm()
    static var couponDateList = List<CouponDateProvider>()
    static var couponDate:CouponDateProvider! {
        get{
            return CouponRealmData.realmData.objects(CouponDateProvider.self).first
        }
        
    }
    
    static func saveCouponDate(couponDate: String)->Void{
        let newCouponDate = CouponDateProvider()
        newCouponDate.couponDateTime = couponDate

        if(CouponRealmData.realmData.objects(CouponDateProvider.self).filter("couponDateTime = '\(couponDate)'").count == 0){
            try! CouponRealmData.realmData.write({
                CouponRealmData.realmData.add(newCouponDate)
            })
        }
    }
    
    static func saveCouponType(couponDate:String, couponType: String)->Void{
        let typeName = CouponType()
        typeName.typeName = couponType

        if(CouponRealmData.realmData.objects(CouponDateProvider.self).filter("couponDateTime = '\(couponDate)'").first?.types.filter("typeName = '\(couponType)'").count == 0 ){
            try! CouponRealmData.realmData.write({
                CouponRealmData.realmData.objects(CouponDateProvider.self).filter("couponDateTime = '\(couponDate)'").first?.types.append(typeName)
            })
        }
    }
    
    static func saveCoupon(couponDate:String, couponType: String,coupon: String,path:String)->Void{
        let couponName = Coupons()
        
        couponName.couponName = coupon
        couponName.couponImagePath = path

        if(CouponRealmData.realmData.objects(CouponDateProvider.self).filter("couponDateTime = '\(couponDate)'").first?.types.filter("typeName = '\(couponType)'").first?.coupons.filter("couponName = '\(coupon)'").count == 0 ){
            try! CouponRealmData.realmData.write({
                CouponRealmData.realmData.objects(CouponDateProvider.self).filter("couponDateTime = '\(couponDate)'").first?.types.filter("typeName = '\(couponType)'").first?.coupons.append(couponName)
            })
        }else{
            try! CouponRealmData.realmData.write({
                CouponRealmData.realmData.add(couponName, update: true)
                
            })
        }
    }
    
     static func saveToRealm(addType:String,addCouponName:String,imagePath:String){
        let date:String = "Today"
        self.saveCouponDate(couponDate: date)
        self.saveCouponType(couponDate: date, couponType: addType)
        self.saveCoupon(couponDate: date, couponType: addType ,coupon: addCouponName ,path: imagePath)
    }
    
    static func check(addType:String,addCouponName:String,imagePath:String) ->Bool{
        if(CouponRealmData.realmData.objects(CouponDateProvider.self).filter("couponDateTime = 'Today'").count == 0){
            saveToRealm(addType: addType, addCouponName: addCouponName, imagePath: imagePath)
        }
        if(CouponRealmData.couponDate.types.count != 0){
            for type in CouponRealmData.couponDate.types{
                if(addType != type.typeName && type.coupons.count != 0){
                    for coupon in type.coupons{
                        if(addCouponName == coupon.couponName){
                            return false
                        }
                    }
                }
            }
            return true
        }
        return true
    }
}
