//
//  CouponType.swift
//  McDonalds
//
//  Created by 莊英祺 on 2016/11/16.
//  Copyright © 2016年 Winston. All rights reserved.
//

import Foundation
import RealmSwift

class CouponType:Object{
    dynamic var typeName:String!
    let coupons = List<Coupons>()
//    
//    func addCoupon(coupon:Coupons){
//        coupons.append(coupon)
//    }



}
