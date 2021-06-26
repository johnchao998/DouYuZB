//
//  RecomendCycleCell.swift
//  DYZB
//
//  Created by John on 2021/6/26.
//

import UIKit

class RecomendCycleCell: UICollectionViewCell {
    //MARK:- 控件属性
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    //MARK:-定义模型属性
    var cycleModel : CycleModel?{
        didSet {
            //1.设置标题
            titleLabel.text = cycleModel?.title
            //print("轮播title:"+"\(cycleModel?.title)")
            //2.设置封面图片
            let iconUrl = URL(string: cycleModel?.pic_url ?? "")!
            iconImageView.kf.setImage(with: iconUrl, placeholder: UIImage(named: "Img_default"), options: nil, progressBlock: nil, completionHandler: nil)
        }
    }

}
