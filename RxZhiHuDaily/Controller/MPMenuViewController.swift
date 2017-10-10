//
//  MPMenuViewController.swift
//  RxZhiHuDaily
//
//  Created by Maple on 2017/9/21.
//  Copyright © 2017年 Maple. All rights reserved.
//

import UIKit
#if !RX_NO_MODULE
    import RxSwift
    import RxCocoa
#endif
import RxDataSources
import Moya
import Kingfisher

class MPMenuViewController: UIViewController {

    let themeArr = Variable([MPMenuItemModel]())
    let diposeBag = DisposeBag()
    let provide = RxMoyaProvider<ApiManager>()
    var tabbarVC: MPTabBarController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.colorWithHexString("242A2F")
        setupUI()

        MPApiService.shareAPI.loadMenuItemList()
        .asDriver(onErrorJustReturn: [MPMenuItemModel]())
        .drive(themeArr)
        .addDisposableTo(diposeBag)
        
        tableView.register(MPMenuTableViewCell.self, forCellReuseIdentifier: "MenuID")
        
        themeArr.asDriver()
            .drive(tableView.rx.items(cellIdentifier: "MenuID", cellType: MPMenuTableViewCell.self)) { (row, element, cell) in
                cell.titleLabel.text = self.themeArr.value[row].name
                if row != 0 {
                    cell.iconImgView.image = nil
                }
        }.addDisposableTo(diposeBag)
       
        tableView.rx
            .itemSelected
            .subscribe(onNext: { ip in
                if ip.row == 0 {
                    self.tabbarVC?.selectedIndex = 0
                }else {
                    self.tabbarVC?.themeVC?.themeModel = self.themeArr.value[ip.row]
                    self.tabbarVC?.selectedIndex = 1
                }
                self.slideMenuController()?.closeLeft()
        }).addDisposableTo(diposeBag)
        
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
        tb.scrollsToTop = false
        tb.showsVerticalScrollIndicator = false
        tb.backgroundColor = UIColor.clear
        tb.separatorStyle = .none
        return tb
    }()
}
