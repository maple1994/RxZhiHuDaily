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
        webView.frame = CGRect(x: 0, y: -20, width: screenW, height: screenH)
        view.addSubview(webView)
        webView.scrollView.delegate = self
        loadData()
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
}

extension MPNewsDetailViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollView.rx.contentOffset
        .asDriver()
        .drive(webView.offset)
    }
}





