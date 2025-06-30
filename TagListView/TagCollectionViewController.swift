//
//  TagCollectionViewController.swift
//  TagListView
//
//

import UIKit

class TagCollectionViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "TagCollectionView Demo"
        view.backgroundColor = .systemBackground
        
        setupTagCollectionView()
    }
    
    private func setupTagCollectionView() {
        let tagCollectionView = TagCollectionView(frame: .zero)
        tagCollectionView.tags = [
//            "Swift", 
//            "iOS Development", 
//            "Auto Layout", 
//            "UIKit", 
//            "Very long tag that might wrap to multiple lines", 
//            "Short", 
//            "Medium Length Tag",
//            "CollectionView",
//            "FlowLayout",
            "Another long tag that demonstrates text wrapping",
//            "A", 
//            "AB", 
//            "ABC",
//            "Performance",
//            "Memory Management",
//            "Reusable Cells"
        ]
        
        // 配置样式
        tagCollectionView.tagMargin = 8.0
        tagCollectionView.tagPadding = 12.0
        tagCollectionView.lineSpacing = 8.0
        tagCollectionView.tagCornerRadius = 16.0
        tagCollectionView.tagFont = .systemFont(ofSize: 16, weight: .medium)
        tagCollectionView.tagBackgroundColor = .systemBlue
        tagCollectionView.tagTextColor = .white
        
        // 设置为自适应高度模式
        tagCollectionView.heightMode = .adaptive
        
        // 设置点击回调
        tagCollectionView.onTagTapped = { [weak self] index in
            let tagText = tagCollectionView.tags[index]
            print("Tapped tag at index \(index): \(tagText)")
            
            let alert = UIAlertController(
                title: "Tag Tapped",
                message: "You tapped: \(tagText)",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self?.present(alert, animated: true)
        }
        
        view.addSubview(tagCollectionView)
        tagCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tagCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            tagCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            tagCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
//            tagCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
//            tagCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0)
        ])
        
        // 添加一些控制按钮来演示不同的功能
        setupControlButtons(below: tagCollectionView)
    }
    
    private func setupControlButtons(below view: UIView) {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(stackView)
        
        // 切换高度模式按钮
        let heightModeButton = UIButton(type: .system)
        heightModeButton.setTitle("Switch to Fixed Height (200)", for: .normal)
        heightModeButton.backgroundColor = .systemGray5
        heightModeButton.layer.cornerRadius = 8
        heightModeButton.titleLabel?.font = .systemFont(ofSize: 16)
        heightModeButton.contentEdgeInsets = UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16)
        
        var isAdaptive = true
        heightModeButton.addAction(UIAction { [weak self] _ in
            guard let tagCollectionView = self?.view.subviews.first(where: { $0 is TagCollectionView }) as? TagCollectionView else { return }
            
            isAdaptive.toggle()
            if isAdaptive {
                tagCollectionView.heightMode = .adaptive
                heightModeButton.setTitle("Switch to Fixed Height (200)", for: .normal)
            } else {
                tagCollectionView.heightMode = .fixed(200)
                heightModeButton.setTitle("Switch to Adaptive Height", for: .normal)
            }
        }, for: .touchUpInside)
        
        // 添加更多标签按钮
        let addTagsButton = UIButton(type: .system)
        addTagsButton.setTitle("Add More Tags", for: .normal)
        addTagsButton.backgroundColor = .systemBlue
        addTagsButton.setTitleColor(.white, for: .normal)
        addTagsButton.layer.cornerRadius = 8
        addTagsButton.titleLabel?.font = .systemFont(ofSize: 16)
        addTagsButton.contentEdgeInsets = UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16)
        
        addTagsButton.addAction(UIAction { [weak self] _ in
            guard let tagCollectionView = self?.view.subviews.first(where: { $0 is TagCollectionView }) as? TagCollectionView else { return }
            
            let newTags = ["New Tag", "Dynamic", "Updated", "More Content", "Really Long Tag With Lots Of Text That Will Wrap"]
            tagCollectionView.tags.append(contentsOf: newTags)
        }, for: .touchUpInside)
        
        // 清空标签按钮
        let clearTagsButton = UIButton(type: .system)
        clearTagsButton.setTitle("Clear All Tags", for: .normal)
        clearTagsButton.backgroundColor = .systemRed
        clearTagsButton.setTitleColor(.white, for: .normal)
        clearTagsButton.layer.cornerRadius = 8
        clearTagsButton.titleLabel?.font = .systemFont(ofSize: 16)
        clearTagsButton.contentEdgeInsets = UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16)
        
        clearTagsButton.addAction(UIAction { [weak self] _ in
            guard let tagCollectionView = self?.view.subviews.first(where: { $0 is TagCollectionView }) as? TagCollectionView else { return }
            tagCollectionView.tags = []
        }, for: .touchUpInside)
        
        // 自定义 Cell 样式按钮
        let customCellButton = UIButton(type: .system)
        customCellButton.setTitle("Switch to Icon Cell", for: .normal)
        customCellButton.backgroundColor = .systemPurple
        customCellButton.setTitleColor(.white, for: .normal)
        customCellButton.layer.cornerRadius = 8
        customCellButton.titleLabel?.font = .systemFont(ofSize: 16)
        customCellButton.contentEdgeInsets = UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16)
        
        var cellType = 0 // 0: 默认, 1: 图标, 2: 渐变, 3: 边框
        customCellButton.addAction(UIAction { [weak self] _ in
            guard let tagCollectionView = self?.view.subviews.first(where: { $0 is TagCollectionView }) as? TagCollectionView else { return }
            
            cellType = (cellType + 1) % 4
            
            switch cellType {
            case 0:
                // 默认 Cell
                tagCollectionView.customCellClass = nil
                tagCollectionView.cellConfigurationHandler = nil
                customCellButton.setTitle("Switch to Icon Cell", for: .normal)
                customCellButton.backgroundColor = .systemPurple
                
            case 1:
                // 图标 Cell
                tagCollectionView.registerCustomCell(IconTagCell.self)
                tagCollectionView.cellConfigurationHandler = { cell, data in
                    var modifiedData = data
                    let icons = ["star.fill", "heart.fill", "swift", "gear", "house.fill", "person.fill"]
                    let iconName = icons[data.index % icons.count]
                    modifiedData = TagCellData(
                        text: data.text,
                        index: data.index,
                        padding: data.padding,
                        cornerRadius: data.cornerRadius,
                        font: data.font,
                        backgroundColor: data.backgroundColor,
                        textColor: data.textColor,
                        userInfo: ["iconName": iconName]
                    )
                    cell.configure(with: modifiedData)
                }
                customCellButton.setTitle("Switch to Gradient Cell", for: .normal)
                customCellButton.backgroundColor = .systemOrange
                
            case 2:
                // 渐变 Cell
                tagCollectionView.registerCustomCell(GradientTagCell.self)
                tagCollectionView.cellConfigurationHandler = { cell, data in
                    let colors = [
                        (UIColor.systemBlue, UIColor.systemPurple),
                        (UIColor.systemGreen, UIColor.systemTeal),
                        (UIColor.systemOrange, UIColor.systemRed),
                        (UIColor.systemPink, UIColor.systemPurple)
                    ]
                    let colorPair = colors[data.index % colors.count]
                    let modifiedData = TagCellData(
                        text: data.text,
                        index: data.index,
                        padding: data.padding,
                        cornerRadius: data.cornerRadius,
                        font: data.font,
                        backgroundColor: data.backgroundColor,
                        textColor: data.textColor,
                        userInfo: [
                            "gradientStartColor": colorPair.0,
                            "gradientEndColor": colorPair.1
                        ]
                    )
                    cell.configure(with: modifiedData)
                }
                customCellButton.setTitle("Switch to Border Cell", for: .normal)
                customCellButton.backgroundColor = .systemTeal
                
            case 3:
                // 边框 Cell
                tagCollectionView.registerCustomCell(BorderTagCell.self)
                tagCollectionView.cellConfigurationHandler = { cell, data in
                    let modifiedData = TagCellData(
                        text: data.text,
                        index: data.index,
                        padding: data.padding,
                        cornerRadius: data.cornerRadius,
                        font: data.font,
                        backgroundColor: data.backgroundColor,
                        textColor: data.textColor,
                        userInfo: ["borderWidth": 2.0]
                    )
                    cell.configure(with: modifiedData)
                }
                customCellButton.setTitle("Switch to Default Cell", for: .normal)
                customCellButton.backgroundColor = .systemGray
                
            default:
                break
            }
            
            tagCollectionView.reloadData()
        }, for: .touchUpInside)
        
        stackView.addArrangedSubview(heightModeButton)
        stackView.addArrangedSubview(addTagsButton)
        stackView.addArrangedSubview(clearTagsButton)
        stackView.addArrangedSubview(customCellButton)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.bottomAnchor, constant: 30),
            stackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20)
        ])
    }
} 
