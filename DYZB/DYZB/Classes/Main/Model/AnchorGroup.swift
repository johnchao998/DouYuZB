//
//  AnchorGroup.swift
//  DYZB
//
//  Created by John on 2021/6/20.
//

import UIKit

/**在swift3中，编译器自动推断@objc，即自动添加@objc
 在swift4中，编译器不再自动推断，你必须显式添加@objc
 自动赋值*/
@objcMembers
//MARK:-主播组模型
class AnchorGroup: NSObject {

    //该组中对应的房间信息
    var room_list : [[String : NSObject]]?{
        //属性监听器
        didSet{
            guard let room_list = room_list else { return }
            for dict in room_list {
                anchors.append(AnchorModel(dict : dict))
            }
//            for anchors in self.anchors {
//                print("主播昵称："+"\(anchors.nickname)")
//            }
        }
    }
    //组显示的标题
    var tag_name : String = ""
    //组显示的图标
    var icon_name : String = "home_header_normal"
    //定义主播的模型对象数组
    lazy var anchors : [AnchorModel] = [AnchorModel]()
    
    
    init(dict : [String : NSObject]) {
        super.init()
        
        setValuesForKeys(dict)
    }
    
    //MARK:- 构造函数
    override init(){
        
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
    
    /**方法一重写此函数：如果是room_list对象，则把它解析成主播对象模型数组
     方法二：属性监听器*/
    /*
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "room_list" {
            if let dataArray = value as? [[String : NSObject]] {
                for dict in dataArray {
                    anchors.append(AnchorModel(dict : dict))
                }
            }
        }
    }*/
}
