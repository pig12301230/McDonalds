//
//  PopverController.swift
//  McDonalds
//
//  Created by 莊英祺 on 2016/11/18.
//  Copyright © 2016年 Winston. All rights reserved.
//

import UIKit
import RealmSwift


class PopverController: UIViewController ,UIPickerViewDelegate ,UIPickerViewDataSource,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    let screenSize = UIScreen.main.bounds.size
    private var couponName : UITextField!
    private var backgroundView : UIView!
    private var typeTextFied : UITextField!
    private var addImageButton : UIButton!
    private var newCouponButton : UIButton!
    
    let types = ["免費","折價優惠","買一送一","買就送"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let width = screenSize.width
        let height = screenSize.height
        //init view
        
        backgroundView = UIView(frame: CGRect(x: width * 0.1 , y: height * 0.1 , width: width * 0.8, height: height * 0.8))
        backgroundView.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        
        //init picker
        let typePicker = UIPickerView()
        
        typePicker.delegate = self
        typePicker.dataSource = self
        
        
        typePicker.showsSelectionIndicator = true
        
        
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.blue
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.doneAction))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.doneAction))
        
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        //Init couponNameTextField
        
        couponName = UITextField(frame: CGRect(x: width * 0.1 , y: height * 0.1, width: width * 0.6, height: height * 0.1))
        couponName.placeholder = "請輸入優惠名稱"
        couponName.borderStyle = .roundedRect
        couponName.clearButtonMode = .whileEditing
        couponName.returnKeyType = .done
        couponName.textColor = UIColor.black
        couponName.backgroundColor = UIColor.lightGray
        
        //Init typeTextFied
        
        typeTextFied = UITextField(frame: CGRect(x: width * 0.1 , y: height * 0.25, width: width * 0.6, height: height * 0.1))
        typeTextFied.text = types[0]
        typeTextFied.inputView = typePicker
        typeTextFied.inputAccessoryView = toolBar
        typeTextFied.borderStyle = .roundedRect
        typeTextFied.textColor = UIColor.black
        typeTextFied.backgroundColor = UIColor.lightGray
        
        //Init addImageButton
        
        addImageButton = UIButton(frame: CGRect(x: width * 0.2, y: height * 0.4 , width: width * 0.4, height: height * 0.25))
        addImageButton.setImage(UIImage(named:"photo"), for: .normal)
        addImageButton.addTarget(self, action: #selector(self.addImageFromLibrary), for: .touchUpInside)
        //Init NewCouponButton
        
        newCouponButton = UIButton(frame: CGRect(x: width * 0.3, y: height * 0.7 , width: width * 0.2, height: height * 0.05))
        newCouponButton.setTitle("OK", for: .normal)
        newCouponButton.setTitleColor(UIColor.white, for: .normal)
        newCouponButton.backgroundColor = UIColor.darkGray
        newCouponButton.titleLabel?.textColor = UIColor.black
        newCouponButton.addTarget(self, action: #selector(self.newCouponImformation), for: .touchUpInside)
        
        
        backgroundView.addSubview(couponName)
        backgroundView.addSubview(typeTextFied)
        backgroundView.addSubview(addImageButton)
        backgroundView.addSubview(newCouponButton)
        
        self.view.addSubview(backgroundView)
        
        couponName.delegate = self
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return types.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return types[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        typeTextFied.text = types[row]
        
    }
    func doneAction(){
        typeTextFied.resignFirstResponder()
    }
    
    func newCouponImformation(){
        if(couponName.text != "" && typeTextFied.text != nil){
            let imageData = UIImagePNGRepresentation((addImageButton.imageView?.image)!)
            let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as? NSString
            let writePath = documentDirectory!.appendingPathComponent(couponName.text!)
            if (CouponRealmData.check(addType: typeTextFied.text!, addCouponName: couponName.text!,imagePath:writePath)){
                try? imageData?.write(to: URL(fileURLWithPath: writePath), options: [])
                CouponRealmData.saveToRealm(addType: typeTextFied.text!, addCouponName: couponName.text! , imagePath: writePath)
                self.view.removeFromSuperview()
                
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reload"), object: nil)
            }else{
                let alert = UIAlertController(title: "提醒", message: "請確認優惠內容都已填寫或是否衝突", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert,animated: true,completion: nil)
                
            }
        }else{
            let alert = UIAlertController(title: "提醒", message: "請確認優惠內容都已填寫或是否衝突", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert,animated: true,completion: nil)
            
        }
        
    }
    func addImageFromLibrary(){
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let couponImagePicker = UIImagePickerController()
            //            couponImagePicker.allowsEditing = true
            couponImagePicker.delegate = self
            couponImagePicker.sourceType = .photoLibrary
            present(couponImagePicker, animated: true, completion: nil)
        }
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            addImageButton.setImage(image, for: .normal)
        } else if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            addImageButton.setImage(image, for: .normal)
        } else {
            addImageButton.setImage(nil, for: .normal)
        }
        
        dismiss(animated:true, completion: nil)
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
}
