//
//  NSDate-Extension.swift
//  DYZB
//
//  Created by John on 2021/6/20.
//

import Foundation

extension NSDate{
    class func getCurrentTime() -> String{
        let nowDate = NSDate()
        
        let interval = Int(nowDate.timeIntervalSince1970)
        
        return "\(interval)"
    }
}
