//
//  CouponTableViewController.swift
//  McDonalds
//
//  Created by 莊英祺 on 2016/11/15.
//  Copyright © 2016年 Winston. All rights reserved.
//

import UIKit
import RealmSwift

class CouponTableViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var chosenIndex = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        self.view.backgroundColor = UIColor.red
        self.title = "優惠券"
        self.navigationController?.navigationBar.barTintColor = UIColor.red
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]
        self.navigationController?.navigationBar.tintColor = UIColor.white
        let leftButton = UIBarButtonItem(title: "❮", style: .plain, target: self, action: #selector(CouponTableViewController.back))
        leftButton.setTitleTextAttributes([NSFontAttributeName:UIFont.systemFont(ofSize: 25)], for: .normal)
        let rightButton = UIBarButtonItem(title: "使用說明", style: .plain, target: self, action: #selector(CouponTableViewController.back))
        rightButton.setTitleTextAttributes([NSFontAttributeName:UIFont.systemFont(ofSize: 16)], for: .normal)
        self.navigationItem.leftBarButtonItem = leftButton
        self.navigationItem.rightBarButtonItem = rightButton
        
        
        
        
        let screenSize = UIScreen.main.bounds.size
        
        let couponTableView = UITableView(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height))
        couponTableView.register(CouponTableViewCell.self, forCellReuseIdentifier: "CouponTableViewCell")
        
        
        couponTableView.delegate = self
        couponTableView.dataSource = self
        couponTableView.allowsSelection = true
        
        
        self.view.addSubview(couponTableView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (CouponRealmData.couponDate?.types[section].coupons.count)!
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return (CouponRealmData.couponDate?.types.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CouponTableViewCell", for: indexPath) as! CouponTableViewCell
        
        let couponImagePath = CouponRealmData.couponDate?.types[indexPath.section].coupons[indexPath.row].couponImagePath
        
        cell.couponImageView.image = UIImage(contentsOfFile: couponImagePath!)
        
        if(indexPath.row<3){
            let underlineAttribute = [NSUnderlineStyleAttributeName: NSUnderlineStyle.styleSingle.rawValue]
            let underlineAttributedString = NSAttributedString(string: "兌換優惠", attributes: underlineAttribute)
            cell.couponLabel.attributedText = underlineAttributedString
            
        }else{
            cell.couponLabel?.text = "已截止"
        }
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        chosenIndex = indexPath.row
        let a = CouponButtonViewController()
        a.imagePath = CouponRealmData.couponDate?.types[indexPath.section].coupons[indexPath.row].couponImagePath
        
        self.navigationController?.pushViewController(a, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.size.height/2 + 30
    }
    @objc private func back(){
        let _ = self.navigationController?.popViewController(animated: true)
    }
}
