//
//  BRFlexTagItemView.swift
//  TagListView
//
//  Created by Assistant
//

import UIKit

// MARK: - BRFlexTagItemView

public class BRFlexTagItemView: UIView, BRFlexTagItemViewProtocol {
    public typealias DataType = BRFlexTextTagData
    
    private let label = UILabel()
    public weak var delegate: BRFlexTagItemViewDelegate?
    public var index: Int = 0
    
    public var text: String {
        get { return label.text ?? "" }
        set { label.text = newValue }
    }
    
    public var padding: CGFloat = 10.0 {
        didSet { setNeedsLayout() }
    }
    
    public var cornerRadius: CGFloat = 4.0 {
        didSet { layer.cornerRadius = cornerRadius }
    }
    
    public var textFont: UIFont = .systemFont(ofSize: 14) {
        didSet { label.font = textFont }
    }
    
    public var textColor: UIColor = .white {
        didSet { label.textColor = textColor }
    }
    
    // MARK: - BRFlexTagItemViewProtocol Implementation
    
    public required init(data: BRFlexTextTagData) {
        super.init(frame: .zero)
        setupView()
        updateData(data)
    }
    
    public func updateData(_ data: BRFlexTextTagData) {
        self.text = data.text
    }
    
    // MARK: - Legacy Support
    
    public init(text: String) {
        super.init(frame: .zero)
        setupView()
        self.text = text
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        isUserInteractionEnabled = true
        layer.cornerRadius = cornerRadius
        
        label.textAlignment = .center
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = textFont
        label.textColor = textColor
        
        addSubview(label)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        addGestureRecognizer(tapGesture)
    }
    
    @objc private func handleTap() {
        delegate?.tagItemTapped(at: index)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        label.frame = bounds.insetBy(dx: padding, dy: padding)
    }
    
    public override func sizeThatFits(_ size: CGSize) -> CGSize {
        // 首先计算文本的理想尺寸（不限制宽度）
        let idealLabelSize = label.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude))
        let idealWidth = ceil(idealLabelSize.width) + (padding * 2)
        
        // 如果理想宽度小于等于可用宽度，使用理想宽度
        if idealWidth <= size.width {
            return CGSize(
                width: idealWidth,
                height: idealLabelSize.height + (padding * 2)
            )
        } else {
            // 如果理想宽度超过可用宽度，使用可用宽度并计算换行后的高度
            let maxLabelWidth = size.width - (padding * 2)
            let constrainedLabelSize = label.sizeThatFits(CGSize(width: maxLabelWidth, height: CGFloat.greatestFiniteMagnitude))
            
            return CGSize(
                width: size.width,
                height: ceil(constrainedLabelSize.height) + (padding * 2)
            )
        }
    }
} 