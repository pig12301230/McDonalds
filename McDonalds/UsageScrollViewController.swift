//
//  UsageScrollViewController.swift
//  McDonalds
//
//  Created by 莊英祺 on 2017/1/6.
//  Copyright © 2017年 Winston. All rights reserved.
//

import UIKit

class UsageScrollViewController: UIViewController,UIScrollViewDelegate {

    var usageImageCount:Int = 1
    var uploadImageCount:Int = 6
    var isUploadDescription:Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.edgesForExtendedLayout =  UIRectEdge.init(rawValue: 0)

        nav()
        
        toggle()
        self.view.addSubview(usageScrollView)
        self.view.addSubview(uploadScrollView)
        self.view.addSubview(usagePageControl)
        // Do any additional setup after loading the view.
    }

    func toggle(){
        self.revealViewController()
        if self.revealViewController() != nil {
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
            
        }
    }

    

    func nav(){
        self.title = "使用說明"
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]
        self.navigationController?.navigationBar.barTintColor = UIColor.red
        self.navigationController?.navigationBar.tintColor = UIColor.white
        if(self.navigationController?.viewControllers.count == 1){
            let leftButton = UIBarButtonItem(title: "≣", style: .plain, target: self	.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)))
            leftButton.setTitleTextAttributes([NSFontAttributeName:UIFont.systemFont(ofSize: 22)], for: .normal)
            self.navigationItem.leftBarButtonItem = leftButton
        }else{
            let leftButton = UIBarButtonItem(title: "❮", style: .plain, target: self, action: #selector(back))
            leftButton.setTitleTextAttributes([NSFontAttributeName:UIFont.systemFont(ofSize: 22)], for: .normal)
            self.navigationItem.leftBarButtonItem = leftButton
        }
        let rightButton = UIBarButtonItem(title: "上傳說明", style: .plain, target: self, action: #selector(changeSV))
        rightButton.setTitleTextAttributes([NSFontAttributeName:UIFont.systemFont(ofSize: 16)], for: .normal)
        self.navigationItem.rightBarButtonItem = rightButton
    }
    func back(){
        let _ = self.navigationController?.popViewController(animated: true)
    }
    func changeSV(){
        if(isUploadDescription){
            self.navigationItem.rightBarButtonItem?.title = "上傳說明"
            isUploadDescription = false
            self.uploadScrollView.isHidden = true
            self.usageScrollView.isHidden = false
            
       
            self.uploadScrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
            
            self.usagePageControl.currentPage = 0
            self.usagePageControl.numberOfPages = 1
        }else{
            self.navigationItem.rightBarButtonItem?.title = "使用說明"
            isUploadDescription = true
            self.uploadScrollView.isHidden = false
            self.usageScrollView.isHidden = true
            
            self.usageScrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)

            
            self.usagePageControl.currentPage = 0
            self.usagePageControl.numberOfPages = 6
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        // 左右滑動到新頁時 更新 UIPageControl 顯示的頁數
        let page = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
        self.usagePageControl.currentPage = page

    }
    

    lazy var usageScrollView:UIScrollView! = {
        let scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height  - 64 ))
        
        var img = UIImageView(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height - 64 ))
        img.image = UIImage(named: "usage")
        img.contentMode = UIViewContentMode.scaleAspectFit
        scrollView.addSubview(img)
        
        scrollView.contentSize = CGSize(width: screenSize.width * CGFloat(self.usageImageCount) , height: 0)
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        scrollView.isHidden = false
        
        return scrollView
        
    }()
    
    lazy var uploadScrollView:UIScrollView! = {
        let scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height  - 64 ))
        
        for index in 1...self.uploadImageCount{
            var img = UIImageView(frame: CGRect(x: CGFloat(Int(screenSize.width) * (index - 1)), y: 0, width: screenSize.width, height: screenSize.height - 64 ))
            img.image = UIImage(named: "upload"+"\(index)")
            img.contentMode = UIViewContentMode.scaleAspectFit
            scrollView.addSubview(img)
        }
        scrollView.contentSize = CGSize(width: screenSize.width * CGFloat(self.uploadImageCount) , height: 0)
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        scrollView.isHidden = true
        
        return scrollView
        
    }()

    lazy var usagePageControl:UIPageControl! = {
        let pageControl = UIPageControl(frame: CGRect(x: 0, y: 0, width: screenSize.width * 0.85, height: 50))
        pageControl.backgroundColor = UIColor.clear
        pageControl.center = CGPoint(x: screenSize.width * 0.5, y: screenSize.height * 0.94 - 64 )
        
        pageControl.numberOfPages = 1
        pageControl.currentPage = 0
        
        pageControl.currentPageIndicatorTintColor = UIColor.red
        pageControl.pageIndicatorTintColor = UIColor.yellow
 
        return pageControl
        
    }()
    


}
