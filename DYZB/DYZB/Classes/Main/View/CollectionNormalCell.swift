//
//  CollectionNormalCell.swift
//  DYZB
//
//  Created by John on 2021/6/6.
//

import UIKit

class CollectionNormalCell: CollectionBaseCell {


    @IBOutlet weak var roomNameLabel: UILabel!
    //MARK:- 定义模型属性
    override var anchor : AnchorModel?{
        didSet{
            //1.将属性传递给父类
            super.anchor = anchor
            
            //2.设置房间名称
            roomNameLabel.text = anchor?.room_name
           
        }
    }

}
