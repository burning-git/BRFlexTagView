//
//  TagCollectionView.swift
//  TagListView
//
//

import UIKit

// MARK: - TagCollectionViewCellProtocol
protocol TagCollectionViewCellProtocol: UICollectionViewCell {
    func configure(with data: TagCellData)
}

// MARK: - TagCellData
struct TagCellData {
    let text: String
    let index: Int
    let padding: CGFloat
    let cornerRadius: CGFloat
    let font: UIFont
    let backgroundColor: UIColor
    let textColor: UIColor
    
    // 可扩展的额外数据
    let userInfo: [String: Any]?
    
    init(text: String, 
         index: Int, 
         padding: CGFloat, 
         cornerRadius: CGFloat, 
         font: UIFont, 
         backgroundColor: UIColor, 
         textColor: UIColor,
         userInfo: [String: Any]? = nil) {
        self.text = text
        self.index = index
        self.padding = padding
        self.cornerRadius = cornerRadius
        self.font = font
        self.backgroundColor = backgroundColor
        self.textColor = textColor
        self.userInfo = userInfo
    }
}

class TagCollectionView: UIView {
    // 模式设置
    enum HeightMode {
        case adaptive  // 高度自适应
        case fixed(CGFloat)  // 固定高度，需要参数指定高度
    }
    
    // 配置参数
    var tags: [String] = [] {
        didSet { reloadData() }
    }
    
    // 标签额外数据，可选
    var tagUserInfo: [[String: Any]]? = nil
    
    var tagMargin: CGFloat = 10.0 {
        didSet { updateLayout() }
    }
    var tagPadding: CGFloat = 10.0 {
        didSet { updateLayout() }
    }
    var lineSpacing: CGFloat = 10.0 {
        didSet { updateLayout() }
    }
    var tagCornerRadius: CGFloat = 4.0 {
        didSet { collectionView.reloadData() }
    }
    var tagFont: UIFont = .systemFont(ofSize: 14) {
        didSet { updateLayout() }
    }
    var tagBackgroundColor: UIColor = .systemBlue {
        didSet { collectionView.reloadData() }
    }
    var tagTextColor: UIColor = .white {
        didSet { collectionView.reloadData() }
    }
    var onTagTapped: ((Int) -> Void)? = nil
    
    var heightMode: HeightMode = .adaptive {
        didSet { updateHeightMode() }
    }
    
    // 自定义 cell 支持
    var customCellClass: TagCollectionViewCellProtocol.Type? {
        didSet { registerCustomCell() }
    }
    
    var customCellNib: UINib? {
        didSet { registerCustomCell() }
    }
    
    var cellConfigurationHandler: ((TagCollectionViewCellProtocol, TagCellData) -> Void)?
    
    private var collectionView: UICollectionView!
    private var flowLayout: TagCollectionViewFlowLayout!
    private var heightConstraint: NSLayoutConstraint?
    private var cellIdentifier: String = "TagCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        backgroundColor = .clear
        
        // 创建自定义流式布局
        flowLayout = TagCollectionViewFlowLayout()
        flowLayout.tagCollectionView = self
        
        // 启用自动尺寸计算
//        flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        flowLayout.estimatedItemSize = CGSize(width: UIScreen.main.bounds.width, height: 50) // 假设初始高度为50

        // 创建 collection view
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .red
        // 注册默认 cell
        registerDefaultCell()
        
        addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        updateHeightMode()
    }
    
    private func registerDefaultCell() {
        collectionView.register(TagCollectionViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
    }
    
    private func registerCustomCell() {
        if let customCellClass = customCellClass {
            collectionView.register(customCellClass, forCellWithReuseIdentifier: cellIdentifier)
        } else if let customCellNib = customCellNib {
            collectionView.register(customCellNib, forCellWithReuseIdentifier: cellIdentifier)
        } else {
            registerDefaultCell()
        }
    }
    
    // 便捷方法：注册自定义 cell 类
    func registerCustomCell<T: TagCollectionViewCellProtocol>(_ cellClass: T.Type) {
        customCellClass = cellClass
    }
    
    // 便捷方法：注册自定义 cell nib
    func registerCustomCell(nib: UINib) {
        customCellNib = nib
    }
    
    private func updateHeightMode() {
        // 移除旧的高度约束
        if let heightConstraint = heightConstraint {
            removeConstraint(heightConstraint)
            self.heightConstraint = nil
        }
        
        // 如果是固定高度模式，设置高度约束
        if case .fixed(let height) = heightMode {
            let newHeightConstraint = heightAnchor.constraint(equalToConstant: height)
            newHeightConstraint.isActive = true
            self.heightConstraint = newHeightConstraint
        }
        
        updateLayout()
    }
    
    private func updateLayout() {
        flowLayout.minimumInteritemSpacing = tagMargin
        flowLayout.minimumLineSpacing = lineSpacing
        flowLayout.invalidateLayout()
        
        // 在下一个 runloop 中更新高度
        DispatchQueue.main.async { [weak self] in
            self?.updateHeightIfNeeded()
        }
    }
    
    func updateHeightIfNeeded() {
        guard case .adaptive = heightMode else { return }
        
        let contentHeight = flowLayout.collectionViewContentSize.height
        
        if let heightConstraint = heightConstraint {
            heightConstraint.constant = contentHeight
        } else {
            let newHeightConstraint = heightAnchor.constraint(equalToConstant: contentHeight)
            newHeightConstraint.isActive = true
            self.heightConstraint = newHeightConstraint
        }
        
        invalidateIntrinsicContentSize()
    }
    
    func reloadData() {
        collectionView.reloadData()
        updateLayout()
    }
    
    override var intrinsicContentSize: CGSize {
        switch heightMode {
        case .adaptive:
            let contentHeight = flowLayout.collectionViewContentSize.height
            return CGSize(width: UIView.noIntrinsicMetric, height: contentHeight)
        case .fixed(let height):
            return CGSize(width: UIView.noIntrinsicMetric, height: height)
        }
    }
}

