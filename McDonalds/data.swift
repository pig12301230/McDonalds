//
//  data.swift
//  McDonalds
//
//  Created by 莊英祺 on 2016/12/27.
//  Copyright © 2016年 Winston. All rights reserved.
//

import Foundation
import CoreLocation
import FirebaseDatabase

class Coupon{
    var name:String!
    var addUser:String!
    var imageURL:String!
    var img:UIImageView?
    
    init(data: NSDictionary,image: UIImageView){
        self.name = data.value(forKey: "name") as! String
        self.addUser = data.value(forKey: "addUser") as! String
        self.imageURL = data.value(forKey: "imgURL") as! String
        self.img = image
    }
}

class Type{
    var name:String!
    var coupons = [Coupon]()
    
    init(snapshat: FIRDataSnapshot){
        self.name = snapshat.key
    }
}

class MapData{
    var name:String!
    var address:String!
    var phoneNumber:String!
    var longitude:CLLocationDegrees!
    var latitude:CLLocationDegrees!
}
