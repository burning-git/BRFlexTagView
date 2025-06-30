//
//  BRFlexTagView.swift
//  TagListView
//
//  Created by Assistant
//

import UIKit

// MARK: - BRFlexTagView

/**
 * BRFlexTagView - 灵活的标签视图组件
 *
 * 支持混合类型的标签显示，具有自适应布局和丰富的间距配置选项。
 *
 * 间距配置说明：
 * - contentInsets: 使用 UIEdgeInsets 控制整个内容区域的内边距
 * - tagHorizontalSpacing: 标签之间的水平间距
 * - tagVerticalSpacing: 行与行之间的垂直间距
 * - 提供便利方法如 setContentInsets(), setTagSpacing() 等简化配置
 * - 每个标签的内部间距由标签自己处理
 */
public class BRFlexTagView: UIView {
    // 模式设置
    public enum HeightMode {
        case adaptive  // 高度自适应
        case fixed(CGFloat)  // 固定高度，需要参数指定高度
    }
    
    // 配置参数 - 保持向后兼容
    public var tags: [String] = [] {
        didSet { 
            // 转换为AnyFlexTagItem
            let items = tags.map { 
                AnyFlexTagItem.create(data: BRFlexTextTagData(text: $0), viewType: BRFlexTagItemView.self)
            }
            setTagItems(items)
        }
    }
    
    // 新的混合类型标签系统
    var tagItems: [AnyFlexTagItem] = []
    
    // MARK: - 间距配置属性
    
