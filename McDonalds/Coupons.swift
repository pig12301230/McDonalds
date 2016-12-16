//
//  Coupons.swift
//  McDonalds
//
//  Created by 莊英祺 on 2016/11/16.
//  Copyright © 2016年 Winston. All rights reserved.
//

import Foundation
import RealmSwift

class Coupons:Object{
    
    dynamic var couponName:String!
    dynamic var couponImagePath:String!
    
    override static func primaryKey() ->String?{
        return "couponName"
    }
}
