////
////  DataRequest.swift
////  RestaurantSercher
////
////  Created by 渡邊秋斗 on 2022/03/06.
////
//
//import Foundation
//import CoreLocation
//import UIKit
//
////検索用クラス
//class DataRequest: ObservableObject {
//
//    let deligate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
//
//    func request()->String{
//        let apiKey = "c31fe861ba13d33c"
//
//        //リセット
////        self.deligate.searchName.removeAll()
////        self.deligate.searchAccess.removeAll()
////        self.deligate.searchLogo.removeAll()
////        self.deligate.searchLat.removeAll()
////        self.deligate.searchLng.removeAll()
//
//        //URL作成
//        let baseUrl = "http://webservice.recruit.co.jp/hotpepper/gourmet/v1/?"
//        let api = "&key=" + apiKey
//        let lat = "&lat=" + String(self.deligate.userLat)
//        let lng = "&lng=" + String(self.deligate.userLng)
//        let range = "&range=3"
//        let format = "&foramt=json"
//        //URLでリクエスト
//        let urlMix : String = baseUrl + api + lat + lng + range + format
//        let url = URL(string: urlMix)!
//        let request = URLRequest(url: url)
//        var lastData:String = ""
//        _ = URLSession.shared.dataTask(with: request) { (data, response, error) in  //非同期で通信を行う
//            guard let data = data else { return }
//            do {
//                let object = try JSONSerialization.jsonObject(with: data, options: [])
//                let decoder = JSONDecoder()
//                guard let dt: String = try? decoder.decode(String.self, from: object as! Data)else{
//                    fatalError("Failed to decode from JSON.")
//                }
////                print(data)
//                lastData = dt
////                return data
//            } catch {
//                lastData = "失敗"
////                return "失敗"
//            }
//        }
//        return lastData
//    }
//}
