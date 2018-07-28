//
//  Store.swift
//  LeisureMap
//
//  Created by stu1 on 2018/7/27.
//  Copyright © 2018年 tripim. All rights reserved.
//

import Foundation


class Store {
    // {"serviceIndex":0,"name":"Cafe00","location":{"address":"","latitude":0.0,"longitude":0.0},"index":0,"imagePath":""}
    
    var ServiceIndex : Int = 0
    var Name : String?
    var StoreLocation : LocationDesc?
    var Index : Int = 0
    var ImagePath : String?
    
}

class LocationDesc {
    /// 地址
    var Address : String?
    /// 纬度
    var Latitude : Double?
    /// 经度
    var Longitude : Double?
}
