//
//  Coupon.swift
//  McDonalds
//
//  Created by 莊英祺 on 2016/11/15.
//  Copyright © 2016年 Winston. All rights reserved.
//

import Foundation
import RealmSwift


class CouponDateProvider:Object{

    dynamic var couponDateTime:String!
    let types = List<CouponType>()
    
//    func addType(type: CouponType) {
//        types.append(type)
//    }
    
    override static func primaryKey() ->String?{
        return "couponDateTime"
    }

}
