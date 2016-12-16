//
//  CouponCollectionViewHeaderView.swift
//  McDonalds
//
//  Created by 莊英祺 on 2016/11/24.
//  Copyright © 2016年 Winston. All rights reserved.
//

import Foundation
import UIKit

class CouponCollectionViewHeaderView:UICollectionReusableView{
    let screenSize = UIScreen.main.bounds.size
    var headerLabel:UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        headerLabel = UILabel(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: 40))
        headerLabel.textAlignment = .center
        headerLabel.textColor = UIColor.white
        
        self.addSubview(headerLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
