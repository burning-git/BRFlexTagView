//
//  BRTagViewExample.swift
//  TagListView
//
//  Created by Assistant
//

import UIKit

// MARK: - Example Custom Tag Views

/// 示例：图片+文本标签数据
public struct BRFlexImageTextTagData: BRFlexTagItemDataProtocol {
    public let identifier: String
    public let text: String
    public let imageName: String
    public let viewData: Any
    
    public init(text: String, imageName: String, identifier: String? = nil) {
        self.text = text
        self.imageName = imageName
        self.identifier = identifier ?? "\(text)_\(imageName)"
        self.viewData = (text: text, imageName: imageName)
    }
}

/// 示例：图片+文本标签视图
public class BRFlexImageTextTagView: UIView, BRFlexTagItemViewProtocol {
    public typealias DataType = BRFlexImageTextTagData
    
    private let imageView = UIImageView()
    private let label = UILabel()
    
    public weak var delegate: BRFlexTagItemViewDelegate?
    public var index: Int = 0
    
    public var padding: CGFloat = 8.0 {
        didSet { setNeedsLayout() }
    }
    
    public var cornerRadius: CGFloat = 4.0 {
        didSet { layer.cornerRadius = cornerRadius }
    }
    
    private let imageSize: CGFloat = 16
    private let imageTextSpacing: CGFloat = 4
    
    public required init(data: BRFlexImageTextTagData) {
        super.init(frame: .zero)
        setupView()
        updateData(data)
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    public func updateData(_ data: BRFlexImageTextTagData) {
        label.text = data.text
        imageView.image = UIImage(systemName: data.imageName)
        setNeedsLayout()
    }
    
    private func setupView() {
        isUserInteractionEnabled = true
        layer.cornerRadius = cornerRadius
        backgroundColor = .systemBlue
        
        // 设置imageView
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .white
        addSubview(imageView)
        
        // 设置label
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 14)
        label.textColor = .white
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        addSubview(label)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        addGestureRecognizer(tapGesture)
    }
    
    @objc private func handleTap() {
        delegate?.tagItemTapped(at: index)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        let contentBounds = bounds.insetBy(dx: padding, dy: padding)
        let imageFrame = CGRect(
            x: contentBounds.minX,
            y: contentBounds.minY + (contentBounds.height - imageSize) / 2,
            width: imageSize,
            height: imageSize
        )
        imageView.frame = imageFrame
        
        let labelX = imageFrame.maxX + imageTextSpacing
        let labelFrame = CGRect(
            x: labelX,
            y: contentBounds.minY,
            width: max(0, contentBounds.maxX - labelX),
            height: contentBounds.height
        )
        label.frame = labelFrame
    }
    
    public override func sizeThatFits(_ size: CGSize) -> CGSize {
        let availableWidth = size.width - padding * 2
        let labelAvailableWidth = max(0, availableWidth - imageSize - imageTextSpacing)
        
        // 计算文本尺寸
        let labelSize = label.sizeThatFits(CGSize(width: labelAvailableWidth, height: CGFloat.greatestFiniteMagnitude))
        
        // 计算总宽度
        let contentWidth = imageSize + imageTextSpacing + labelSize.width
        let totalWidth = min(contentWidth + padding * 2, size.width)
        
        // 计算总高度
        let contentHeight = max(imageSize, labelSize.height)
        let totalHeight = contentHeight + padding * 2
        
        return CGSize(width: totalWidth, height: totalHeight)
    }
}

// MARK: - Convenience Extensions

extension BRFlexTagView {
    /// 便利方法：添加文本标签
    public func addTextTag(_ text: String) {
        addTagData(BRFlexTextTagData(text: text), viewType: BRFlexTagItemView.self)
    }
    
    /// 便利方法：添加图片+文本标签
    public func addImageTextTag(text: String, imageName: String) {
        addTagData(BRFlexImageTextTagData(text: text, imageName: imageName), viewType: BRFlexImageTextTagView.self)
    }
    
