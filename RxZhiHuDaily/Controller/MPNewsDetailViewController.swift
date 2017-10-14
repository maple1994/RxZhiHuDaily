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
        view.backgroundColor = UIColor.white
        webView = MPWebView()
        statusBackView.frame = CGRect(x: 0, y: 0, width: screenW, height: 20)
        webView.frame = CGRect(x: 0, y: -20, width: screenW, height: screenH)
        view.addSubview(webView)
        view.addSubview(statusBackView)
        loadData()
        
        webView.scrollView.rx.contentOffset
            .asDriver()
            .drive(webView.offset)
            .addDisposableTo(disposeBag)
        
        webView.scrollView.rx.contentOffset
        .asDriver()
            .drive(onNext: { offset in
                if offset.y > 180 {
//                    self.view.bringSubview(toFront: self.statusBackView)
                    self.statusBackView.isHidden = false
                    UIApplication.shared.statusBarStyle = .default
                }else {
                    self.statusBackView.isHidden = true
                    UIApplication.shared.statusBarStyle = .lightContent
                }
            })
        .addDisposableTo(disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
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
    fileprivate lazy var statusBackView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.isHidden = true
        return view
    }()
}






