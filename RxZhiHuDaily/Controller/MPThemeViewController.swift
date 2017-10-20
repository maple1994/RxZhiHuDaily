//
//  MPOtherTypeViewController.swift
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
import SnapKit

/// 主题列表控制器
class MPThemeViewController: UIViewController {
    
    fileprivate let disposeBag = DisposeBag()
    fileprivate var stroies = Variable([MPStoryModel]())
    
    /// 菜单栏Item
    var themeModel: MPMenuItemModel? {
        didSet{
            navigationItem.title = themeModel?.name
            if let urlString = themeModel?.thumbnail {
                headerImg.kf.setImage(with: URL.init(string: urlString), placeholder: nil, options: nil, progressBlock: nil, completionHandler: { (image, _, _, _) in
                    self.navImgV.image = image
                })
            }
            if let id = themeModel?.id {
                MPApiService.shareAPI.loadThemeList(ID: id)
                .asDriver(onErrorJustReturn: [])
                .drive(stroies)
                .addDisposableTo(disposeBag)
            }
            
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        tableView.register(NewsTableViewCell.self, forCellReuseIdentifier: "ThemeCellID")
        tableView.rowHeight = 100
        
        backBtn.rx.tap
            .subscribe(onNext: {
                self.slideMenuController()?.openLeft()
            })
            .addDisposableTo(disposeBag)
        
        stroies.asDriver()
            .drive(tableView.rx.items(cellIdentifier: "ThemeCellID", cellType: NewsTableViewCell.self)) { (row, element, cell) in
                cell.model = element
        }
        .addDisposableTo(disposeBag)
        
        tableView.rx.contentOffset
            .filter { $0.y < 0 }
            .map { $0.y }
            .subscribe(onNext: { offsetY in
                self.headerImg.frame.origin.y = offsetY
                self.headerImg.frame.size.height = 64 - offsetY
            })
            .addDisposableTo(disposeBag)
        
        tableView.rx
            .itemSelected
            .subscribe(onNext: { indexPath in
                self.showDetailVC(indexPath: indexPath)
            })
            .addDisposableTo(disposeBag)
        
        tableView.rx
        .contentOffset
            .map { $0.y }
            .subscribe(onNext: { y in
                self.navView.alpha = (y > 0) ? 1 : 0
            })
        .addDisposableTo(disposeBag)
    }
    
    fileprivate func showDetailVC(indexPath: IndexPath) {
        var idArr = [Int]()
        let sectionModel = self.stroies.value
        for item in sectionModel {
            if let id = item.id {
                idArr.append(id)
            }
        }
        let detailVC = MPNewsDetailViewController(idArr: idArr, index: indexPath.row)
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    fileprivate func setupUI() {
        automaticallyAdjustsScrollViewInsets = false
        view.addSubview(tableView)
        view.addSubview(navView)
        navView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(-64)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(64)
        }
        navView.alpha = 0
        navView.addSubview(navImgV)
        navImgV.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        tableView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(-64)
            make.leading.trailing.bottom.equalToSuperview()
        }
        tbHeaderView.frame = CGRect(x: 0, y: 0 , width: screenW, height: 64)
        headerImg.frame = tbHeaderView.frame
        tbHeaderView.addSubview(headerImg)
        tableView.tableHeaderView = tbHeaderView
        // 设置导航栏
        navigationController?.navigationBar.subviews.first?.alpha = 0
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.tintColor = UIColor.white
        backBtn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 100, height: 60))
        backBtn.setImage(UIImage.init(named: "Back_White"), for: .normal)
        backBtn.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: -20, bottom: 0, right: 60)
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: backBtn)
    }
    
    // MARK: - View
    fileprivate lazy var navView = UIView()
    fileprivate lazy var navImgV = UIImageView()
    fileprivate lazy var tableView = UITableView()
    fileprivate var backBtn: UIButton!
    fileprivate lazy var headerImg = UIImageView()
    fileprivate lazy var tbHeaderView = UIView()
}











