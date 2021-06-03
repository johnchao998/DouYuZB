//
//  HomeViewController.swift
//  DYZB
//
//  Created by John on 2021/6/2.
//

import UIKit

private let kTitleViewH : CGFloat = 40

class HomeViewController: UIViewController {

    //Mark 懒加载属性
    
    private lazy var pageTitleView : PageTitleView = {
        let titleFrame = CGRect(x: 0, y: kStatusBarH + kNavigationBarH, width: kScreenW, height: kTitleViewH)
        let titles = ["推荐","游戏","娱乐","趣玩"]
        let titleView = PageTitleView(frame: titleFrame, titles: titles)
        
        return titleView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupUI()
    }

}

extension HomeViewController{
    private func setupUI(){
        
        //0.不需要调整UIScrollView内边距,为是显示titles
        if #available(iOS 11.0, *) {
            pageTitleView.scrollView.contentInsetAdjustmentBehavior = .never
        }else {
            automaticallyAdjustsScrollViewInsets = false
        }
        
        //1.设置导航栏
        setupNavigationBar()
        
        //2.添加TitleView
        view.addSubview(pageTitleView)
        
        
    }
    
    private func setupNavigationBar(){
        //1.设置导航左边图片
        navigationItem.leftBarButtonItem = UIBarButtonItem(imageName: "logo")
        
        //2.设置右侧的Item
        let size = CGSize(width: 40, height: 40)
        let historyItem = UIBarButtonItem(imageName: "image_my_history", highImageName: "Image_my_history_click", size: size)
        
        let searchItem = UIBarButtonItem(imageName: "btn_search", highImageName: "btn_search_clicked", size: size)
        
        let qrcodeItem = UIBarButtonItem(imageName: "Image_scan", highImageName: "Image_scan_click", size: size)
        
        navigationItem.rightBarButtonItems = [historyItem,searchItem,qrcodeItem]
        
    }
}
