//
//  MainViewController.swift
//  DYZB
//
//  Created by John on 2021/6/1.
//

import UIKit

class MainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        /**通过 storyboard添加控制器*/
        addChildVC(storyName:"Home")
        addChildVC(storyName:"Live")
        addChildVC(storyName:"Follow")
        addChildVC(storyName:"Profile")
    }
    
    private func addChildVC(storyName:String){
        //1. 通过storyboard获取控制器
        guard let childVC = UIStoryboard(name: storyName, bundle: nil).instantiateInitialViewController() else { return }
        
        //2.将childVC作为子控制器
        addChild(childVC)
    }

}
