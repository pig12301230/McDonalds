//
//  CouponTableViewCell.swift
//  McDonalds
//
//  Created by 莊英祺 on 2016/11/15.
//  Copyright © 2016年 Winston. All rights reserved.
//

import Foundation
import UIKit

class CouponTableViewCell : UITableViewCell {
    var couponImageView : UIImageView!
    var couponLabel : UILabel!


    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        let width = Double(UIScreen.main.bounds.size.width)
        let height = Double(UIScreen.main.bounds.size.height)
        couponImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: height/2 - 40))
        
        couponLabel = UILabel(frame: CGRect(x: 0, y: height/2 - 20, width: width, height: 40))
        couponLabel.font = couponLabel.font.withSize(20)
        couponLabel.textAlignment = .center
        couponLabel.textColor = UIColor.black
        
        self.addSubview(couponImageView)
        self.addSubview(couponLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
       
      
    }
}
