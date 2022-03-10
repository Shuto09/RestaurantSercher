//
//  ViewController.swift
//  RestaurantSercher
//
//  Created by 渡邊秋斗 on 2022/03/03.
//

import UIKit
import CoreLocation
import WebKit

class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var locationInfoLabel: UILabel!
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        locationManager.delegate = self
        //位置情報の精度を高いものにする
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        //アプリ使用中の許可申請
        locationManager.requestWhenInUseAuthorization()
    }
    
    @IBAction func getCurrentLocationTapped(_ sender: Any) {
        //ボタンタップ時「のみ」の位置情報取得
        locationManager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            guard let loc = locations.last else { return }
                    //国や市の情報取得
                    CLGeocoder().reverseGeocodeLocation(loc, completionHandler: {(placemarks, error) in
                        //エラー時の処理
                        if let error = error {
                            print("reverseGeocodeLocation Failed: \(error.localizedDescription)")
                            return
                        }
                        //正常時の処理(位置情報記述)
                        if let placemark = placemarks?[0] {
                        
                            var locInfo = ""
                            locInfo = locInfo + "Latitude: \(loc.coordinate.latitude)\n"
                            locInfo = locInfo + "Longitude: \(loc.coordinate.longitude)\n\n"
                            
                            locInfo = locInfo + "Country: \(placemark.country ?? "")\n"
                            locInfo = locInfo + "State/Province: \(placemark.administrativeArea ?? "")\n"
                            locInfo = locInfo + "City: \(placemark.locality ?? "")\n"
                            locInfo = locInfo + "PostalCode: \(placemark.postalCode ?? "")\n"
                            locInfo = locInfo + "Name: \(placemark.name ?? "")"
                            
                            self.locationInfoLabel.text = locInfo
                        }
                    })
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
            //エラー内容記述
            print("error: \(error.localizedDescription)")
    }

}

