//
//  ViewController.swift
//  RestaurantSercher
//
//  Created by 渡邊秋斗 on 2022/03/03.
//

import UIKit
import CoreLocation
import WebKit

class ViewController: UIViewController, CLLocationManagerDelegate{

    private var lat: Double = 0
    private var lng: Double = 0
    

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
        performSegue(withIdentifier: "toViewController2",sender: nil)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            guard let loc = locations.last else { return }
                    //国や市の情報取得
        CLGeocoder().reverseGeocodeLocation(loc, completionHandler: { [self](placemarks, error) in
                        //エラー時の処理
                        if let error = error {
                            print("reverseGeocodeLocation Failed: \(error.localizedDescription)")
                            return
                        }
                        //正常時の処理(位置情報記述)
                        
                        var locInfo = ""
                        locInfo = locInfo + "Latitude: \(loc.coordinate.latitude)\n"
                        locInfo = locInfo + "Longitude: \(loc.coordinate.longitude)"
                        self.lat = loc.coordinate.latitude
                        self.lng = loc.coordinate.longitude
                        self.locationInfoLabel.text = locInfo

                    })
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
            //エラー内容記述
            print("error(0): \(error.localizedDescription)")
    }
    //ViewController2に送る位置情報を準備
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if (segue.identifier == "toViewController2") {
                let vc2: ViewController2 = (segue.destination as? ViewController2)!
                // 位置情報をセット
                vc2.lat = self.lat
                vc2.lng = self.lng
            }
        }
    
}
