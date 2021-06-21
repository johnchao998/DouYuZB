//
//  CollectionHeaderViewEx.swift
//  DYZB
//
//  Created by John on 2021/6/21.
//

import UIKit

class CollectionHeaderViewEx: UICollectionReusableView {

    //MARK:-控件属性
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var iconImageView: UIImageView!
    
    //MARK:-定义模型属性
    var group : AnchorGroup?{
        didSet{
            
            titleLabel.text = group?.tag_name
            //可选链没有值，默认给一下图片
            iconImageView.image = UIImage(named: group?.icon_name ?? "home_header_normal")
        }
    }
    
}
