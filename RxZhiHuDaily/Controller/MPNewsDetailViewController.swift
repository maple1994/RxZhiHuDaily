//
//  MPNewsDetailViewController.swift
//  RxZhiHuDaily
//
//  Created by Maple on 2017/10/11.
//  Copyright © 2017年 Maple. All rights reserved.
//

import UIKit
import WebKit
#if !RX_NO_MODULE
    import RxSwift
    import RxCocoa
#endif

/// 话题详情控制器
class MPNewsDetailViewController: UIViewController {

    fileprivate var id: Int {
        get {
            return idArr[index]
        }
    }
    fileprivate let disposeBag = DisposeBag()
    fileprivate var index: Int
    fileprivate var idArr: [Int]
    
    /// 创建话题详情控制器
    ///
    /// - Parameters:
    ///   - idArr: 话题id数组
    ///   - index: 当前展示的话题索引
    init(idArr: [Int], index: Int) {
        self.idArr = idArr
        self.index = index
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("")
    }
    
    fileprivate func didSetIndex(_ tmpIndex: Int) {
        index = tmpIndex
        if index == 0 {
            webView.preLabel.text = "已经是第一篇了"
        }else if index == idArr.count - 1 {
            webView.nextLabel.text = "已经是最后一篇了"
        }else {
            webView.preLabel.text = "载入上一篇"
            webView.nextLabel.text = "载入下一篇"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.blue
        webView = MPWebView()
        topAnimatedView = UIView()
        topAnimatedView.backgroundColor = UIColor.white
        bottomAnimatedView = UIView()
        bottomAnimatedView.backgroundColor = UIColor.white
        statusBackView.frame = CGRect(x: 0, y: 0, width: screenW, height: 20)
        
        webView.frame = CGRect(x: 0, y: -20, width: screenW, height: screenH + 20)
        topAnimatedView.frame = CGRect(x: 0, y: -(screenH + 20), width: screenW, height: screenH + 20)
        bottomAnimatedView.frame = CGRect(x: 0, y: screenH + 20, width: screenW, height: screenH + 20)
        view.addSubview(webView)
        view.addSubview(topAnimatedView)
        view.addSubview(bottomAnimatedView)
        view.addSubview(statusBackView)
        loadData()
        
        webView.scrollView.rx.contentOffset
            .asDriver()
            .drive(webView.offset)
            .addDisposableTo(disposeBag)
        
        webView.scrollView.rx.contentOffset
            .map { $0.y}
        .asDriver(onErrorJustReturn: 0)
            .drive(onNext: { y in
                if y > 180 {
                    self.statusBackView.isHidden = false
                    UIApplication.shared.statusBarStyle = .default
                } else {
                    self.statusBackView.isHidden = true
                    UIApplication.shared.statusBarStyle = .lightContent
                }
            })
        .addDisposableTo(disposeBag)
        
        webView.scrollView.rx.setDelegate(self)
            .addDisposableTo(disposeBag)
        
        didSetIndex(index)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
    }
    
//    deinit {
//        // pop出这个控制器时，不设置为nil会崩溃
//        webView.scrollView.delegate = nil
//    }
    
    fileprivate func loadData() {
        MPApiService.shareAPI.loadThemeDetail(ID: id)
            .asDriver(onErrorJustReturn: MPStoryDetailModel())
            .drive(webView.detailModel)
            .addDisposableTo(disposeBag)
    }
    
    fileprivate var webView: MPWebView!
    fileprivate var topAnimatedView: UIView!
    fileprivate var bottomAnimatedView: UIView!
    fileprivate lazy var statusBackView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.isHidden = true
        return view
    }()
}

extension MPNewsDetailViewController: UIScrollViewDelegate {
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//        print("offY:-\(scrollView.contentOffset.y), height:-\(contentH)")
        if scrollView.contentOffset.y <= -75 && index != 0{
            webView.startLoading()
            UIView.animate(withDuration: 0.3, animations: {
                self.topAnimatedView.transform = CGAffineTransform.init(translationX: 0, y: (screenH + 20))
            }, completion: { (state) in
                if state {
                    self.topAnimatedView.transform = CGAffineTransform.identity
                    self.didSetIndex(self.index - 1)
                    self.loadData()
                }
            })
        }else if scrollView.contentOffset.y + screenH - 70 >= scrollView.contentSize.height && index != idArr.count - 1 {
            webView.startLoading()
            UIView.animate(withDuration: 0.3, animations: {
                self.bottomAnimatedView.transform = CGAffineTransform.init(translationX: 0, y: -(screenH + 20))
            }, completion: { (state) in
                if state {
                    self.bottomAnimatedView.transform = CGAffineTransform.identity
                    self.didSetIndex(self.index + 1)
                    self.loadData()
                }
            })
        }
    }
}