    /// 便利方法：添加按钮标签
    public func addButtonTag(title: String, style: BRFlexButtonTagData.Style) {
        addTagData(BRFlexButtonTagData(title: title, style: style), viewType: BRFlexButtonTagView.self)
    }
    
    /// 便利方法：批量添加文本标签
    public func addTextTags(_ texts: [String]) {
        let items = texts.map { AnyFlexTagItem.create(data: BRFlexTextTagData(text: $0), viewType: BRFlexTagItemView.self) }
        tagItems.append(contentsOf: items)
        reloadData()
    }
}



// MARK: - Usage Examples

public class BRTagViewExampleViewController: UIViewController {
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupExamples()
    }
    
    private func setupExamples() {
        view.backgroundColor = .systemBackground
        
        // 示例1: 传统文本标签用法（向后兼容）
        let textTagView = BRFlexTagView()
        textTagView.tags = ["Swift", "iOS", "UIKit", "Auto Layout"]
        textTagView.tagBackgroundColor = .systemBlue
        textTagView.tagTextColor = .white
        textTagView.onTagTapped = { index in
            print("Tapped text tag at index: \(index)")
        }
        
        // 示例2: 使用新协议系统 - 文本标签
        let protocolTextTagView = BRFlexTagView()
        let textData = [
            BRFlexTextTagData(text: "Protocol"),
            BRFlexTextTagData(text: "Based"),
            BRFlexTextTagData(text: "Tags")
        ]
        protocolTextTagView.setTagData(textData, viewType: BRFlexTagItemView.self)
        protocolTextTagView.onTagTapped = { index in
            print("Tapped protocol text tag at index: \(index)")
        }
        
        // 示例3: 使用新协议系统 - 图片+文本标签
        let imageTextTagView = BRFlexTagView()
        let imageTextData = [
            BRFlexImageTextTagData(text: "Star", imageName: "star.fill"),
            BRFlexImageTextTagData(text: "Heart", imageName: "heart.fill"),
            BRFlexImageTextTagData(text: "Bookmark", imageName: "bookmark.fill"),
            BRFlexImageTextTagData(text: "Star23123123", imageName: "star.fill"),
            BRFlexImageTextTagData(text: "Heart213123123", imageName: "heart.fill"),
            BRFlexImageTextTagData(text: "Bookmark2312312", imageName: "bookmark.fill"),
            BRFlexImageTextTagData(text: "Starzasfasfafa", imageName: "star.fill"),
            BRFlexImageTextTagData(text: "dd", imageName: "heart.fill"),
            BRFlexImageTextTagData(text: "Bookmarkasdadadasddsdsds", imageName: "bookmark.fill")
        ]
        imageTextTagView.setTagData(imageTextData, viewType: BRFlexImageTextTagView.self)
        imageTextTagView.onTagTapped = { index in
            print("Tapped image text tag at index: \(index)")
        }
        
        // 示例4: 自定义按钮标签
        let buttonTagView = BRFlexTagView()
        let buttonData = [
            BRFlexButtonTagData(title: "Delete", style: .destructive),
            BRFlexButtonTagData(title: "Edit", style: .primary),
            BRFlexButtonTagData(title: "Share", style: .secondary)
        ]
        buttonTagView.setTagData(buttonData, viewType: BRFlexButtonTagView.self)
        buttonTagView.onTagTapped = { index in
            print("Tapped button tag at index: \(index)")
        }
        
        // 示例5: 🎯 新功能 - 混合类型标签
        let mixedTagView = BRFlexTagView()
        mixedTagView.addMixedTags { items in
            // 添加文本标签
            items.append(AnyFlexTagItem.create(data: BRFlexTextTagData(text: "文本"), viewType: BRFlexTagItemView.self))
            
            // 添加图片+文本标签
            items.append(AnyFlexTagItem.create(data: BRFlexImageTextTagData(text: "图标", imageName: "star.fill"), viewType: BRFlexImageTextTagView.self))
            
            // 添加按钮标签
            items.append(AnyFlexTagItem.create(data: BRFlexButtonTagData(title: "按钮", style: .primary), viewType: BRFlexButtonTagView.self))
            
            // 再添加一些文本标签
            items.append(AnyFlexTagItem.create(data: BRFlexTextTagData(text: "混合"), viewType: BRFlexTagItemView.self))
            items.append(AnyFlexTagItem.create(data: BRFlexTextTagData(text: "类型"), viewType: BRFlexTagItemView.self))
        }
        mixedTagView.onTagTapped = { index in
            print("Tapped mixed tag at index: \(index)")
        }
        
        // 示例6: 使用便利方法动态添加不同类型标签
        let dynamicTagView = BRFlexTagView()
        dynamicTagView.addTagData(BRFlexTextTagData(text: "动态"), viewType: BRFlexTagItemView.self)
        dynamicTagView.addTagData(BRFlexImageTextTagData(text: "添加", imageName: "plus.circle"), viewType: BRFlexImageTextTagView.self)
        dynamicTagView.addTagData(BRFlexButtonTagData(title: "删除", style: .destructive), viewType: BRFlexButtonTagView.self)
        dynamicTagView.onTagTapped = { index in
            print("Tapped dynamic tag at index: \(index)")
        }
        
        // 添加到视图并设置布局
        let stackView = UIStackView(arrangedSubviews: [
            createSectionView(title: "传统文本标签", tagView: textTagView),
            createSectionView(title: "协议文本标签", tagView: protocolTextTagView),
            createSectionView(title: "图片文本标签", tagView: imageTextTagView),
            createSectionView(title: "按钮标签", tagView: buttonTagView),
            createSectionView(title: "🎯 混合类型标签", tagView: mixedTagView),
            createSectionView(title: "动态添加标签", tagView: dynamicTagView)
        ])
        
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(stackView)
        view.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -20),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -32)
        ])
    }
    
    private func createSectionView(title: String, tagView: BRFlexTagView) -> UIView {
        let containerView = UIView()
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .boldSystemFont(ofSize: 16)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        tagView.translatesAutoresizingMaskIntoConstraints = false
        tagView.heightMode = .adaptive
        
        containerView.addSubview(titleLabel)
        containerView.addSubview(tagView)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            
            tagView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            tagView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            tagView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            tagView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
        
        return containerView
    }
}

