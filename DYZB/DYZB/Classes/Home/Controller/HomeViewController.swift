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
    private lazy var pageTitleView : PageTitleView = {[weak self] in
        let titleFrame = CGRect(x: 0, y: kStatusBarH + kNavigationBarH, width: kScreenW, height: kTitleViewH)
        let titles = ["推荐","游戏","娱乐","趣玩"]
        let titleView = PageTitleView(frame: titleFrame, titles: titles)
        titleView.delegate = self
        return titleView
    }()
    
    private lazy var pageContenView : PageContentView = {[weak self] in
        //确定内容的frame
        let contentH = kScreenH - kStatusBarH - kNavigationBarH - kTitleViewH - kTabBarH
        let contenFrame = CGRect(x: 0, y: kStatusBarH + kNavigationBarH + kTitleViewH, width: kScreenW, height: contentH)
        
        //确定所有的子控制器
        var childVcs = [UIViewController]()  //控制器数组
        var recomendVC = RecomendViewController()
        childVcs.append(recomendVC)
        for _ in 0..<3 {
            let vc = UIViewController()
            vc.view.backgroundColor = UIColor(r: CGFloat(arc4random_uniform(255)),g:CGFloat(arc4random_uniform(255)),b:CGFloat(arc4random_uniform(255)))
            childVcs.append(vc)
        }
        
        let contenView = PageContentView(frame: contenFrame, childVcs: childVcs, parentViewController: self)
        contenView.delegate = self
        return contenView
        
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
        
        //3.添加ContenView
        view.addSubview(pageContenView)
        pageContenView.backgroundColor = UIColor.purple
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

//MARK:- 遵守PageTitleViewDelegate协议
extension HomeViewController : PageTitleViewDelegate{
    //1.当TitleLabel点击时，相应的pageContenView也跟着联动
    func pageTitleView(titleView: PageTitleView, selectedIndex index: Int) {
        pageContenView.setCurrentIndex(currentIndex: index)
    }
}

//MAR:- 遵守PageContenViewDelegate协议
extension HomeViewController : PageContentViewDelegate{
    //1.当滑动pageContentView是，TitleLabel也跟着联动
    func pageContentView(contentView: PageContentView, progress: CGFloat, sourceIndex: Int, targetIndex: Int){
        pageTitleView.setTitleWithProgress(progress: progress, sourceIndex: sourceIndex, targetIndex: targetIndex)
    }
}