// MARK: - UICollectionViewDataSource
extension TagCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tags.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! TagCollectionViewCellProtocol
        
        let userInfo = (tagUserInfo?.count ?? 0) > indexPath.item ? tagUserInfo?[indexPath.item] : nil
        let cellData = TagCellData(
            text: tags[indexPath.item],
            index: indexPath.item,
            padding: tagPadding,
            cornerRadius: tagCornerRadius,
            font: tagFont,
            backgroundColor: tagBackgroundColor,
            textColor: tagTextColor,
            userInfo: userInfo
        )
        
        // 使用自定义配置处理器或默认配置
        if let configurationHandler = cellConfigurationHandler {
            configurationHandler(cell, cellData)
        } else {
            cell.configure(with: cellData)
        }
        
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension TagCollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        onTagTapped?(indexPath.item)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension TagCollectionView: UICollectionViewDelegateFlowLayout {
    // 不再需要 sizeForItemAt，使用自动尺寸计算
}

// MARK: - TagCollectionViewCell
class TagCollectionViewCell: UICollectionViewCell, TagCollectionViewCellProtocol {
    private let label = UILabel()
    private var topConstraint: NSLayoutConstraint!
    private var leadingConstraint: NSLayoutConstraint!
    private var trailingConstraint: NSLayoutConstraint!
    private var bottomConstraint: NSLayoutConstraint!
    
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
        
        // 设置 label 的约束，使用变量保存约束以便后续更新
        topConstraint = label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0)
        leadingConstraint = label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0)
        trailingConstraint = label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0)
        bottomConstraint = label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0)
        
        NSLayoutConstraint.activate([
            topConstraint,
            leadingConstraint,
            trailingConstraint,
            bottomConstraint
        ])
    }
    
    // MARK: - TagCollectionViewCellProtocol
    func configure(with data: TagCellData) {
        label.text = data.text
        label.font = data.font
        label.textColor = data.textColor
        contentView.backgroundColor = data.backgroundColor
        contentView.layer.cornerRadius = data.cornerRadius
        
        // 使用 TagCellData 中的 padding 值更新约束
        topConstraint.constant = data.padding
        leadingConstraint.constant = data.padding
        trailingConstraint.constant = -data.padding
        bottomConstraint.constant = -data.padding
    }
    
//    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
//        // 使用一个足够大的宽度来让内容自适应
//        let targetSize = CGSize(width: CGFloat.greatestFiniteMagnitude, height: 0)
//        let fittingSize = contentView.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: .fittingSizeLevel, verticalFittingPriority: .fittingSizeLevel)
//        
//        layoutAttributes.frame.size = fittingSize
//        return layoutAttributes
//    }
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        self.setNeedsLayout()
        self.layoutIfNeeded()
//          let attributes = super.preferredLayoutAttributesFitting(layoutAttributes)
////          // 重新计算cell的高度
//          let targetSize = CGSize(width: layoutAttributes.frame.width, height: 0)
//          let size = contentView.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
//          attributes.frame.size.height = size.height
//          return attributes
        let autoLayoutAttributes = super.preferredLayoutAttributesFitting(layoutAttributes)
        let cellSize = contentView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        autoLayoutAttributes.frame.size.height = cellSize.height
        return autoLayoutAttributes
      }
    // 不再需要手动计算尺寸，使用 Auto Layout 自动计算
}

// MARK: - TagCollectionViewFlowLayout
class TagCollectionViewFlowLayout: UICollectionViewFlowLayout {
    weak var tagCollectionView: TagCollectionView?
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let collectionView = collectionView else { return nil }
        let attributes = super.layoutAttributesForElements(in: rect)?.map { $0.copy() as! UICollectionViewLayoutAttributes } ?? []
        
        var rows: [[UICollectionViewLayoutAttributes]] = []
        var currentRow: [UICollectionViewLayoutAttributes] = []
        var currentRowY: CGFloat = -1
        
        // 按行分组
        for attribute in attributes {
            if currentRowY != attribute.frame.midY {
                if !currentRow.isEmpty {
                    rows.append(currentRow)
                }
                currentRow = [attribute]
                currentRowY = attribute.frame.midY
            } else {
                currentRow.append(attribute)
            }
        }
        
        if !currentRow.isEmpty {
            rows.append(currentRow)
        }
        
        // 调整每行的布局
        for row in rows {
            var currentX: CGFloat = 0
            
            for attribute in row {
                attribute.frame.origin.x = currentX
                currentX += attribute.frame.width + minimumInteritemSpacing
            }
        }
        
        return attributes
    }
    
    override var collectionViewContentSize: CGSize {
        let superSize = super.collectionViewContentSize
        return superSize
    }
    
    override func invalidateLayout() {
        super.invalidateLayout()
        
        // 通知 TagCollectionView 更新高度
        DispatchQueue.main.async { [weak self] in
            self?.tagCollectionView?.updateHeightIfNeeded()
        }
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        guard let collectionView = collectionView else { return false }
        return newBounds.width != collectionView.bounds.width
    }
} 