// MARK: - Custom Button Tag Example

/// 按钮标签数据
public struct BRFlexButtonTagData: BRFlexTagItemDataProtocol {
    public enum Style {
        case primary, secondary, destructive
    }
    
    public let identifier: String
    public let title: String
    public let style: Style
    public let viewData: Any
    
    public init(title: String, style: Style, identifier: String? = nil) {
        self.title = title
        self.style = style
        self.identifier = identifier ?? title
        self.viewData = (title: title, style: style)
    }
}

/// 按钮标签视图
public class BRFlexButtonTagView: UIView, BRFlexTagItemViewProtocol {
    public typealias DataType = BRFlexButtonTagData
    
    private let button = UIButton(type: .system)
    public weak var delegate: BRFlexTagItemViewDelegate?
    public var index: Int = 0
    
    public required init(data: BRFlexButtonTagData) {
        super.init(frame: .zero)
        setupView()
        updateData(data)
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    public func updateData(_ data: BRFlexButtonTagData) {
        button.setTitle(data.title, for: .normal)
        
        switch data.style {
        case .primary:
            button.backgroundColor = .systemBlue
            button.setTitleColor(.white, for: .normal)
        case .secondary:
            button.backgroundColor = .systemGray5
            button.setTitleColor(.systemBlue, for: .normal)
        case .destructive:
            button.backgroundColor = .systemRed
            button.setTitleColor(.white, for: .normal)
        }
    }
    
    private func setupView() {
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 8
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
        addSubview(button)
        
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: topAnchor),
            button.leadingAnchor.constraint(equalTo: leadingAnchor),
            button.trailingAnchor.constraint(equalTo: trailingAnchor),
            button.bottomAnchor.constraint(equalTo: bottomAnchor),
            button.heightAnchor.constraint(greaterThanOrEqualToConstant: 32)
        ])
    }
    
    @objc private func buttonTapped() {
        delegate?.tagItemTapped(at: index)
    }
    
    public override func sizeThatFits(_ size: CGSize) -> CGSize {
        let buttonSize = button.sizeThatFits(size)
        return CGSize(
            width: max(buttonSize.width + 16, 60), // 最小宽度和内边距
            height: max(buttonSize.height, 32)
        )
    }
}

