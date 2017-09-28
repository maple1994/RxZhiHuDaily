//
//  MPHomeViewController.swift
//  RxZhiHuDaily
//
//  Created by Maple on 2017/9/21.
//  Copyright © 2017年 Maple. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit
import Moya
import RxDataSources
import SwiftDate

class MPHomeViewController: UIViewController {
    
    fileprivate let disposeBag = DisposeBag()
    fileprivate let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, MPStoryModel>>()
    fileprivate let NewsID: String = "NewsID"
    fileprivate let provide = RxMoyaProvider<ApiManager>()
    fileprivate let modelArr = Variable([SectionModel<String, MPStoryModel>]())

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        tableView.register(NewsTableViewCell.self, forCellReuseIdentifier: NewsID)
        dataSource.configureCell = { (dataSource, tableView, indexPath, model) in
            let cell = tableView.dequeueReusableCell(withIdentifier: self.NewsID) as! NewsTableViewCell
            cell.model = model
            return cell
        }
        
        modelArr
            .asObservable()
            .bindTo(tableView.rx.items(dataSource: dataSource))
        .addDisposableTo(disposeBag)
        
        // 请求数据
        MPApiService.shareAPI.loadHomeNewsList()
        .asDriver(onErrorJustReturn: MPStoryListModel())
            .drive(onNext: { (model) in
                if let storyArr = model.stories {
                    let section = SectionModel(model: "测试", items: storyArr)
                    self.modelArr.value = [section]
                }
                if let topArr = model.top_stories {
                    if topArr.count > 1 {
                        self.bannerView.imgUrlArr.value = [topArr.last!] + topArr + [topArr.first!]
                    }else {
                        self.bannerView.imgUrlArr.value = topArr
                    }
                }
            })
        .addDisposableTo(disposeBag)
    }
    
    fileprivate func setupUI() {
        self.view.backgroundColor = UIColor.white
        
        barImg = (navigationController?.navigationBar.subviews.first)!
        barImg.alpha = 0
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationItem.leftBarButtonItem = menuBtn
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.barTintColor = UIColor.rgb(63, 141, 208)
        navigationController?.navigationBar.isTranslucent = false
        
        self.view.addSubview(tableView)
        
        tableView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(-64)
            make.left.right.bottom.equalToSuperview()
        }
        
        bannerView.frame = CGRect(x: 0, y: 0, width: screenW, height: 200)
        tableView.tableHeaderView = bannerView
    }
    
    // MARK: - View
    fileprivate var barImg = UIView()
    fileprivate lazy var menuBtn: UIBarButtonItem = {
        let item = UIBarButtonItem(image: UIImage(named: "menu"), style: .plain, target: nil, action: nil)
        return item
    }()
    fileprivate lazy var tableView: UITableView = {
        let tb = UITableView(frame: CGRect.zero, style: .grouped)
        tb.rowHeight = 100
        return tb
    }()
    fileprivate lazy var bannerView: BannerView = {
        let view = BannerView()
        return view
    }()

}
