//
//  RecomendViewController.swift
//  DYZB
//
//  Created by John on 2021/6/6.
//

import UIKit

private let kItemMargin : CGFloat = 10    //item间距
private let kItemW : CGFloat = (kScreenW - 3 * kItemMargin) / 2
private let kNormalItemH : CGFloat = kItemW * 3 / 4   //普通Cell高度
private let kPrettyItemH : CGFloat = kItemW * 4 / 3   //普通Cell高度
private let kNormalCellID = "kNormalCellID"  //自定义普通NormalCell
private let kPrettyCellID = "kPrettyCellID"  //自定义颜值NormalCell
private let kHeaderViewID = "kHeaderViewID"  //自定义SectionHeaderView
private let kHeaderViewH : CGFloat = 50
private let kCycleViewH : CGFloat = kScreenW * 3 / 8
class RecomendViewController: UIViewController {
    //MARK:-懒加载属性
    /**MVVM设计模式，创建ViewModel负责网络请求数据*/
    private lazy var recommendVM : RecommendViewModel = RecommendViewModel()
    private lazy var collectionView : UICollectionView = {[unowned self] in
        //1.创建布局
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: kItemW, height: kNormalItemH)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = kItemMargin //item间距
        layout.sectionInset = UIEdgeInsets(top: 0, left: kItemMargin, bottom: 0, right: kItemMargin)
        //设置组头
        layout.headerReferenceSize = CGSize(width: kScreenW, height: kHeaderViewH)
        
        //2.创建UICollectionView
        let collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.white
        collectionView.dataSource = self
        collectionView.delegate = self
        //设置collecionView随父控制拉伸
        collectionView.autoresizingMask = [.flexibleHeight,.flexibleHeight]
        
        
            /*普通注册cell方法**/
//            collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: kNormalCellID)

        /**自定义通用cell注册方法 NormalCell从xib资源加载*/
        collectionView.register(UINib(nibName: "CollectionNormalCell", bundle: nil), forCellWithReuseIdentifier: kNormalCellID)
        /**自定义颜值cell注册方法 NormalCell从xib资源加载*/
        collectionView.register(UINib(nibName: "CollectionPrettyCell", bundle: nil), forCellWithReuseIdentifier: kPrettyCellID)
        /*
            //注册每一组 HeaderView  普通注册方法
            collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: kHeaderViewID)
            */
        
        /*自定义HeaderView，从xib资源加载*/
        collectionView.register(UINib(nibName: "CollectionHeaderViewEx", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: kHeaderViewID)
        
       
        return collectionView
    }()
    
    //MARK:-创建轮播图控件
    private lazy var cycleView : RecomendCycleView = {
        let cycleView = RecomendCycleView.recommendCycleView()
        cycleView.frame = CGRect(x: 0, y: -kCycleViewH, width: kScreenW, height: kCycleViewH)
        return cycleView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 设置UI
        setupUI()
        
        //网络请求
        loadData()
    }

}

//MARK:-设置UI
extension RecomendViewController{
    private func setupUI(){
        //1.将UICollectionView添加到控制器中
        view.addSubview(collectionView)
        
        //2.将CycleView添加到UICollectionView中一起滚动
        collectionView.addSubview(cycleView)
        
        //3.设置collectionView的内边距,把cycleView显示出来
        collectionView.contentInset = UIEdgeInsets(top: kCycleViewH, left: 0, bottom: 0, right: 0)
    }
}

//MARK:请求数据
extension RecomendViewController{
    private func loadData(){
        //1.请求推荐数据
        recommendVM.requestData {
            //请求到数据后，重新加载数据
            self.collectionView.reloadData()
        }
        
        //2.请求轮播数据,这里self 不会产生循环使用的问题 或者 使用【weak self】
        recommendVM.requestCycleData {
            print("请求轮播数据完成")
            self.cycleView.cycleModels = self.recommendVM.cycleModels
        }
    }
}

//MARK:-遵守UICollectionViewDataSource协议
extension RecomendViewController : UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return recommendVM.anchorGroups.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        if section == 0 {//section=0返回 8 个cell
//            return 8
//        }
//        return 4
        let group = recommendVM.anchorGroups[section]
        return group.anchors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //0.取出模型对象
        let group = recommendVM.anchorGroups[indexPath.section]
        let anchor = group.anchors[indexPath.item]
       
        //1.定义cell
        var cell : CollectionBaseCell!
        //2.取出Cell
        if indexPath.section == 1 {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: kPrettyCellID, for: indexPath) as! CollectionPrettyCell
        }else{
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: kNormalCellID, for: indexPath) as! CollectionNormalCell
        }
        
        //3.将模型赋值给cell
        cell.anchor = anchor
        return cell
    
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        //1.获取section的HeaderView  转成自定义 CollectionHeaderViewEx
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: kHeaderViewID, for: indexPath) as! CollectionHeaderViewEx
        
        //2.取出模型
        headerView.group = recommendVM.anchorGroups[indexPath.section]
        
        return headerView
    }
    
    //实现UICollectionViewDelegateFlowLayout 代理方法，根据不同的sectionItem，返回不同的高度
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        
        if indexPath.section == 1 {
            return CGSize(width: kItemW, height: kPrettyItemH)
        }else {
            return CGSize(width: kItemW, height: kNormalItemH)
        }
    }

    
}
