//
//  CustomCellUsageExample.swift
//  TagListView
//
//

import UIKit

/*
 
 # TagCollectionView 自定义 Cell 使用指南
 
 TagCollectionView 支持完全自定义的 cell，让你能够创建各种样式的标签。
 
 ## 步骤 1: 创建自定义 Cell 类
 
 首先，创建一个实现 `TagCollectionViewCellProtocol` 协议的自定义 cell：
 
 */

// 示例：创建一个带删除按钮的标签 Cell
class DeletableTagCell: UICollectionViewCell, TagCollectionViewCellProtocol {
    private let label = UILabel()
    private let deleteButton = UIButton(type: .system)
    private let stackView = UIStackView()
    
    var onDeleteTapped: ((Int) -> Void)?
    private var currentIndex: Int = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        // 配置标签
        label.textAlignment = .left
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        
        // 配置删除按钮
        deleteButton.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        deleteButton.tintColor = .white
        deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        
        // 配置 StackView
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .center
        stackView.distribution = .fill
        
        stackView.addArrangedSubview(label)
        stackView.addArrangedSubview(deleteButton)
        
        contentView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        // 设置删除按钮尺寸
        deleteButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
        deleteButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        // 设置 StackView 约束，让 cell 可以自动计算尺寸
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    @objc private func deleteButtonTapped() {
        onDeleteTapped?(currentIndex)
    }
    
    func configure(with data: TagCellData) {
        label.text = data.text
        label.font = data.font
        label.textColor = data.textColor
        contentView.backgroundColor = data.backgroundColor
        contentView.layer.cornerRadius = data.cornerRadius
        currentIndex = data.index
        
        // 从 userInfo 中获取删除回调
        if let deleteHandler = data.userInfo?["onDelete"] as? (Int) -> Void {
            onDeleteTapped = deleteHandler
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

/*
 
 ## 步骤 2: 使用自定义 Cell
 
 在你的 ViewController 中使用自定义 cell：
 
 */

class CustomCellExampleViewController: UIViewController {
    
    private var tagCollectionView: TagCollectionView!
    private var tags = ["Swift", "iOS", "UIKit", "Custom Cell", "Deletable"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTagCollectionView()
    }
    
    private func setupTagCollectionView() {
        tagCollectionView = TagCollectionView()
        tagCollectionView.tags = tags
        
        // 方法 1: 使用 registerCustomCell 注册自定义 cell
        tagCollectionView.registerCustomCell(DeletableTagCell.self)
        
        // 方法 2: 使用 cellConfigurationHandler 进行自定义配置
        tagCollectionView.cellConfigurationHandler = { [weak self] cell, data in
            guard let self = self else { return }
            
            // 创建包含删除回调的 TagCellData
            let modifiedData = TagCellData(
                text: data.text,
                index: data.index,
                padding: data.padding,
                cornerRadius: data.cornerRadius,
                font: data.font,
                backgroundColor: data.backgroundColor,
                textColor: data.textColor,
                userInfo: [
                    "onDelete": { (index: Int) in
                        // 删除标签的逻辑
                        self.deleteTag(at: index)
                    }
                ]
            )
            
            cell.configure(with: modifiedData)
        }
        
        view.addSubview(tagCollectionView)
        tagCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tagCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            tagCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            tagCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    private func deleteTag(at index: Int) {
        guard index < tags.count else { return }
        tags.remove(at: index)
        tagCollectionView.tags = tags
        
        // 可选：添加删除动画
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
}

/*
 
 ## 步骤 3: 高级用法
 
 ### 使用 tagUserInfo 为每个标签提供特定数据
 
 */

extension CustomCellExampleViewController {
    
    private func setupAdvancedExample() {
        tagCollectionView = TagCollectionView()
        tagCollectionView.tags = ["Important", "Normal", "Warning", "Success"]
        
        // 为每个标签提供特定的配置数据
        tagCollectionView.tagUserInfo = [
            ["priority": "high", "color": UIColor.systemRed],     // Important
            ["priority": "normal", "color": UIColor.systemBlue], // Normal  
            ["priority": "warning", "color": UIColor.systemOrange], // Warning
            ["priority": "low", "color": UIColor.systemGreen]    // Success
        ]
        
        // 注册自定义 cell
        tagCollectionView.registerCustomCell(PriorityTagCell.self)
        
        // 可选：使用配置处理器进一步自定义
        tagCollectionView.cellConfigurationHandler = { cell, data in
            if let priority = data.userInfo?["priority"] as? String,
               let color = data.userInfo?["color"] as? UIColor {
                
                let modifiedData = TagCellData(
                    text: "\(priority.uppercased()): \(data.text)",
                    index: data.index,
                    padding: data.padding,
                    cornerRadius: data.cornerRadius,
                    font: data.font,
                    backgroundColor: color,
                    textColor: data.textColor,
                    userInfo: data.userInfo
                )
                
                cell.configure(with: modifiedData)
            } else {
                cell.configure(with: data)
            }
        }
    }
}

// 优先级标签示例
class PriorityTagCell: UICollectionViewCell, TagCollectionViewCellProtocol {
    private let label = UILabel()
    private let priorityIndicator = UIView()
    
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
        priorityIndicator.layer.cornerRadius = 4
        
        contentView.addSubview(priorityIndicator)
        contentView.addSubview(label)
        
        priorityIndicator.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func configure(with data: TagCellData) {
        label.text = data.text
        label.font = data.font
        label.textColor = data.textColor
        contentView.backgroundColor = data.backgroundColor
        contentView.layer.cornerRadius = data.cornerRadius
        
        // 根据优先级设置指示器颜色
        if let priority = data.userInfo?["priority"] as? String {
            switch priority {
            case "high":
                priorityIndicator.backgroundColor = .systemRed
            case "warning":
                priorityIndicator.backgroundColor = .systemOrange
            case "low":
                priorityIndicator.backgroundColor = .systemGreen
            default:
                priorityIndicator.backgroundColor = .systemBlue
            }
        }
        
        NSLayoutConstraint.activate([
            priorityIndicator.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            priorityIndicator.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            priorityIndicator.widthAnchor.constraint(equalToConstant: 8),
            priorityIndicator.heightAnchor.constraint(equalToConstant: 8),
            
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: data.padding),
            label.leadingAnchor.constraint(equalTo: priorityIndicator.trailingAnchor, constant: 8),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -data.padding),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -data.padding)
        ])
    }
    
    // 不再需要手动计算尺寸，使用 Auto Layout 自动计算
}

/*
 
 ## 总结
 
 通过实现 `TagCollectionViewCellProtocol` 协议，你可以：
 
 1. **创建完全自定义的标签样式**
 2. **添加交互元素**（如删除按钮、编辑按钮等）
 3. **使用 userInfo 传递额外数据**
 4. **实现复杂的布局和动画**
 5. **保持与现有 API 的兼容性**
 
 ### 核心方法：
 
 - `func configure(with data: TagCellData)`: 配置 cell 的显示
 - 尺寸计算由 Auto Layout 自动处理，无需手动实现
 
 ### 配置方式：
 
 1. **注册自定义 cell**: `tagCollectionView.registerCustomCell(YourCell.self)`
 2. **使用配置处理器**: `tagCollectionView.cellConfigurationHandler = { cell, data in ... }`
 3. **提供额外数据**: `tagCollectionView.tagUserInfo = [...]`
 
 */ 