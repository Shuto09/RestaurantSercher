//
//  ApiStruct.swift
//  RestaurantSercher
//
//  Created by 渡邊秋斗 on 2022/03/14.
//

import Foundation

struct result: Codable{
    var shop: [Shop]
    struct Shop: Codable{
        var searchName:[String] = []
        var searchAccess:[String] = []
        var searchLogo:[String] = []
        var searchLat:[Double] = []
        var searchLng:[Double] = []
    }
}

struct ApiStruct2: Codable{
    var retrieveName:[String] = []
    var retrieveAddress:[String] = []
    var retrieveTime:[String] = []
    var retrievePhoto:[String] = []
    var retrieveClose:[String] = []
    var retrieveUrl:[String] = []
}
