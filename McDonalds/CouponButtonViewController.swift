//
//  CouponButtonViewController.swift
//  McDonalds
//
//  Created by 莊英祺 on 2016/11/15.
//  Copyright © 2016年 Winston. All rights reserved.
//

import UIKit

class CouponButtonViewController: UIViewController {

    private var couponImage:UIImageView!
    private var redeemButton = UIButton()
    private var timerLabel = UILabel()
    private var clock = UIImageView()
    private var timeCount = 120
    var imagePath:String!
    override func viewDidLoad() {
        super.viewDidLoad()
        //NavigationBar
        self.title = "優惠券"
        self.navigationController?.navigationBar.barTintColor = UIColor.red
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]
        self.navigationController?.navigationBar.tintColor = UIColor.white
        let leftButton = UIBarButtonItem(title: "❮", style: .plain, target: self, action: #selector(CouponButtonViewController.back))
        leftButton.setTitleTextAttributes([NSFontAttributeName:UIFont.systemFont(ofSize: 25)], for: .normal)
        let rightButton = UIBarButtonItem(title: "搜尋附近餐廳", style: .plain, target: self, action: #selector(CouponButtonViewController.back))
        rightButton.setTitleTextAttributes([NSFontAttributeName:UIFont.systemFont(ofSize: 16)], for: .normal)
        self.navigationItem.leftBarButtonItem = leftButton
        self.navigationItem.rightBarButtonItem = rightButton
        
        let screen = UIScreen.main.bounds.size
        // Button
        
        redeemButton = UIButton(frame: CGRect(x: 0, y: screen.height - (self.navigationController?.navigationBar.bounds.height)!-90 , width: screen.width, height: 90))
        redeemButton.isEnabled = true
        redeemButton.backgroundColor = UIColor(colorLiteralRed: 255/255, green: 175/255, blue: 41/255, alpha: 1)
        redeemButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        redeemButton.setTitle("兌換優惠", for: .normal)
        redeemButton.setTitleColor(UIColor.white, for: .normal)
        redeemButton.titleLabel?.textAlignment = .center
        redeemButton.titleEdgeInsets.bottom = 30
        redeemButton.addTarget(nil, action: #selector(CouponButtonViewController.clickRedeem), for: .touchUpInside)
        redeemButton.isHidden = false
        
        //timerLabel
        timerLabel = UILabel(frame: CGRect(x: 0, y: screen.height - (self.navigationController?.navigationBar.bounds.height)!-110 , width: screen.width, height: 110))
        timerLabel.backgroundColor = UIColor(colorLiteralRed: 255/255, green: 175/255, blue: 41/255, alpha: 1)
        timerLabel.text = " 優惠倒數 \(timeCount/60):"+String(format:"%02d",timeCount%60)
        timerLabel.textAlignment = .center
        timerLabel.textColor = UIColor.white
        timerLabel.baselineAdjustment = .alignCenters
        timerLabel.font = UIFont.systemFont(ofSize: 22)
        
        clock = UIImageView(frame: CGRect(x: 85, y: screen.height - (self.navigationController?.navigationBar.bounds.height)!-67 , width: 25, height: 25))
        clock.image = #imageLiteral(resourceName: "clock")
        
        clock.isHidden = true
        timerLabel.isHidden = true
        
        
        couponImage = UIImageView(frame: CGRect(x: 0, y:  0, width: screen.width, height: screen.height-120))
        couponImage.image = UIImage(contentsOfFile: imagePath)
        // Do any additional setup after loading the view.
        self.view.addSubview(couponImage)
        self.view.addSubview(redeemButton)
        self.view.addSubview(timerLabel)
        self.view.addSubview(clock)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func update(){
        if(timeCount > 0){
            timeCount -= 1
            timerLabel.text = " 優惠倒數 \(timeCount/60):"+String(format:"%02d",timeCount%60)
        }else{
            let _ = self.navigationController?.popViewController(animated: true)
        }
    }
    
    func clickRedeem(){
        let alert = UIAlertController(title: "確認兌換優惠", message: "請確認您已在麥當勞餐廳櫃檯，點選「立即兌換」後，需於兩分鐘內出示給結帳人員。", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "暫不兌換", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "立即兌換", style: .default, handler: {(UIAlertAction)->Void in
            self.redeemButton.isHidden = true
            self.timerLabel.isHidden = false
            self.clock.isHidden = false
            var _ = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(CouponButtonViewController.update), userInfo: nil, repeats: true)
            
        }))
        self.present(alert,animated: true,completion: nil)

    }
    @objc private func back(){
       let _ =  self.navigationController?.popViewController(animated: true)
    }
    
}
