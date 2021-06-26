//
//  RecomendCycleView.swift
//  DYZB
//
//  Created by John on 2021/6/26.
//

import UIKit

private let kCycleCellID = "kCycleCellID"
class RecomendCycleView: UIView {

    //定时器
    var cycleTimer : Timer?
    //MARK：-控件属性 数组
    var cycleModels : [CycleModel]?{
        didSet {
            //1.刷新collectionView
            collectionView.reloadData()
            
            //2.设置pageControl个数
            pageControl.numberOfPages = cycleModels?.count ?? 0
            
            //3.默认滚动到中间某一个位置
            let indexPath = NSIndexPath(row: (cycleModels?.count ?? 0) * 10, section: 0)
            collectionView.scrollToItem(at: indexPath as IndexPath, at: .left, animated: false)
            
            //4添加定时器
            removeCycleTimer()
            addCycleTimer()
        }
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    //MARK:-系统回调函数
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //设置该控件不随着父控件的拉伸而拉伸  .None
        autoresizingMask = []
        
        //注册cell
//        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: kCycleCellID)
        collectionView.register(UINib(nibName: "RecomendCycleCell", bundle: nil), forCellWithReuseIdentifier: kCycleCellID)
        
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        //设置collectionView的layout
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = collectionView.bounds.size
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        //设置水平滚动
        layout.scrollDirection = .horizontal
        collectionView.isPagingEnabled = true
        
    }
}

//MARK:-提供一个快速创建View的类方法
extension RecomendCycleView {
    class func recommendCycleView() -> RecomendCycleView {
        return Bundle.main.loadNibNamed("RecomendCycleView", owner: nil, options: nil)?.first as! RecomendCycleView
    }
}

//MARK:-遵守UICollectionView的数据源协议
extension RecomendCycleView : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //循环滚动
        return ( cycleModels?.count ?? 0 ) * 10000
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kCycleCellID, for: indexPath) as! RecomendCycleCell
        
        cell.cycleModel = cycleModels![indexPath.item % cycleModels!.count]
        
        return cell
    }

}

//MARK:-遵守UICollectionView的代理协议
extension RecomendCycleView : UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //1.获取滚动的偏移量,滚动到一半就滚过去
        let offsetX = scrollView.contentOffset.x + scrollView.bounds.width * 0.5
        
        //2.计算pageControl的currentIndex
        pageControl.currentPage = Int(offsetX / scrollView.bounds.width) % (cycleModels?.count ?? 1)
    }
    
    //拖动时，取消定时器
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        removeCycleTimer()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        addCycleTimer()
    }
}


//MARK:-对定时器的操作方法
extension RecomendCycleView {
    private func addCycleTimer() {
        cycleTimer  = Timer(timeInterval: 3.0, target: self, selector: #selector(self.scrollToNext), userInfo: nil, repeats: true)
        RunLoop.main.add(cycleTimer!, forMode: RunLoop.Mode.common)
    }
    
    private func removeCycleTimer() {
        cycleTimer?.invalidate() //从运行循环中移除
        cycleTimer = nil
    }
    
    @objc private func scrollToNext() {
        //1.获取滚动的偏移量
        let currentOffsetX = collectionView.contentOffset.x
        let offsetX = currentOffsetX + collectionView.bounds.width
        
        //2.滚动到位置
        collectionView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
        
    }
}
