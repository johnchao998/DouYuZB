//
//  CycleModel.swift
//  DYZB
//
//  Created by John on 2021/6/26.
//

import UIKit

/**在swift3中，编译器自动推断@objc，即自动添加@objc
 在swift4中，编译器不再自动推断，你必须显式添加@objc*/
@objcMembers
class CycleModel: NSObject {
    //标题
    var title : String = ""
    //展示的图片地址
    var pic_url : String = ""
    //主播信息对应的字典
    var room : [String : NSObject]?{
        didSet {
            guard let room = room else { return }
            anchor = AnchorModel(dict: room)
        }
    }
    //主播信息对应的模型对象
    var anchor : AnchorModel?
    
    //MARK: -自定义构造函数
    init(dict : [String : NSObject]) {
        super.init()
        
        setValuesForKeys(dict)
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
}
