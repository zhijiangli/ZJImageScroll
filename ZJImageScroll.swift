//
//  ZJImageScroll.swift
//  ZHSRTM
//
//  Created by 小黎 on 2017/11/11.
//  Copyright © 2017年 小黎. All rights reserved.
//

import UIKit
/**
 *  图片循环滚动
 */
class ZJImageScroll: UIScrollView ,UIScrollViewDelegate{
    private var scroll_imageViewCount = 3
    private var scroll_imgviews = Array<UIImageView>()
    private var scroll_nowIndexpage = 0
    private var scroll_timer : Timer!
    // 外界传入
    private var scroll_scrolltime = 3
    private var scroll_isAutoScroll = true
    private var newScroll_imageStrs = [String]();
    var scroll_imageStrs : [String] {
        get{
            return self.newScroll_imageStrs
        }
        set{
           self.newScroll_imageStrs = newValue
            self.updateScrollContent()
            if self.scroll_isAutoScroll == true {
                self.startScrollTimer()
            }
        }
    }
    
    init(frame: CGRect,_ imageStrs:Array<String>,_ time:TimeInterval?,_ isAutoScroll:Bool?) {
        super.init(frame: frame)
        // 设置属性
        self.backgroundColor = UIColor.clear;
        self.showsHorizontalScrollIndicator = false;
        self.showsVerticalScrollIndicator = false;
        self.isPagingEnabled = true;
        self.bounces = false;
        self.delegate = self;
        // 记录外界传入数值
        //self.scroll_imageStrs = imageStrs
        if time != nil {
            self.scroll_scrolltime = Int(time!)
        }
        if isAutoScroll != nil {
            self.scroll_isAutoScroll = isAutoScroll!
        }
        //
        self.setSubviews()
        //
        if self.scroll_imageStrs.count>1 {
            self.updateScrollContent()
        }
        if self.scroll_imageStrs.count>1 && self.scroll_isAutoScroll == true {
            self.startScrollTimer()
        }
    }

    /** 添加视图*/
    private func setSubviews() {
        let scroll_width = self.frame.size.width
        let scroll_height = self.frame.size.height
        for index in 0..<self.scroll_imageViewCount {
            let scroll_imgview = UIImageView(frame: CGRect(x: scroll_width*CGFloat(index), y: 0, width: scroll_width, height: scroll_height))
            self.addSubview(scroll_imgview)
            self.scroll_imgviews.append(scroll_imgview)
        }
        self.contentSize = CGSize(width: CGFloat(self.scroll_imageViewCount)*scroll_width, height: 0)
    }
    /** 处理代理方法*/
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // 找出最中间的那个图片控件
        var pageIndex:Int = 0
        var minDistance = MAXFLOAT
        for index in 0..<self.scroll_imgviews.count {
            let scroll_imgview = self.scroll_imgviews[index]
            var distance:Float = 0
            distance = Float(abs(scroll_imgview.frame.origin.x - self.contentOffset.x))
            if distance - minDistance < 0 {
                minDistance = distance
                pageIndex = Int(scroll_imgview.tag)
            }
        }
        self.scroll_nowIndexpage = Int(pageIndex);
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        if self.scroll_isAutoScroll == true && self.scroll_imageStrs.count>1 {
            
            self.startScrollTimer()
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if self.scroll_isAutoScroll == true && self.scroll_imageStrs.count>1 {
            
            self.startScrollTimer()
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
       self.updateScrollContent()
    }
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        self.updateScrollContent()
    }
    
    /** 更新内容*/
    private func updateScrollContent() {
    
        if self.scroll_imageStrs.count<1{
            return
        }
            
        for index in 0..<self.scroll_imageViewCount {
            var pageIndex = self.scroll_nowIndexpage
            if index == 0 {
                pageIndex -= 1
            }else if index == 2 {
                pageIndex += 1
            }
            if pageIndex < 0 {
                pageIndex = self.scroll_imageStrs.count - 1
            }else if pageIndex >= self.scroll_imageStrs.count{
                pageIndex = 0
            }
            let scroll_imgview = self.scroll_imgviews[index]
            scroll_imgview.tag = pageIndex
            //
            let scroll_image = UIImage(named: self.scroll_imageStrs[pageIndex])
            scroll_imgview.image = scroll_image
        }
        self.setContentOffset(CGPoint(x:self.frame.size.width , y: 0), animated: false)
    }
    /** 开启定时器*/
    private func startScrollTimer() {
        if self.scroll_timer == nil {
            
            self.scroll_timer = Timer.scheduledTimer(timeInterval: TimeInterval(self.scroll_scrolltime), target: self, selector: #selector(timerRuning), userInfo: nil, repeats: true)
        }
    }
    /** 定时器跑起来*/
    @objc func timerRuning() {
        self.setContentOffset(CGPoint(x:self.frame.size.width*2 , y: 0), animated: true)
    }
    
    /** 关闭定时器 (方便外界调用)*/
    func stopScrollTimer() {
        guard let timer1 = self.scroll_timer
            else{ return }
        timer1.invalidate()
        self.scroll_timer.invalidate();
        self.scroll_timer = nil;
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
