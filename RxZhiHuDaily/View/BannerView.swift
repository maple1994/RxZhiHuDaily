//
//  BannerView.swift
//  MPZhiHuDaily
//
//  Created by Maple on 2017/8/20.
//  Copyright © 2017年 Maple. All rights reserved.
//

import UIKit
#if !RX_NO_MODULE
    import RxSwift
    import RxCocoa
#endif
import RxCocoa
import Kingfisher

/// 轮播图View
class BannerView: UIView {
    
    fileprivate let itemH: CGFloat = 200
    var topStories: [MPStoryModel]? {
        didSet {
            if let arr = topStories {
                if arr.count > 1 {
                    imgUrlArr.value = [arr.last!] + arr + [arr.first!]
                }else {
                    imgUrlArr.value = arr
                }
            }
        }
    }
    fileprivate let imgUrlArr = Variable([MPStoryModel]())
    let dispose = DisposeBag()
    // 监听tableView的滚动
    var offY: Variable<CGFloat> = Variable(0.0)
    var selectedIndex: Variable<Int> = Variable(0)
    fileprivate var index: Int = 0
    
    init() {
        super.init(frame: CGRect.zero)
        setupUI()        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("")
    }
    
    fileprivate func setupUI() {
        addSubview(collectionView)
        addSubview(pageControl)
        collectionView.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalToSuperview()
        }
        pageControl.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(0)
        }
        
        let ID = "BannerCellID"
        collectionView.register(BannerCell.self, forCellWithReuseIdentifier: ID)
        
        // 给collectionView的cell赋值
        imgUrlArr
        .asObservable()
            .bindTo(collectionView.rx.items(cellIdentifier: ID, cellType: BannerCell.self)) {
                row, model, cell in
                cell.model = model
                
        }.addDisposableTo(dispose)
        
        // 设置pageControl的数量
        imgUrlArr
            .asObservable()
            .subscribe (onNext: { models in
            self.pageControl.numberOfPages = models.count - 2
                self.collectionView.contentOffset.x = screenW
        }).addDisposableTo(dispose)
        
        // 监听滚动，设置图片的拉伸效果
        offY
        .asObservable()
            .subscribe(onNext: {
                offY in
                self.collectionView.visibleCells.forEach({ (cell) in
                    let myCell = cell as! BannerCell
                    myCell.imgView.frame.origin.y = offY
                    myCell.imgView.frame.size.height = 200 - offY
                })
            }).addDisposableTo(dispose)
        collectionView.rx.setDelegate(self).addDisposableTo(dispose)
        
        collectionView.rx.itemSelected
            .subscribe(onNext: { ip in
                let index = (ip.row - 1) >= 0 ? ip.row - 1 : 0
                self.selectedIndex.value = index
            })
        .addDisposableTo(dispose)
    }
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: screenW, height: self.itemH)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        let view = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        view.isPagingEnabled = true
        view.backgroundColor = UIColor.white
        view.showsHorizontalScrollIndicator = false
        view.clipsToBounds = false
        view.scrollsToTop = false
        return view
    }()
    
    fileprivate lazy var pageControl: UIPageControl = {
        let page = UIPageControl()
        return page
    }()
}

extension BannerView: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // 滚动最后一个图片时，回到第一张图片
        if scrollView.contentOffset.x == CGFloat(imgUrlArr.value.count - 1) * screenW {
            scrollView.contentOffset.x = screenW
        }else if scrollView.contentOffset.x == 0 {
            // 滚动到第一张图片时，回到最后一张图片
            scrollView.contentOffset.x = CGFloat(imgUrlArr.value.count - 2) * screenW
        }
        let index = Int(scrollView.contentOffset.x / screenW) - 1
        self.pageControl.currentPage = index
    }
}

class BannerCell: UICollectionViewCell {
    
    var model: MPStoryModel? {
        didSet {
            if let path = model?.image {
                imgView.kf.setImage(with: URL.init(string: path))
            }
            titleLabel.text = model?.title
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("")
    }
    
    fileprivate func setupUI() {
        contentView.addSubview(imgView)
        contentView.addSubview(maskImageView)
        contentView.addSubview(titleLabel)
        
        imgView.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.bottom.equalToSuperview().offset(-20)
        }
        
        maskImageView.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(100)
        }
    }
    
    lazy var imgView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    fileprivate lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = UIColor.white
        label.numberOfLines = 2
        return label
    }()
    
    fileprivate lazy var maskImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "Home_Image_Mask")
        return iv
    }()
}


