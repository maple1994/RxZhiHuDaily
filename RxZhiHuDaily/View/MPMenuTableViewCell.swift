//
//  MPMenuTableViewCell.swift
//  RxZhiHuDaily
//
//  Created by Maple on 2017/9/21.
//  Copyright © 2017年 Maple. All rights reserved.
//

import UIKit
import SnapKit

class MPMenuTableViewCell: UITableViewCell {
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("")
    }
    
    private func setupUI() {
        let imgLabelView = UIView()
        selectedBackgroundView = selectedBgView
        self.backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        contentView.addSubview(imgLabelView)
        imgLabelView.addSubview(iconImgView)
        imgLabelView.addSubview(titleLabel)
        contentView.addSubview(plusImgView)
        
        imgLabelView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(10)
            make.centerY.equalToSuperview()
        }
        
        iconImgView.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.leading.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(iconImgView.snp.trailing)
            make.trailing.equalToSuperview()
            make.top.bottom.equalToSuperview()
        }
        
        plusImgView.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().offset(-8)
            make.centerY.equalToSuperview()
            make.width.equalTo(15)
            make.height.equalTo(18)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        selectedBgView.frame = self.bounds
    }
    
    // MARK: - View
    lazy var selectedBgView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.colorWithHexString("#1D2328")
        return view
    }()
    lazy var iconImgView: UIImageView = UIImageView(image: UIImage(named: "Menu_Icon_Home_Highlight"))
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "首页"
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    lazy var plusImgView: UIImageView = UIImageView(image: UIImage(named: "Dark_Menu_Follow"))
    
}
