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
        
        self.navigationDelegate = self
        
        // 监听偏移量
        offset.asDriver()
            .filter { $0.y < 0 }
            .map { $0.y }
            .drive(onNext: { offsetY in
                self.topImageView.frame.origin.y = offsetY
                self.topImageView.frame.size.height = 200 - offsetY
            })
        .addDisposableTo(disposeBag)
        
        // 监听模型
        detailModel.asDriver()
            .drive(onNext: { model in
                self.loadHTML(model: model)
                if let urlString = model.image {
                    self.topImageView.kf.setImage(with: URL(string: urlString))
                    self.topImageView.isHidden = false
                    self.preLabel.textColor = UIColor.white
                    self.titleLabel.isHidden = false
                    self.maskImageView.isHidden = false
                }else {
                    // 没有图片
                    self.topImageView.isHidden = true
                    self.preLabel.textColor = UIColor.black
                    self.titleLabel.isHidden = true
                    self.maskImageView.isHidden = true
                }
                self.titleLabel.text = model.title
                if let title = model.title {
                    let size = CGSize(width: screenW - 30, height: CGFloat(MAXFLOAT))
                    let textH = (title as NSString).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: self.titleLabel.font], context: nil).height
                    if textH > 25 {
                        self.titleLabel.frame.origin.y = 120
                        self.titleLabel.frame.size.height = 55
                    }else {
                        self.titleLabel.frame.origin.y = 150
                        self.titleLabel.frame.size.height = 26
                    }
                }
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
        preLabel = UILabel()
        preLabel.textAlignment = .center
        preLabel.text = "载入上一篇"
        preLabel.textColor = UIColor.white
        nextLabel = UILabel()
        nextLabel.textAlignment = .center
        nextLabel.text = "载入下一篇"
        nextLabel.textColor = UIColor.black
        
        loadingView = UIView()
        loadingView.backgroundColor = UIColor.white
        loadingView.frame = CGRect.init(x: 0, y: 0, width: screenW, height: screenH)
        indicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        indicatorView.center = loadingView.center
        loadingView.addSubview(indicatorView)
        
        scrollView.addSubview(topImageView)
        scrollView.addSubview(maskImageView)
        scrollView.addSubview(titleLabel)
        scrollView.addSubview(imgLabel)
        scrollView.addSubview(preLabel)
        scrollView.addSubview(nextLabel)
        scrollView.addSubview(loadingView)
        
        topImageView.frame = CGRect.init(x: 0, y: 0, width: screenW, height: 200)
        maskImageView.frame = CGRect.init(x: 0, y: 100, width: screenW, height: 100)
        titleLabel.frame =  CGRect.init(x: 15, y: 150, width: screenW - 30, height: 26)
        imgLabel.frame = CGRect.init(x: 15, y: 180, width: screenW - 30, height: 16)
        preLabel.frame = CGRect.init(x: 15, y: -30, width: screenW - 30, height: 20)
        nextLabel.frame = CGRect.init(x: 15, y: screenH + 30, width: screenW - 30, height: 20)
    }
    
    required init?(coder: NSCoder) {
        fatalError("")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        indicatorView.center = self.center
    }
    
    // MARK: - View
    fileprivate var topImageView: UIImageView!
    fileprivate var maskImageView: UIImageView!
    fileprivate var titleLabel: UILabel!
    fileprivate var imgLabel: UILabel!
    var preLabel: UILabel!
    var nextLabel: UILabel!
    fileprivate var indicatorView: UIActivityIndicatorView!
    fileprivate var loadingView: UIView!
}

extension MPWebView {
    func startLoading() {
        indicatorView.startAnimating()
        loadingView.isHidden = false
    }
    
    func endLoading() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
            self.indicatorView.stopAnimating()
            self.loadingView.isHidden = true
        }
    }
}

extension MPWebView: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        startLoading()
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        endLoading()
        webView.evaluateJavaScript("document.body.scrollHeight") { (result, error) in
            if let height = result as? CGFloat {
                self.nextLabel.frame.origin.y = height + 50
            }
        }
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        endLoading()
    }
}







