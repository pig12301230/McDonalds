//
//  CouponCollectionViewCell.swift
//  McDonalds
//
//  Created by 莊英祺 on 2016/11/14.
//  Copyright © 2016年 Winston. All rights reserved.
//

import Foundation
import UIKit

class CouponCollectionViewCell : UICollectionViewCell {
    var couponImageView: UIImageView!
    var couponLabel:UILabel!
    
    override init(frame: CGRect){
        super.init(frame: frame)
        
        let width = Double(UIScreen.main.bounds.size.width)
        
        
        couponImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: width/3 - 10, height: width/3 - 10))
        couponImageView.contentMode = .scaleAspectFit
        couponLabel = UILabel(frame: CGRect(x: 0, y: width/3 - 10, width: width/3 - 10, height: 40))
        couponLabel.font = couponLabel.font.withSize(20)
        couponLabel.textAlignment = .center
        couponLabel.textColor = UIColor.black
        
        self.addSubview(couponImageView)
        self.addSubview(couponLabel)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
