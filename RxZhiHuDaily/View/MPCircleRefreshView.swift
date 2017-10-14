//
//  MPCircleRefreshView.swift
//  RxZhiHuDaily
//
//  Created by Maple on 2017/10/14.
//  Copyright © 2017年 Maple. All rights reserved.
//

import UIKit
#if !RX_NO_MODULE
    import RxSwift
    import RxCocoa
#endif

/// 下拉刷新圆圈View
class MPCircleRefreshView: UIView {
    fileprivate let circleLayer = CAShapeLayer()
    fileprivate let indicatorView = UIActivityIndicatorView()
    fileprivate let disposeBag = DisposeBag()
    fileprivate var isRefreshing: Bool = false
    
    init() {
        super.init(frame: CGRect.zero)
        addSubview(indicatorView)
        layer.addSublayer(circleLayer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        indicatorView.center = CGPoint(x: frame.width/2, y: frame.height/2)
        setupLayer()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("")
    }
    
    fileprivate func setupLayer() {
        circleLayer.path = UIBezierPath(arcCenter: CGPoint(x: 8, y: 8), radius: 8, startAngle: CGFloat(Double.pi * 0.5), endAngle: CGFloat(Double.pi * 0.5 + 2 * Double.pi), clockwise: true).cgPath
        circleLayer.strokeColor = UIColor.white.cgColor
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.strokeStart = 0.0
        circleLayer.strokeEnd = 0.0
        circleLayer.lineWidth = 1.0
        circleLayer.lineCap = kCALineCapRound
        let xy = (frame.width - 16) * 0.5
        circleLayer.frame = CGRect(x: xy, y: xy, width: 16, height: 16)
    }
}

extension MPCircleRefreshView {
    /// 设置圆圈的绘制百分比
    func pullToRefresh(progress: CGFloat) {
        circleLayer.isHidden = progress == 0
        circleLayer.strokeEnd = progress
    }
    
    /// 开始刷新
    func beginRefresh(begin: @escaping () -> Void) {
        if isRefreshing {
            //防止刷新未结束又开始请求刷新
            return
        }
        circleLayer.removeFromSuperlayer()
        circleLayer.strokeEnd = 0
        indicatorView.startAnimating()
        begin()
    }
    
    /// 结束刷新
    func endRefresh() {
        layer.addSublayer(circleLayer)
        setupLayer()
        isRefreshing = false
        indicatorView.stopAnimating()
    }
}
