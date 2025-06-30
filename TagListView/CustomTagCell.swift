//
//  CustomTagCell.swift
//  TagListView
//
//

import UIKit

// MARK: - 自定义标签 Cell 示例 1：带图标的标签
class IconTagCell: UICollectionViewCell, TagCollectionViewCellProtocol {
    private let iconImageView = UIImageView()
    private let label = UILabel()
    private let stackView = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        // 配置图标
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.tintColor = .white
        
        // 配置标签
        label.textAlignment = .center
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        
        // 配置 StackView
        stackView.axis = .horizontal
        stackView.spacing = 6
        stackView.alignment = .center
        stackView.distribution = .fill
        
        stackView.addArrangedSubview(iconImageView)
        stackView.addArrangedSubview(label)
        
        contentView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        // 设置图标尺寸约束
        iconImageView.widthAnchor.constraint(equalToConstant: 16).isActive = true
        iconImageView.heightAnchor.constraint(equalToConstant: 16).isActive = true
        
        // 设置 StackView 约束，让 cell 可以自动计算尺寸
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    func configure(with data: TagCellData) {
        label.text = data.text
        label.font = data.font
        label.textColor = data.textColor
        contentView.backgroundColor = data.backgroundColor
        contentView.layer.cornerRadius = data.cornerRadius
        iconImageView.tintColor = data.textColor
        
        // 从 userInfo 中获取图标信息
        if let iconName = data.userInfo?["iconName"] as? String {
            iconImageView.image = UIImage(systemName: iconName)
            iconImageView.isHidden = false
        } else {
            iconImageView.isHidden = true
        }
        
        // 更新内边距约束
        NSLayoutConstraint.deactivate(stackView.constraints)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: data.padding),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: data.padding),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -data.padding),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -data.padding)
        ])
    }
    
    // 不再需要手动计算尺寸，使用 Auto Layout 自动计算
}

// MARK: - 自定义标签 Cell 示例 2：渐变背景标签
class GradientTagCell: UICollectionViewCell, TagCollectionViewCellProtocol {
    private let label = UILabel()
    private let gradientLayer = CAGradientLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        label.textAlignment = .center
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        
        // 添加渐变层
        contentView.layer.insertSublayer(gradientLayer, at: 0)
        
        contentView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        // 设置 label 约束，让 cell 可以自动计算尺寸
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: contentView.topAnchor),
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = contentView.bounds
    }
    
    func configure(with data: TagCellData) {
        label.text = data.text
        label.font = data.font
        label.textColor = data.textColor
        contentView.layer.cornerRadius = data.cornerRadius
        
        // 设置渐变色
        if let startColor = data.userInfo?["gradientStartColor"] as? UIColor,
           let endColor = data.userInfo?["gradientEndColor"] as? UIColor {
            gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
            gradientLayer.startPoint = CGPoint(x: 0, y: 0)
            gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        } else {
            // 默认渐变
            gradientLayer.colors = [data.backgroundColor.cgColor, data.backgroundColor.withAlphaComponent(0.7).cgColor]
            gradientLayer.startPoint = CGPoint(x: 0, y: 0)
            gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        }
        
        gradientLayer.cornerRadius = data.cornerRadius
        
        // 更新内边距约束
        NSLayoutConstraint.deactivate(label.constraints)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: data.padding),
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: data.padding),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -data.padding),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -data.padding)
        ])
    }
    
    // 不再需要手动计算尺寸，使用 Auto Layout 自动计算
}

// MARK: - 自定义标签 Cell 示例 3：边框样式标签
class BorderTagCell: UICollectionViewCell, TagCollectionViewCellProtocol {
    private let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        label.textAlignment = .center
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        
        contentView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        // 设置 label 约束，让 cell 可以自动计算尺寸
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: contentView.topAnchor),
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    func configure(with data: TagCellData) {
        label.text = data.text
        label.font = data.font
        label.textColor = data.backgroundColor // 使用背景色作为文字色
        contentView.backgroundColor = .clear
        contentView.layer.cornerRadius = data.cornerRadius
        
        // 设置边框
        contentView.layer.borderColor = data.backgroundColor.cgColor
        contentView.layer.borderWidth = data.userInfo?["borderWidth"] as? CGFloat ?? 2.0
        
        // 更新内边距约束
        NSLayoutConstraint.deactivate(label.constraints)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: data.padding),
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: data.padding),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -data.padding),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -data.padding)
        ])
    }
    
    // 不再需要手动计算尺寸，使用 Auto Layout 自动计算
} 