//
//  CollectionPrettyCell.swift
//  DYZB
//
//  Created by John on 2021/6/15.
//

import UIKit
import Kingfisher
class CollectionPrettyCell: CollectionBaseCell {
    
    @IBOutlet weak var cityBtn: UIButton!
    //MARK:- 定义模型属性
    override var anchor : AnchorModel?{
        didSet{
            //1.将属性传递给父类
            super.anchor = anchor
            //2.所在城市
            cityBtn.setTitle(anchor?.anchor_city, for: .normal)
           
        }
    }
}
