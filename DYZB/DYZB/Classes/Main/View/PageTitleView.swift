//
//  PageTitleView.swift
//  DYZB
//
//  Created by John on 2021/6/2.
//

import UIKit

class PageTitleView: UIView {

    // MARK 定义属性
    private var titles : [String]
    
    // MARK: 自定义构造函数
    init(frame : CGRect, titles : [String]) {
        self.titles = titles
        
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
