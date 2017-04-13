//
//  SideMenuCell.swift
//  McDonalds
//
//  Created by 莊英祺 on 2016/12/20.
//  Copyright © 2016年 Winston. All rights reserved.
//

import Foundation
import UIKit

class SideMenuCell : UITableViewCell {
    var menuCategoryImage : UIImageView!
    var menuCategoryName : UILabel!
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.red
        let width = Double(UIScreen.main.bounds.size.width)
        let height = Double(UIScreen.main.bounds.size.height)
        menuCategoryImage = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: height/2 - 40))
        
        menuCategoryName = UILabel(frame: CGRect(x: 0 , y: 10, width: width/2, height: 40))
        menuCategoryName.font = UIFont.boldSystemFont(ofSize: 16)
        menuCategoryName.textAlignment = .center
        menuCategoryName.textColor = UIColor.white
        
        self.addSubview(menuCategoryImage)
        self.addSubview(menuCategoryName)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        
    }
}
