//
//  PageTitleView.swift
//  DYZB
//
//  Created by John on 2021/6/2.
//

import UIKit

//MARK:-定义协议
protocol PageTitleViewDelegate : AnyObject {
    func pageTitleView(titleView : PageTitleView, selectedIndex index : Int)
}

private let kScrollLineH : CGFloat = 2

//颜色元组
private let kNormalColor : (CGFloat,CGFloat,CGFloat) = (85,85,85)
private let kSelectColor : (CGFloat,CGFloat,CGFloat) = (255,128,0)
class PageTitleView: UIView {

    // MARK 定义属性
    private var currentIndex : Int = 0
    private var titles : [String]
    weak var delegate : PageTitleViewDelegate?
    
    //创建一个UILabel数组
    private lazy var titlelabes : [UILabel] = [UILabel]()
    public lazy var scrollView : UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.scrollsToTop = false
        scrollView.bounces = false
        return scrollView
    }()
    
    //滚动滑块
    private lazy var scrollLine : UIView = {
        let scrollLine = UIView()
        scrollLine.backgroundColor = UIColor.orange
        return scrollLine
    }()
    
    // MARK: 自定义构造函数
    init(frame : CGRect, titles : [String]) {
        self.titles = titles
        
        super.init(frame: frame)
        
        //设置UI界面
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//设置UI界面
extension PageTitleView {
    
    private func setupUI(){
        //1.添加UIScrollView
        addSubview(scrollView)
        scrollView.frame = bounds
        
        //2.添加title对应的label
        setupTitleLabels()
        
        //3.添加底线和滚动的滑块
        setupBottomLineAndScrollLine()
    }
    
    private func setupTitleLabels(){
        
        let labelW : CGFloat = frame.width / CGFloat(titles.count)
        let labelH : CGFloat = frame.height - CGFloat(kScrollLineH)
        let labelY : CGFloat = 0
        
        for (index, title) in titles.enumerated() {
            //1.创建 UILabel
            let label = UILabel()
            
            //2.设置label属性
            label.text = title
            label.tag = index
            label.font = UIFont.systemFont(ofSize: 16.0)
            label.textColor = UIColor(r: kNormalColor.0, g: kNormalColor.1, b: kNormalColor.2)
            label.textAlignment = .center
            
            //3.设置label的frame
            let labelX : CGFloat = labelW * CGFloat(index)
            label.frame = CGRect(x: labelX, y: labelY, width: labelW, height: labelH)
            
            //print(label.frame)
            //3.将label添加到 UIScrollView
            scrollView.addSubview(label)
            titlelabes.append(label)
            
            //4.给label添加手势
            label.isUserInteractionEnabled = true
            let tapGes = UITapGestureRecognizer(target: self, action: #selector(self.titleLabelClick(tapGes:)))
            label.addGestureRecognizer(tapGes)
        }
    }
    
    private func setupBottomLineAndScrollLine(){
        //1.添加底线
        let bottomLine = UIView()
        bottomLine.backgroundColor = UIColor.lightGray
        let lineH : CGFloat = 0.5
        bottomLine.frame = CGRect(x: 0, y: frame.height - lineH, width: frame.width, height: lineH)
        addSubview(bottomLine)
        
        //2.添加滚动滑块
        //2.1获取到第一个lable
        guard let firstlabel = titlelabes.first else{ return }
        firstlabel.textColor = UIColor(r: kSelectColor.0, g: kSelectColor.1, b: kSelectColor.2)
        scrollView.addSubview(scrollLine)
        scrollLine.frame = CGRect(x: firstlabel.frame.origin.x, y: frame.height - kScrollLineH, width: firstlabel.frame.width, height: kScrollLineH)
    }
    
}

//MARK:- 监听Label的点击
extension PageTitleView {
    @objc private func titleLabelClick(tapGes : UITapGestureRecognizer){
        //0.获取当前点击label
        guard let currentlabel = tapGes.view as? UILabel else {
            return
        }
        
        //1.如果重复点击同一个Title，那么直接返回
        if currentlabel.tag == currentIndex { return }
        
        //2.获取之前的lable
        let oldlabel = titlelabes[currentIndex]
        
        //3.切换文字的颜色
        currentlabel.textColor = UIColor(r: kSelectColor.0, g: kSelectColor.1, b: kSelectColor.2)
        oldlabel.textColor = UIColor(r: kNormalColor.0, g: kNormalColor.1, b: kNormalColor.2)
        
        //4.保存最新的Label下标值
        currentIndex = currentlabel.tag
        
        //5.滚动条位置发生改变,动画滑动
        let scrollLineX = CGFloat(currentlabel.tag) * scrollLine.frame.width
        UIView.animate(withDuration: 0.15) {
            self.scrollLine.frame.origin.x = scrollLineX
        }
        
        //6.通知代理
        delegate?.pageTitleView(titleView: self, selectedIndex: currentIndex)
        
    }
}

//Mark:-对外暴露的方法
extension PageTitleView{
    func setTitleWithProgress(progress: CGFloat, sourceIndex: Int, targetIndex: Int)  {
        //1.取出 sourceLabel & targetLabel
        let sourceLabel = titlelabes[sourceIndex]
        let targetLabel = titlelabes[targetIndex]
        
        //2.处理滑块逻辑
        let moveTotalX = targetLabel.frame.origin.x - sourceLabel.frame.origin.x
        let moveX = moveTotalX * progress
        scrollLine.frame.origin.x = sourceLabel.frame.origin.x + moveX
        
        //3.字体颜色渐变
        //3.1取出颜色变化的范围
        let colorDelta = (kSelectColor.0 - kNormalColor.0, kSelectColor.1 - kNormalColor.1,kSelectColor.2 - kNormalColor.2)
        
        //3.2变化sourceLabel颜色
        sourceLabel.textColor = UIColor(r: kSelectColor.0 - colorDelta.0 * progress, g: kSelectColor.1 - colorDelta.1 * progress, b: kSelectColor.2 - colorDelta.2 * progress)
        
        //3.3变化targetLabel颜色
        targetLabel.textColor = UIColor(r: kNormalColor.0 + colorDelta.0 * progress, g: kNormalColor.1 + colorDelta.1 * progress, b: kNormalColor.2 + colorDelta.2 * progress)
        
        //4.记录最新的Index
        currentIndex = targetIndex
        
    }
}
