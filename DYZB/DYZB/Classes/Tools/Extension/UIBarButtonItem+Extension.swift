//
//  UIBarButtonItem+Extension.swift
//  DYZB
//
//  Created by John on 2021/6/2.
//

import UIKit

extension UIBarButtonItem{
    
    /*方法一： 类函数方法
    class func createItem(imageName : String, highImageName : String, size : CGSize) -> UIBarButtonItem {
        let btn = UIButton()
        
        btn.setImage(UIImage(named: imageName), forState: .Normal)
        btn.setImage(UIImage(named: highImageName), forState: .Highlighted)
        
        btn.frame = CGRect(origin: CGPointZero, size: size)
        
        return UIBarButtonItem(customView: btn)
    }
    */
    
    //方法二：【推荐使用】便利构造函数： 1.convenience开头  2.在构造函数中必须声明调用一个self的构造函数
    convenience init(imageName : String, highImageName : String = "", size : CGSize = .zero){
        
        //1.创建UIButton
        let btn = UIButton()
        
        //2.设置UIButton图片
        btn.setImage(UIImage(named: imageName), for: UIControl.State.normal)
        if highImageName != "" {
            btn.setImage(UIImage(named: highImageName), for: UIControl.State.highlighted)
        }
        
        //3.设置UIButton大小
        if size == .zero {
            btn.sizeToFit()
        } else {
            btn.frame = CGRect(origin: .zero, size: size)
        }
        
        //4.创建UIBarButtonItem
        self.init(customView : btn)
    }
}
