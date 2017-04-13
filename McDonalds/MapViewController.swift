//
//  MapViewController.swift
//  McDonalds
//
//  Created by 莊英祺 on 2017/1/6.
//  Copyright © 2017年 Winston. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Alamofire

class MapViewController: UIViewController ,CLLocationManagerDelegate,MKMapViewDelegate {
    
    let locationManager = CLLocationManager()
    var mcDonaldsLocation:[MapData] = []
    let mapAPi = "http://www5.mcdonalds.com/googleapps/GoogleSearchTaiwanAction.do?method=searchLocation&searchTxtLatlng=(25.0792018,121.54270930000007)&actionType=filterRestaurant&language=zh&country=tw"
    var selectAnnotationTitle :String!
    var selectAnnotation :MKAnnotation!
    
    override func viewDidAppear(_ animated: Bool) {
        if CLLocationManager.authorizationStatus() == .denied{
            
            let alertController = UIAlertController(
                title: "請開啟定位權限",
                message:"如要變更權限，請至 設定 > 隱私權 > 定位服務 開啟",
                preferredStyle: .alert)
            let okAction = UIAlertAction(title: "確認", style: .default, handler: nil)
            alertController.addAction(okAction)
            self.present(alertController,animated: true,completion: nil)
        }
        
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        locationManager.stopUpdatingLocation()
    }
    //    override func viewWillAppear(_ animated: Bool) {
    //        locationManager.startUpdatingLocation()
    //    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout =  UIRectEdge.init(rawValue: 0)
        nav()
        toggle()
        
        locationManager.delegate = self
        locationManager.distanceFilter = kCLLocationAccuracyHundredMeters
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        //        mcMapView.center = CGPoint(x: (locationManager.location?.coordinate.latitude)!, y: (locationManager.location?.coordinate.longitude)!)
        
