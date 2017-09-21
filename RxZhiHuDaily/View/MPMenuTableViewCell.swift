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
        selectedBackgroundView = selectedBgView
        self.backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        contentView.addSubview(iconImgView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(plusImgView)
        
        iconImgView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(8)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(20)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(iconImgView.snp.trailing).offset(10)
            make.centerY.equalToSuperview()
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