    /// 内容区域的内边距
    public var contentInsets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0) {
        didSet { setNeedsTagLayout() }
    }
    
    /// 标签水平间距（标签之间的左右距离）
    public var tagHorizontalSpacing: CGFloat = 10.0 {
        didSet { setNeedsTagLayout() }
    }
    
    /// 标签垂直间距（行与行之间的上下距离）
    public var tagVerticalSpacing: CGFloat = 10.0 {
        didSet { setNeedsTagLayout() }
    }
    
    // MARK: - 其他配置属性
    
    public var tagCornerRadius: CGFloat = 4.0
    public var tagFont: UIFont = .systemFont(ofSize: 14)
    public var tagBackgroundColor: UIColor = .systemBlue
    public var tagTextColor: UIColor = .white
    public var onTagTapped: ((Int) -> Void)? = nil
    
    public var heightMode: HeightMode = .adaptive {
        didSet { updateHeightMode() }
    }
    
    private var tagViews: [any UIView & BRFlexTagItemViewProtocol] = []
    private var scrollView: UIScrollView?
    private var contentView: UIView?
    private var heightConstraint: NSLayoutConstraint?
    private var contentHeightConstraint: NSLayoutConstraint?
    private var needsTagLayout = false
    
    public override var bounds: CGRect {
        didSet {
            if bounds.size != oldValue.size {
                setNeedsTagLayout()
            }
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    // MARK: - Public API Methods
    
    /// 设置统一类型的标签数据（向后兼容）
    public func setTagData<T: BRFlexTagItemViewProtocol>(_ data: [T.DataType], viewType: T.Type) {
        let items = data.map { AnyFlexTagItem.create(data: $0, viewType: viewType) }
        setTagItems(items)
    }
    
    /// 设置混合类型的标签（新API）
    public func setTagItems(_ items: [AnyFlexTagItem]) {
        self.tagItems = items
        reloadData()
    }
    
    /// 添加单个标签数据
    public func addTagData<T: BRFlexTagItemViewProtocol>(_ data: T.DataType, viewType: T.Type) {
        let item = AnyFlexTagItem.create(data: data, viewType: viewType)
        addTagItem(item)
    }
    
    /// 添加单个标签项
    public func addTagItem(_ item: AnyFlexTagItem) {
        tagItems.append(item)
        reloadData()
    }
    
    /// 批量添加不同类型的标签
    public func addMixedTags(_ builder: (inout [AnyFlexTagItem]) -> Void) {
        var newItems: [AnyFlexTagItem] = []
        builder(&newItems)
        tagItems.append(contentsOf: newItems)
        reloadData()
    }
    
    /// 移除指定索引的标签
    public func removeTagAt(index: Int) {
        guard index >= 0 && index < tagItems.count else { return }
        tagItems.remove(at: index)
        reloadData()
    }
    
    /// 清空所有标签
    public func clearAllTags() {
        tagItems.removeAll()
        reloadData()
    }
    
    /// 获取标签数据
    public func getTagData() -> [any BRFlexTagItemDataProtocol] {
        return tagItems.map { $0.data }
    }
    
    /// 获取标签项
    public func getTagItems() -> [AnyFlexTagItem] {
        return tagItems
    }
    
    // MARK: - 间距配置便利方法
    
    /// 设置统一的内容内边距
    /// - Parameter inset: 统一的内边距值
    public func setContentInsets(_ inset: CGFloat) {
        contentInsets = UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
    }
    
    /// 设置水平和垂直内容内边距
    /// - Parameters:
    ///   - horizontal: 水平内边距（左右）
    ///   - vertical: 垂直内边距（上下）
    public func setContentInsets(horizontal: CGFloat, vertical: CGFloat) {
        contentInsets = UIEdgeInsets(top: vertical, left: horizontal, bottom: vertical, right: horizontal)
    }
    
    /// 设置标签间距
    /// - Parameters:
    ///   - horizontal: 水平间距（标签之间）
    ///   - vertical: 垂直间距（行之间）
    public func setTagSpacing(horizontal: CGFloat, vertical: CGFloat) {
        tagHorizontalSpacing = horizontal
        tagVerticalSpacing = vertical
    }
    
    /// 设置统一的标签间距
    /// - Parameter spacing: 统一的间距值
    public func setTagSpacing(_ spacing: CGFloat) {
        setTagSpacing(horizontal: spacing, vertical: spacing)
    }
    
    /// 批量设置间距配置
    /// - Parameters:
    ///   - contentInsets: 内容内边距
    ///   - tagHorizontalSpacing: 标签水平间距
    ///   - tagVerticalSpacing: 标签垂直间距（行间距）
    public func configureSpacing(
        contentInsets: UIEdgeInsets,
        tagHorizontalSpacing: CGFloat,
        tagVerticalSpacing: CGFloat
    ) {
        self.contentInsets = contentInsets
        self.tagHorizontalSpacing = tagHorizontalSpacing
        self.tagVerticalSpacing = tagVerticalSpacing
    }
    
    // MARK: - Private Methods
    
    private func setupView() {
        backgroundColor = .clear
        updateHeightMode()
    }
    
    private func updateHeightMode() {
        // 移除旧的高度约束
        if let heightConstraint = heightConstraint {
            removeConstraint(heightConstraint)
            self.heightConstraint = nil
        }
        
        // 清除现有视图结构
        scrollView?.removeFromSuperview()
        contentView?.removeFromSuperview()
        scrollView = nil
        contentView = nil
        
        // 两种模式都创建滚动视图
        let newScrollView = UIScrollView()
        newScrollView.showsVerticalScrollIndicator = true
        newScrollView.showsHorizontalScrollIndicator = false
        newScrollView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(newScrollView)
        
        NSLayoutConstraint.activate([
            newScrollView.topAnchor.constraint(equalTo: topAnchor),
            newScrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            newScrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            newScrollView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        // 如果是固定高度模式，设置高度约束
        if case .fixed(let height) = heightMode {
            let newHeightConstraint = heightAnchor.constraint(equalToConstant: height)
            newHeightConstraint.isActive = true
            self.heightConstraint = newHeightConstraint
        }
        
        let newContentView = UIView()
        newContentView.translatesAutoresizingMaskIntoConstraints = false
        newScrollView.addSubview(newContentView)
        
        NSLayoutConstraint.activate([
            newContentView.topAnchor.constraint(equalTo: newScrollView.topAnchor),
            newContentView.leadingAnchor.constraint(equalTo: newScrollView.leadingAnchor),
            newContentView.trailingAnchor.constraint(equalTo: newScrollView.trailingAnchor),
            newContentView.bottomAnchor.constraint(equalTo: newScrollView.bottomAnchor),
            newContentView.widthAnchor.constraint(equalTo: newScrollView.widthAnchor)
        ])
        
        self.scrollView = newScrollView
        self.contentView = newContentView
        
        // 刷新标签
        reloadData()
        
        // 强制立即更新布局
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    func reloadData() {
        // 清除现有标签
        tagViews.forEach { $0.removeFromSuperview() }
        tagViews.removeAll()
        
        // 创建新标签
        for (index, tagItem) in tagItems.enumerated() {
            let tagItemView = tagItem.createView(at: index, delegate: self)
            
            // 如果是BRFlexTagItemView类型，设置其特定属性
            if let textTagView = tagItemView as? BRFlexTagItemView {
                textTagView.cornerRadius = tagCornerRadius
                textTagView.textFont = tagFont
                textTagView.backgroundColor = tagBackgroundColor
                textTagView.textColor = tagTextColor
            }
            
            // 添加到适当的父视图
            if let contentView = contentView {
                contentView.addSubview(tagItemView)
            } else {
                addSubview(tagItemView)
            }
            
            tagViews.append(tagItemView)
        }
        
        setNeedsTagLayout()
    }
    
    // 添加此方法确保旋转后重新布局
    public override func didMoveToWindow() {
         super.didMoveToWindow()
         if window != nil {
             self.setNeedsTagLayout()
             self.layoutIfNeeded()
         }
     }
     
     // 添加这个方法来监听布局变化
    public override func layoutMarginsDidChange() {
         super.layoutMarginsDidChange()
         setNeedsLayout()
     }
     
    private func performTagLayout() {
        let containerView = contentView ?? self
        var viewWidth: CGFloat = 0
        
        // 优先尝试从滚动视图获取正确的宽度
        if let scrollView = scrollView {
            viewWidth = scrollView.bounds.width
        }
        
        // 如果滚动视图宽度为0，尝试使用容器视图宽度
        if viewWidth <= 0 {
            viewWidth = containerView.bounds.width
        }
        
        // 如果容器宽度为0，尝试使用自身的bounds宽度
        if viewWidth <= 0 {
            viewWidth = bounds.width
        }
        
        // 如果所有尝试都失败，使用屏幕宽度减去可能的边距作为最后的备选方案
        if viewWidth <= 0 {
            viewWidth = UIScreen.main.bounds.width - self.contentInsets.left - self.contentInsets.right // 假设左右各16点边距
        }
        
        // 确保宽度至少有一个最小值
        viewWidth = max(viewWidth, 100) // 最小宽度100点
        
        // 计算实际可用宽度（减去内边距）
        let availableContentWidth = viewWidth - contentInsets.left - contentInsets.right
        
        // 设置起始位置（考虑内边距）
        var xOffset: CGFloat = contentInsets.left
        var yOffset: CGFloat = contentInsets.top
        var maxHeightInCurrentLine: CGFloat = 0
        
        for (_, tagView) in tagViews.enumerated() {
            // 计算当前行剩余可用宽度
            let remainingWidth = max(availableContentWidth - (xOffset - contentInsets.left), 0)
            
            // 计算标签的理想尺寸（无宽度限制）
            let idealSize = tagView.sizeThatFits(CGSize(width: availableContentWidth, height: CGFloat.greatestFiniteMagnitude))
            
            // 如果标签太宽，不能放在当前行剩余空间，且不是行首，换到下一行
            if idealSize.width > remainingWidth && xOffset > contentInsets.left {
                xOffset = contentInsets.left
                yOffset += maxHeightInCurrentLine + tagVerticalSpacing
                maxHeightInCurrentLine = 0
            }
            
            // 重新计算放置位置的可用宽度
            let newRemainingWidth = max(availableContentWidth - (xOffset - contentInsets.left), 0)
            
            // 计算最终尺寸（如果标签宽度超过整行宽度，则使用整行宽度并换行显示）
            let finalSize = tagView.sizeThatFits(CGSize(width: newRemainingWidth, height: CGFloat.greatestFiniteMagnitude))
            
            // 设置标签位置和尺寸
            tagView.frame = CGRect(x: xOffset, y: yOffset, width: finalSize.width, height: finalSize.height)
            
            // 更新下一个标签的x位置（添加标签宽度和水平间距）
            xOffset += finalSize.width + tagHorizontalSpacing
            maxHeightInCurrentLine = max(maxHeightInCurrentLine, finalSize.height)
        }
        
        // 计算内容总高度（包括底部内边距）
        let contentHeight = tagItems.isEmpty ? (contentInsets.top + contentInsets.bottom) : (yOffset + maxHeightInCurrentLine + contentInsets.bottom)
        
        // 根据模式更新约束
        switch heightMode {
        case .adaptive:
            // 自适应模式：调整自身高度以适应内容
            if let heightConstraint = heightConstraint {
                heightConstraint.constant = contentHeight
            } else {
                let newHeightConstraint = heightAnchor.constraint(equalToConstant: contentHeight)
                newHeightConstraint.isActive = true
                self.heightConstraint = newHeightConstraint
            }
            
            // 更新内容视图和滚动视图
            if let contentView = contentView, let scrollView = scrollView {
                // 移除旧的内容高度约束
                if let contentHeightConstraint = contentHeightConstraint {
                    contentView.removeConstraint(contentHeightConstraint)
                    self.contentHeightConstraint = nil
                }
                
                // 添加新的高度约束
                let safeContentHeight = max(contentHeight, 1)
                let newContentHeightConstraint = contentView.heightAnchor.constraint(equalToConstant: safeContentHeight)
                newContentHeightConstraint.isActive = true
                self.contentHeightConstraint = newContentHeightConstraint
                
                // 更新滚动视图的内容大小
                scrollView.contentSize = CGSize(width: viewWidth, height: safeContentHeight)
            }
            
        case .fixed:
            // 固定高度模式：只更新内容视图和滚动视图
            if let contentView = contentView, let scrollView = scrollView {
                // 移除旧的内容高度约束
                if let contentHeightConstraint = contentHeightConstraint {
                    contentView.removeConstraint(contentHeightConstraint)
                    self.contentHeightConstraint = nil
                }
                
                // 添加新的高度约束，确保至少有1像素的高度
                let safeContentHeight = max(contentHeight, 1)
                let newContentHeightConstraint = contentView.heightAnchor.constraint(equalToConstant: safeContentHeight)
                newContentHeightConstraint.isActive = true
                self.contentHeightConstraint = newContentHeightConstraint
                
                // 更新滚动视图的内容大小
                scrollView.contentSize = CGSize(width: viewWidth, height: safeContentHeight)
            }
        }
        
        invalidateIntrinsicContentSize()
    }
    
    public override var intrinsicContentSize: CGSize {
        switch heightMode {
        case .adaptive:
            if tagItems.isEmpty {
                let emptyHeight = contentInsets.top + contentInsets.bottom
                return CGSize(width: UIView.noIntrinsicMetric, height: emptyHeight)
            }
            
            var maxY: CGFloat = contentInsets.top
            for view in tagViews {
                maxY = max(maxY, view.frame.maxY)
            }
            
            // 添加底部内边距
            let totalHeight = maxY + contentInsets.bottom
            
            return CGSize(width: UIView.noIntrinsicMetric, height: totalHeight)
            
        case .fixed(let height):
            return CGSize(width: UIView.noIntrinsicMetric, height: height)
        }
    }
    
    private func setNeedsTagLayout() {
        needsTagLayout = true
        setNeedsLayout()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        // 会不会导致循环. 目前测试不会导致
        performTagLayout()
        print("#fsadadads:\(#function)")
    }
}

// MARK: - BRFlexTagItemViewDelegate Extension

extension BRFlexTagView: BRFlexTagItemViewDelegate {
    public func tagItemTapped(at index: Int) {
        onTagTapped?(index)
    }
}