        self.view.addSubview(mcMapView)
        self.view.addSubview(localBtn)
        self.view.addSubview(mcLocationInforamtionView)
        // Do any additional setup after loading the view.
    }
    
    

    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = manager.location?.coordinate {
            let currentLocate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
            let span = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
            let region = MKCoordinateRegion(center: currentLocate , span: span)
            mcMapView.setRegion(region, animated: true)
        }
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
         selectAnnotationTitle = view.annotation?.title!
         selectAnnotation = view.annotation
        print("1")
        if(selectAnnotation is MKUserLocation){
            return
        }else{
            for data in mcDonaldsLocation{
                if(data.name == selectAnnotationTitle){
                    locationPhone.text = data.phoneNumber
                    locationName.text = data.name
                    locationAddress.text = data.address
                    mcLocationInforamtionView.isHidden = false
                    break
                }
            }
        }
        
    }

    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
            self.mcLocationInforamtionView.isHidden = true
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !(annotation is MKUserLocation) else {
            return nil
        }
        let reuseIdentifier = "mcPin"
        var annotationView = mcMapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier)
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
            annotationView?.canShowCallout = true
        } else {
            annotationView?.annotation = annotation
        }
        
        annotationView?.image = UIImage(named:"pin")
        annotationView?.frame.size = CGSize(width: 20.0, height: 30.0)
        
        return annotationView
    }
    
    func getMcDonaldsLocation(){
        if let currentUserCoordinate = locationManager.location?.coordinate{
            let latitude = currentUserCoordinate.latitude
            let longtude = currentUserCoordinate.longitude
            let url = URL(string:  "http://www5.mcdonalds.com/googleapps/GoogleSearchTaiwanAction.do?method=searchLocation&searchTxtLatlng=(\(latitude),\(longtude))&actionType=filterRestaurant&language=zh&country=tw")
            DispatchQueue.global(qos: .background).async {
                Alamofire.request(url!).responseJSON(completionHandler: {
                    response in
                    if let result = response.result.value {
                        self.mcDonaldsLocation = []
                        let JSONData = (result as! NSDictionary).value(forKey: "results") as! [[String:Any]]
                        
                        for parsedata in JSONData {
                            let data = parsedata as NSDictionary
                           
                            let mapData = MapData()
                            mapData.name = data.object(forKey: "name") as! String
                            mapData.latitude = data.object(forKey: "latitude") as! CLLocationDegrees
                            mapData.longitude = data.object(forKey: "longitude") as! CLLocationDegrees
                            mapData.phoneNumber = data.object(forKey: "telephone") as! String
                            mapData.address = ((data.object(forKey: "addresses") as! [NSObject]).first?.value(forKey: "address") as! String).substring(from: "<h3>".endIndex)
                            //處理地址字串
                            let str1 = "</h3>, <br/>".characters.count + 15

                            let start =  mapData.address.index( mapData.address.startIndex, offsetBy: 0)
                            let end =  mapData.address.index( mapData.address.endIndex, offsetBy: -str1)
                            let range = start..<end
                            mapData.address = mapData.address.substring(with: range)
                            mapData.address  = mapData.address.replacingOccurrences(of: "<", with: "")

                            
                            self.mcDonaldsLocation.append(mapData)
                           
                            let pointAnnotation = MKPointAnnotation()
                            pointAnnotation.title = data.object(forKey: "name") as! String?
                            pointAnnotation.coordinate = CLLocationCoordinate2D(latitude: data.object(forKey: "latitude") as! CLLocationDegrees , longitude: data.object(forKey: "longitude") as! CLLocationDegrees )
                        
                            
                            let pinAnnotationView = MKPinAnnotationView(annotation: pointAnnotation, reuseIdentifier: "mcPin")
                            self.mcMapView.addAnnotation(pinAnnotationView.annotation!)
                        }
                        
                    }
                })
            }
        }
    }
    
    func userLocation(){
        mcMapView.setUserTrackingMode(.follow, animated: true)
    }
    
    func nav(){
        self.view.backgroundColor = UIColor.white
        self.title = "地圖"
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]
        self.navigationController?.navigationBar.barTintColor = UIColor.red
        self.navigationController?.navigationBar.tintColor = UIColor.white
        if(self.navigationController?.viewControllers.count != 1){
            let leftButton = UIBarButtonItem(title: "❮", style: .plain, target: self, action: #selector(back))
            leftButton.setTitleTextAttributes([NSFontAttributeName:UIFont.systemFont(ofSize: 22)], for: .normal)
            self.navigationItem.leftBarButtonItem = leftButton
        }else{
            let leftButton = UIBarButtonItem(title: "≣", style: .plain, target: self	.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)))
            leftButton.setTitleTextAttributes([NSFontAttributeName:UIFont.systemFont(ofSize: 22)], for: .normal)
            self.navigationItem.leftBarButtonItem = leftButton
        }
        let rightButton = UIBarButtonItem(title: "附近麥當勞", style: .plain, target: self, action: #selector(getMcDonaldsLocation))
        rightButton.setTitleTextAttributes([NSFontAttributeName:UIFont.systemFont(ofSize: 16)], for: .normal)
        self.navigationItem.rightBarButtonItem = rightButton
    }
    func carNav(){
        if(locationManager.location == nil){
            return
        }
        if #available(iOS 10.0, *) {
            let pA = MKPlacemark(coordinate: (locationManager.location?.coordinate)!)
            let pB = MKPlacemark(coordinate: selectAnnotation.coordinate)
        
            
            let mA = MKMapItem(placemark: pA)
            let mB = MKMapItem(placemark: pB)
        
            mA.name = "目前位置"
            mB.name = selectAnnotationTitle
            let route = [mA, mB]
        
            MKMapItem.openMaps(with: route, launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
        }
    }
    
    func back(){
        let _ = self.navigationController?.popViewController(animated: true)
    }
    func toggle(){
        self.revealViewController()
        if self.revealViewController() != nil {
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())

        }
    }

    lazy var locationName: UILabel! = {
        let label = UILabel(frame: CGRect(x: 10, y: 10, width: screenSize.width, height: 30))
        label.textColor = UIColor.black
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont.boldSystemFont(ofSize: 18)
        
        return label
    }()
    lazy var locationPhone: UILabel! = {
        let label = UILabel(frame: CGRect(x: 10, y: 40, width: screenSize.width, height: 30))
        label.textColor = UIColor.darkGray
        label.adjustsFontSizeToFitWidth = true
        label.font = label.font.withSize(12)
        return label
    }()
    lazy var locationAddress: UILabel! = {
        let label = UILabel(frame: CGRect(x: 10, y: 70, width: screenSize.width, height: 30))
        label.textColor = UIColor.darkGray
        label.adjustsFontSizeToFitWidth = true
        label.font = label.font.withSize(12)
        return label
    }()
    
    lazy var mcLocationInforamtionView: UIView! = {
       let view = UIView(frame: CGRect(x: 0, y: screenSize.height * 0.8 - 64 , width: screenSize.width, height: screenSize.height * 0.2))
        view.backgroundColor = UIColor.white
        view.addSubview(self.locationName)
        view.addSubview(self.locationPhone)
        view.addSubview(self.locationAddress)
        if #available(iOS 10.0, *) {
            view.addSubview(self.navBtn)
        }
        view.isHidden = true
        return view
    }()

    lazy var localBtn:UIButton! = {
        let btn = UIButton(frame: CGRect(x: screenSize.width * 0.8, y: screenSize.height * 0.05 , width: 50, height: 50))
        btn.addTarget(self, action: #selector(userLocation), for: .touchUpInside)
        btn.backgroundColor = UIColor.clear
        btn.setImage(UIImage(named: "指針"), for: .normal)
        return btn
    }()
    lazy var navBtn:UIButton! = {
       let btn = UIButton(frame: CGRect(x: screenSize.width * 0.7 , y: 20, width: screenSize.width * 0.1, height: screenSize.width * 0.1))
        btn.setImage(UIImage(named: "carNav"), for: .normal)
        btn.addTarget(self, action: #selector(carNav), for: .touchUpInside)
        return btn
    }()
    
    lazy var mcMapView:MKMapView = {
        let map = MKMapView(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height))
        
        map.delegate = self
        map.showsUserLocation = true
        map.userTrackingMode = .follow
        return map
    }()
    
}
