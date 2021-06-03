//
//  PageTitleView.swift
//  DYZB
//
//  Created by John on 2021/6/2.
//

import UIKit

private let kScrollLineH : CGFloat = 2
class PageTitleView: UIView {

    // MARK 定义属性
    private var titles : [String]
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
            label.textColor = UIColor.darkGray
            label.textAlignment = .center
            
            //3.设置label的frame
            let labelX : CGFloat = labelW * CGFloat(index)
            label.frame = CGRect(x: labelX, y: labelY, width: labelW, height: labelH)
            
            print(label.frame)
            //3.将label添加到 UIScrollView
            scrollView.addSubview(label)
            titlelabes.append(label)
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
        firstlabel.textColor = UIColor.orange
        scrollView.addSubview(scrollLine)
        scrollLine.frame = CGRect(x: firstlabel.frame.origin.x, y: frame.height - kScrollLineH, width: firstlabel.frame.width, height: kScrollLineH)
    }
    
}
