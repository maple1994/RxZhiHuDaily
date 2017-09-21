//
//  MPMenuViewController.swift
//  RxZhiHuDaily
//
//  Created by Maple on 2017/9/21.
//  Copyright © 2017年 Maple. All rights reserved.
//

import UIKit

class MPMenuViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.colorWithHexString("242A2F")
        setupUI()
    }

    fileprivate func setupUI() {
        view.addSubview(headerView)
        view.addSubview(footerView)
        headerView.snp.makeConstraints { (make) in
            make.top.leading.trailing.equalToSuperview()
        }
        
        footerView.snp.makeConstraints { (make) in
            make.bottom.leading.trailing.equalToSuperview()
            make.height.equalTo(50)
        }
    }
    
    
    // MARK: - View
    fileprivate lazy var headerView: MPMenuHeaderView = MPMenuHeaderView()
    fileprivate lazy var footerView: MPMenuFooterView = MPMenuFooterView()

}
