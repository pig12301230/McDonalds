//
//  CustomProgressView.swift
//  McDonalds
//
//  Created by 莊英祺 on 2017/1/7.
//  Copyright © 2017年 Winston. All rights reserved.
//

import Foundation

class CustomProgressView: UIProgressView {
    
    var height:CGFloat = 1.0
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        let size:CGSize = CGSize.init(width: screenSize.width, height: height)
        
        return size
    }
    
}
