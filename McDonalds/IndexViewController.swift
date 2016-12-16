//
//  ViewController.swift
//  McDonalds
//
//  Created by 莊英祺 on 2016/11/14.
//  Copyright © 2016年 Winston. All rights reserved.
//

import UIKit
import RealmSwift
import FBSDKLoginKit

class IndexViewController: UIViewController ,UICollectionViewDelegate , UICollectionViewDataSource,UIGestureRecognizerDelegate {
    
    var screenSize:CGSize! = UIScreen.main.bounds.size
    let layout = UICollectionViewFlowLayout()
    var couponCollectionView :UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        print("\nRealm path : \n\(Realm.Configuration.defaultConfiguration.fileURL!)\n")
        
        //Navigation
        self.title = "優惠券"
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]
        self.navigationController?.navigationBar.barTintColor = UIColor.red
        let leftButton = UIBarButtonItem(title: "≣", style: .plain, target: self, action: nil)
        leftButton.setTitleTextAttributes([NSFontAttributeName:UIFont.systemFont(ofSize: 22)], for: .normal)
        self.navigationItem.leftBarButtonItem = leftButton
        let rightButton = UIBarButtonItem(title: "+", style: .plain, target: self, action: #selector(IndexViewController.addNewCouponPopover))
        rightButton.setTitleTextAttributes([NSFontAttributeName:UIFont.systemFont(ofSize: 22)], for: .normal)
        self.navigationItem.rightBarButtonItem = rightButton
        
        //FB Button
        var fbLoginButton = FBSDKLoginButton()
        fbLoginButton = FBSDKLoginButton(frame: CGRect(x: 0, y: (navigationController?.navigationBar.frame.height)! + 20, width: 130, height: 30))
        let layout = UICollectionViewFlowLayout()
        
        //longPress
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(self.handlePress))
        longPress.isEnabled = true
        longPress.delaysTouchesBegan = true
        longPress.delegate = self
        
        // layout setting
        //section間距
        layout.sectionInset = UIEdgeInsetsMake(3, 3, 3, 3)
        //行間距
        layout.minimumLineSpacing = 2
        // set Cell Size
        layout.itemSize = CGSize(width:(screenSize.width)/3 - 10, height: (screenSize.height)/3 - 10)
        layout.headerReferenceSize = CGSize(width: screenSize.width, height: 40)
        
        // Collectionview Setting
        
        couponCollectionView = UICollectionView(frame: CGRect(x: 0 , y:(navigationController?.navigationBar.frame.height)! + 50 ,width: screenSize.width ,height: screenSize.height-50), collectionViewLayout: layout)
        
        couponCollectionView.register(CouponCollectionViewCell.self, forCellWithReuseIdentifier: "CouponCollectionViewCell")
        couponCollectionView.register(CouponCollectionViewHeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "CouponCollectionViewHeaderView")
        couponCollectionView.backgroundColor = UIColor.white
        couponCollectionView.delegate = self
        couponCollectionView.dataSource = self
        couponCollectionView.addGestureRecognizer(longPress)
        
        self.view.addSubview(fbLoginButton)
        self.view.addSubview(couponCollectionView)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.reload), name:NSNotification.Name(rawValue: "reload"), object: nil)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:CollectionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { //一個section有幾個
        if (CouponRealmData.couponDate?.types[section].coupons.count != nil){
            return (CouponRealmData.couponDate?.types[section].coupons.count)!
        }else{
            return 0
        }
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if(CouponRealmData.couponDate?.types.count != nil){
            return (CouponRealmData.couponDate! .types.count)
        }else{
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell { //cell 設定
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CouponCollectionViewCell", for: indexPath) as! CouponCollectionViewCell
        let coupon = CouponRealmData.couponDate?.types[indexPath.section].coupons[indexPath.row].couponName
        let couponImagePath = CouponRealmData.couponDate?.types[indexPath.section].coupons[indexPath.row].couponImagePath
        
        cell.couponImageView.image = UIImage(contentsOfFile: couponImagePath!)
        cell.couponLabel.text = coupon
        cell.couponLabel.font = UIFont.systemFont(ofSize: 10)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,viewForSupplementaryElementOfKind kind: String,at indexPath: IndexPath) -> UICollectionReusableView {
        // 建立 UICollectionReusableView
        var headerView = CouponCollectionViewHeaderView()
        // header
        if kind == UICollectionElementKindSectionHeader {
             headerView =
                collectionView.dequeueReusableSupplementaryView(
                    ofKind: UICollectionElementKindSectionHeader,
                    withReuseIdentifier: "CouponCollectionViewHeaderView",
                    for: indexPath) as! CouponCollectionViewHeaderView 
            headerView.headerLabel.text = CouponRealmData.couponDate.types[indexPath.section].typeName
            headerView.backgroundColor = UIColor.darkGray
            
        }
        return headerView
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) { //點擊後事件處理
        self.navigationController?.pushViewController(CouponTableViewController(), animated: true)
    }
    
    
    func addNewCouponPopover(sender:UIBarButtonItem){
        let popVC = PopverController()
        popVC.view.backgroundColor = UIColor.lightGray.withAlphaComponent(0.8)
        self.addChildViewController(popVC)
        self.view.addSubview(popVC.view)
        popVC.didMove(toParentViewController: self)
    }
    
    func reload(notification: NSNotification){
        self.couponCollectionView.reloadData()
    }
    
    func handlePress(_ gestureRecognizer:UILongPressGestureRecognizer){
        if gestureRecognizer.state != UIGestureRecognizerState.ended {
            let p = gestureRecognizer.location(in: couponCollectionView)
            let indexPath = couponCollectionView.indexPathForItem(at: p)
            
            let deleteAlert = UIAlertController(title: "刪除優惠", message: "確定要刪除優惠嗎？", preferredStyle: .alert)
            deleteAlert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
            deleteAlert.addAction(UIAlertAction(title: "確定", style: .default, handler: {(UIAlertAction)->Void in
                
                if let index = indexPath {
                    // do stuff with your cell, for example print the indexPath
                    try! CouponRealmData.realmData.write({
                        CouponRealmData.realmData.delete(CouponRealmData.couponDate.types[index.section].coupons[index.row])
                    })
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reload"), object: nil)
                } else {
                    print("Could not find index path")
                }
            }))
            self.present(deleteAlert,animated: true,completion: nil)
            
        }
    }
    
    
}

