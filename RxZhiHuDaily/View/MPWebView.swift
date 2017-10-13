//
//  MPWebView.swift
//  RxZhiHuDaily
//
//  Created by Maple on 2017/10/12.
//  Copyright © 2017年 Maple. All rights reserved.
//

import UIKit
import WebKit
import SnapKit
#if !RX_NO_MODULE
    import RxSwift
    import RxCocoa
#endif

/// 用于展示话题详情的webView
class MPWebView: WKWebView {
    
    let detailModel = Variable(MPStoryDetailModel())
    /// 监听tableView的滚动
    var offset: Variable<CGPoint> = Variable(CGPoint(x: 0, y: 0))
    let disposeBag = DisposeBag()
    
    init() {
        let js = "var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);"
        let wkUserScript = WKUserScript(source: js, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        let config = WKWebViewConfiguration()
        let wkUControl = WKUserContentController()
        wkUControl.addUserScript(wkUserScript)
        config.userContentController = wkUControl
        super.init(frame: CGRect.zero, configuration: config)
        setupUI()
        
        // 监听偏移量
        offset.asDriver()
            .filter { $0.y < 0 }
            .map { $0.y }
            .drive(onNext: { offsetY in
                self.topImageView.frame.origin.y = offsetY
                self.topImageView.frame.size.height = 200 - offsetY
//                self.topImageView.snp.updateConstraints({ (make) in
//                    make.top.equalToSuperview().offset(offsetY)
//                    make.height.equalTo(200 - offsetY)
//                })
            })
        .addDisposableTo(disposeBag)
        
        // 监听模型
        detailModel.asDriver()
            .drive(onNext: { model in
                self.loadHTML(model: model)
                if let urlString = model.image {
                    self.topImageView.kf.setImage(with: URL(string: urlString))
                }
                self.titleLabel.text = model.title
                if let source = model.image_source {
                    self.imgLabel.text = "图片:\(source)"
                }
            })
        .addDisposableTo(disposeBag)
    }
    
    /// 加载HTML网页
    fileprivate func loadHTML(model: MPStoryDetailModel) {
        guard let css = model.css, let body = model.body else {
            return
        }
        var html = "<html>"
        html += "<head>"
        css.forEach { html += "<link rel=\"stylesheet\" href=\($0)>" }
        html += "<style>img{max-width:320px !important;}</style>"
        html += "<body>"
        html += body
        html += "</body>"
        html += "</head>"
        html += "</html>"
        self.loadHTMLString(html, baseURL: nil)
    }
    
    fileprivate func setupUI() {
        topImageView = UIImageView()
        topImageView.contentMode = .scaleAspectFill
        topImageView.clipsToBounds = true
        maskImageView = UIImageView()
        maskImageView.image = UIImage(named: "Home_Image_Mask")
        titleLabel = UILabel()
        titleLabel.font = UIFont.boldSystemFont(ofSize: 21)
        titleLabel.numberOfLines = 2
        titleLabel.textColor = UIColor.white
        imgLabel = UILabel()
        imgLabel.font = UIFont.systemFont(ofSize: 10)
        imgLabel.textAlignment = .right
        imgLabel.textColor = UIColor.white
        
        scrollView.addSubview(topImageView)
        scrollView.addSubview(maskImageView)
        scrollView.addSubview(titleLabel)
        scrollView.addSubview(imgLabel)

//        topImageView.snp.makeConstraints { (make) in
//            make.leading.trailing.equalToSuperview()
//            make.top.equalToSuperview().offset(0)
//            make.width.equalTo(screenW)
//            make.height.equalTo(200)
//        }
//
//        maskImageView.snp.makeConstraints { (make) in
//            make.bottom.equalTo(topImageView)
//            make.leading.trailing.equalToSuperview()
//            make.height.equalTo(100)
//        }
//
//        titleLabel.snp.makeConstraints { (make) in
//            make.leading.equalToSuperview().offset(15)
//            make.trailing.equalToSuperview().offset(-15)
//            make.bottom.equalTo(topImageView).offset(-25)
//        }
//
//        imgLabel.snp.makeConstraints { (make) in
//            make.leading.equalToSuperview().offset(15)
//            make.trailing.equalToSuperview().offset(-15)
//            make.bottom.equalTo(topImageView).offset(-5)
//        }
        topImageView.frame = CGRect.init(x: 0, y: 0, width: screenW, height: 200)
        maskImageView.frame = CGRect.init(x: 0, y: 100, width: screenW, height: 100)
        titleLabel.frame =  CGRect.init(x: 15, y: 150, width: screenW - 30, height: 26)
        imgLabel.frame = CGRect.init(x: 15, y: 180, width: screenW - 30, height: 16)
    }
    
    required init?(coder: NSCoder) {
        fatalError("")
    }
    
    // MARK: - View
    fileprivate var topImageView: UIImageView!
    fileprivate var maskImageView: UIImageView!
    fileprivate var titleLabel: UILabel!
    fileprivate var imgLabel: UILabel!
}







