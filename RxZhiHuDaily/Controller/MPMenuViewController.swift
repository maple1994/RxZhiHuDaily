//
//  MPMenuViewController.swift
//  RxZhiHuDaily
//
//  Created by Maple on 2017/9/21.
//  Copyright © 2017年 Maple. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxDataSources

class MPMenuViewController: UIViewController {

    let themeArr = Variable([MPMenuItemModel]())
    let diposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.colorWithHexString("242A2F")
        setupUI()
        var home = MPMenuItemModel()
        home.name = "首页"
        themeArr.value = [home]
        
        tableView.register(MPMenuTableViewCell.self, forCellReuseIdentifier: "MenuID")
        
        themeArr.asDriver()
            .drive(tableView.rx.items(cellIdentifier: "MenuID", cellType: MPMenuTableViewCell.self)) { (row, element, cell) in
                
        }.addDisposableTo(diposeBag)
        
        // 默认选中第一列
        tableView.selectRow(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: .top)
    }

    fileprivate func setupUI() {
        view.addSubview(headerView)
        view.addSubview(tableView)
        view.addSubview(footerView)
        headerView.snp.makeConstraints { (make) in
            make.top.leading.trailing.equalToSuperview()
        }
        
        tableView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(headerView.snp.bottom)
            make.bottom.equalTo(footerView.snp.top)
        }
        
        footerView.snp.makeConstraints { (make) in
            make.bottom.leading.trailing.equalToSuperview()
            make.height.equalTo(50)
        }
    }
    
    
    // MARK: - View
    fileprivate lazy var headerView: MPMenuHeaderView = MPMenuHeaderView()
    fileprivate lazy var footerView: MPMenuFooterView = MPMenuFooterView()
    fileprivate lazy var tableView: UITableView = {
        let tb = UITableView()
        tb.showsVerticalScrollIndicator = false
        tb.backgroundColor = UIColor.clear
        tb.separatorStyle = .none
        return tb
    }()
}
