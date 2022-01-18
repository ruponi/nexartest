//
//  Constants.swift
//  NexarLocationTest
//
//  Created by Ruslan Ponomarenko on 1/18/22.
//

import Foundation
struct Constants {
    static  let timeInterval:Double = 60.0
    static  let baseUrl =  "https://nexar-temp.s3.amazonaws.com/"
    static  let baseInternalFolder: URL? = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last
    
}
