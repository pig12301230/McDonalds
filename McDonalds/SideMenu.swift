//
//  SideMenu.swift
//  McDonalds
//
//  Created by 莊英祺 on 2016/12/19.
//  Copyright © 2016年 Winston. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FirebaseAuth
import FirebaseStorage

class SideMenu: UIViewController ,UITableViewDelegate,UITableViewDataSource{
    
    let menuList = ["首頁","餐廳位置","小幫手"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.red
        
        
        updateInterface()
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateInterface), name: NSNotification.Name(rawValue: "refreshMenu"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.getPhoto), name: NSNotification.Name(rawValue: "getPhoto"), object: nil)

        self.view.addSubview(userPhoto)
        self.view.addSubview(userName)
        self.view.addSubview(menu)
        self.view.addSubview(fbLogOutButton)

        
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        UITableView_Auto_Height();
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    //image /name
    //tableview
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SideMenuCell", for: indexPath) as! SideMenuCell
        
        cell.menuCategoryImage.image = UIImage(named: menuList[indexPath.row])
        cell.menuCategoryName.text = menuList[indexPath.row]
        
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selected = menuList[indexPath.row]
        
        switch selected {
        case menuList[0]:
            let front = UINavigationController(rootViewController: IndexViewController())
            self.revealViewController().pushFrontViewController(front, animated: true)
        case menuList[1]:
            let front = UINavigationController(rootViewController: MapViewController())
            self.revealViewController().pushFrontViewController(front, animated: true)
        case menuList[2]:
            let front = UINavigationController(rootViewController: UsageScrollViewController())
            self.revealViewController().pushFrontViewController(front, animated: true)
        default:
            break
        }
    }
    func UITableView_Auto_Height()
    {
        if(self.menu.contentSize.height < self.menu.frame.height){
            var frame: CGRect = self.menu.frame;
            frame.size.height = self.menu.contentSize.height;
            self.menu.frame = frame;
        }
    }
    
    func updateInterface(){
        if let user = FirebaseModel.sharedFirebaseModel.getUser(){
            self.fbLogOutButton.isHidden = false
            self.userName.text = user.displayName
            FirebaseModel.sharedFirebaseModel.getProfileImage()
            
        }else{
            self.fbLogOutButton.isHidden = true
            self.userPhoto.image = UIImage(named: "userPhoto")
            self.userName.text = "Hello,使用者"
        }
    }
    //FBLoginSDK
    
    func getPhoto(){
        self.userPhoto.image = FirebaseModel.sharedFirebaseModel.profileImage?.image
    }
    
    func loginButtonDidLogOut() {
        print("log out")
        //fb log out
        //firebase log out
        FirebaseModel.sharedFirebaseModel.logOut()        
        
        self.revealViewController().revealToggle(animated: true)
        updateInterface()
        //to do go to loginView

    }
    
    //MARK view
    lazy var userPhoto :UIImageView = {
        
        let photo = UIImageView(frame: CGRect(x: screenSize.width * 0.1 , y: screenSize.height * 0.1, width: screenSize.width * 0.3 , height: screenSize.width * 0.3))
        photo.layer.cornerRadius = screenSize.width * 0.15
        photo.clipsToBounds = true
        return photo
    }()
    
    var userName : UILabel = {
        
        let label = UILabel(frame: CGRect(x: screenSize.width * 0.1, y: screenSize.height * 0.11 + screenSize.width * 0.3 , width: screenSize.width * 0.3, height: screenSize.height * 0.1))
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        label.textColor = UIColor.white
        
        return label
    }()
    
    lazy var menu :UITableView = {
        
        let menu = UITableView(frame: CGRect(x: 0, y: screenSize.height * 0.22 + screenSize.width * 0.3, width: screenSize.width * 0.5 , height: screenSize.height * 0.4))
        
        menu.register(SideMenuCell.self, forCellReuseIdentifier: "SideMenuCell")
        menu.delegate = self
        menu.dataSource = self
        menu.allowsSelection = true
        return menu
    }()
    
    lazy var fbLogOutButton :UIButton = {
        
        let button = UIButton(frame: CGRect(x: screenSize.width * 0.1, y: screenSize.height * 0.65 + screenSize.width * 0.3  , width: 120, height: 30))
        button.setTitle("LogOut", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.addTarget(self, action: #selector(self.loginButtonDidLogOut), for: .touchUpInside)
        button.isHidden = true
        return button
    }()
    
}
