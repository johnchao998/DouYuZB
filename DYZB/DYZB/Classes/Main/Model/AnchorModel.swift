//
//  AnchorModel.swift
//  DYZB
//
//  Created by John on 2021/6/20.
//

import UIKit

/**主播模型*/
/**在swift3中，编译器自动推断@objc，即自动添加@objc
 在swift4中，编译器不再自动推断，你必须显式添加@objc*/
@objcMembers
class AnchorModel: NSObject {
    //JSON字段名与对象名称一致实现自动赋值
    //房间ID
    var room_id : Int = 0
    //房间图片对应的URL
    var vertical_src : String = ""
    //判断是手机还是电脑直播 0:手机 1：电脑
    var isVertical : Int = 0
    //房间名称
    var room_name : String = ""
    //主播昵称
    var nickname : String = ""
    //观看人数
    var online : Int = 0
    //城市
    var anchor_city : String = ""
    
    init(dict : [String : NSObject]){
        super.init()
        
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
}
