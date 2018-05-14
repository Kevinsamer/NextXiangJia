//
//  PageTitleView.swift
//  NextXiangJia
//
//  Created by DEV2018 on 2018/2/26.
//  Copyright © 2018年 DEV2018. All rights reserved.
//

import UIKit
private let finalScrollineH : CGFloat = 2
class PageTitleView: UIView {
    private var titles: [String]
    private lazy var titleLabels: [UILabel] = [UILabel]()
    private lazy var scrollerView: UIScrollView = {
        let scrollerView = UIScrollView()
        scrollerView.scrollsToTop = false
        scrollerView.showsHorizontalScrollIndicator = false
        scrollerView.bounces = false
        scrollerView.contentInsetAdjustmentBehavior = .never//设置无内边距
        return scrollerView
    }()
    
    private lazy var scrollLine:UIView = {
        let scrollLine = UIView()
        scrollLine.backgroundColor = UIColor.orange
        return scrollLine
    }()
    init(frame: CGRect, titles: [String]) {
        self.titles = titles
        
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - 设置ui
extension PageTitleView{
    private func setupUI(){
        addSubview(scrollerView)
        scrollerView.frame = bounds
        //添加title对应的label
        setupTitleLabel()
        //设置底线和滚动的滑块
        setupBottomLineAndScrollLine()
    }
    
    private func setupBottomLineAndScrollLine(){
        //1.底线
        let bottomLine = UIView()
        bottomLine.backgroundColor = UIColor.init(named: "light_gray")
        let bottomLineH : CGFloat = 0.5
        bottomLine.frame = CGRect(x: 0, y: self.frame.height - bottomLineH, width: frame.width, height: bottomLineH)
        self.addSubview(bottomLine)
        //2.滚动线
        guard let firstLabel = titleLabels.first else { return }
        scrollerView.addSubview(scrollLine)
        scrollLine.frame = CGRect(x: firstLabel.frame.origin.x, y: frame.height - finalScrollineH, width: firstLabel.frame.width, height: finalScrollineH)
    }
    
    private func setupTitleLabel(){
        //先确定lebel的frame的一些固定值   提高效率
        let labelW : CGFloat = bounds.width / CGFloat(titles.count)
        let labelH : CGFloat = frame.height - finalScrollineH
        let labelY : CGFloat = 0
        for (index,title) in titles.enumerated(){
            //创建label
            let label = UILabel()
            //设置label属性
            label.font = UIFont.systemFont(ofSize: 16.0)
            label.text = title
            label.tag = index
            label.textColor = UIColor.darkGray
            label.highlightedTextColor = UIColor.init(named: "global_orange")
            label.textAlignment = .center
            //设置label的frame
            let labelX : CGFloat = labelW * CGFloat(index)
            
            label.frame = CGRect(x: labelX, y: labelY, width: labelW, height: labelH)
            scrollerView.addSubview(label)
            titleLabels.append(label)
        }
    }
}
