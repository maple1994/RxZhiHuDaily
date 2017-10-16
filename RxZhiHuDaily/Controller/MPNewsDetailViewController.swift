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

    var id: Int?
    fileprivate let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.blue
        webView = MPWebView()
        topAnimatedView = UIView()
        topAnimatedView.backgroundColor = UIColor.red
        bottomAnimatedView = UIView()
        bottomAnimatedView.backgroundColor = UIColor.green
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
        guard let ID = id else {
            return
        }
        MPApiService.shareAPI.loadThemeDetail(ID: ID)
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
        if scrollView.contentOffset.y <= -75 {
            UIView.animate(withDuration: 0.3, animations: {
                self.topAnimatedView.transform = CGAffineTransform.init(translationX: 0, y: (screenH + 20))
            }, completion: { (state) in
                if state {
                    self.topAnimatedView.transform = CGAffineTransform.identity
                }
            })
        }else if scrollView.contentOffset.y + screenH - 70 >= scrollView.contentSize.height {
            UIView.animate(withDuration: 0.3, animations: {
                self.bottomAnimatedView.transform = CGAffineTransform.init(translationX: 0, y: -(screenH + 20))
            }, completion: { (state) in
                if state {
                    self.bottomAnimatedView.transform = CGAffineTransform.identity
                }
            })
        }
    }
}