// MARK: - Usage Instructions

/*
 使用说明：
 
 1. 基本文本标签（向后兼容）：
    ```swift
    let tagView = BRFlexTagView()
    tagView.tags = ["Swift", "iOS", "UIKit"]
    ```
 
 2. 使用协议系统的统一类型标签：
    ```swift
    let tagView = BRFlexTagView()
    let data = [BRFlexTextTagData(text: "Custom")]
    tagView.setTagData(data, viewType: BRFlexTagItemView.self)
    ```
 
 3. 🎯 新功能 - 混合类型标签（推荐）：
    ```swift
    let tagView = BRFlexTagView()
    tagView.addMixedTags { items in
        // 文本标签
        items.append(AnyFlexTagItem.create(data: BRFlexTextTagData(text: "文本"), viewType: BRFlexTagItemView.self))
        
        // 图片+文本标签
        items.append(AnyFlexTagItem.create(data: BRFlexImageTextTagData(text: "图标", imageName: "star"), viewType: BRFlexImageTextTagView.self))
        
        // 按钮标签
        items.append(AnyFlexTagItem.create(data: BRFlexButtonTagData(title: "按钮", style: .primary), viewType: BRFlexButtonTagView.self))
    }
    ```
 
 4. 动态操作标签：
    ```swift
    // 添加单个标签
    tagView.addTagData(BRFlexTextTagData(text: "新标签"), viewType: BRFlexTagItemView.self)
    
    // 或者使用AnyFlexTagItem
    let item = AnyFlexTagItem.create(data: BRFlexTextTagData(text: "新标签"), viewType: BRFlexTagItemView.self)
    tagView.addTagItem(item)
    
    // 移除标签
    tagView.removeTagAt(index: 0)
    
    // 清空所有标签
    tagView.clearAllTags()
    
    // 获取当前标签数据
    let currentData = tagView.getTagData()
    let currentItems = tagView.getTagItems()
    ```
 
 5. 创建自定义标签：
    a. 创建数据模型实现 BRFlexTagItemDataProtocol
    b. 创建视图类实现 BRFlexTagItemViewProtocol
    c. 使用 AnyFlexTagItem.create() 或 setTagData() 方法设置数据
 
 6. 标签点击事件：
    ```swift
    tagView.onTagTapped = { index in
        print("Tapped tag at index: \(index)")
    }
    ```
 
 7. 批量设置混合类型标签：
    ```swift
    let items = [
        AnyFlexTagItem.create(data: BRFlexTextTagData(text: "文本"), viewType: BRFlexTagItemView.self),
        AnyFlexTagItem.create(data: BRFlexImageTextTagData(text: "图标", imageName: "star"), viewType: BRFlexImageTextTagView.self)
    ]
    tagView.setTagItems(items)
    ```
 */ 

// MARK: - Backward Compatibility TypeAliases

/// 向后兼容性类型别名 - 示例组件
public typealias BRImageTextTagData = BRFlexImageTextTagData
public typealias BRImageTextTagView = BRFlexImageTextTagView
public typealias BRButtonTagData = BRFlexButtonTagData
public typealias BRButtonTagView = BRFlexButtonTagView
