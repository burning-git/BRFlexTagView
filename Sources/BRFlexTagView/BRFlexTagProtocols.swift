//
//  BRFlexTagProtocols.swift
//  TagListView
//
//  Created by Assistant
//

import UIKit

// MARK: - Protocols

/// 灵活标签项数据协议
public protocol BRFlexTagItemDataProtocol {
    /// 唯一标识符
    var identifier: String { get }
    /// 用于创建视图的数据
    var viewData: Any { get }
}

/// 灵活标签项视图协议
public protocol BRFlexTagItemViewProtocol: UIView {
    /// 关联的数据类型
    associatedtype DataType: BRFlexTagItemDataProtocol
    
    /// 代理
    var delegate: BRFlexTagItemViewDelegate? { get set }
    /// 索引
    var index: Int { get set }
    
    /// 初始化方法
    init(data: DataType)
    
    /// 更新视图数据
    func updateData(_ data: DataType)
    
    /// 计算视图尺寸
    func sizeThatFits(_ size: CGSize) -> CGSize
}

/// BRFlexTagItemView 代理协议
public protocol BRFlexTagItemViewDelegate: AnyObject {
    func tagItemTapped(at index: Int)
}

/// 类型擦除的灵活标签项包装器
public struct AnyFlexTagItem {
    let data: any BRFlexTagItemDataProtocol
    let viewCreator: (any BRFlexTagItemDataProtocol, Int) -> any UIView & BRFlexTagItemViewProtocol
    
    /// 为特定类型创建AnyFlexTagItem
    public static func create<T: BRFlexTagItemViewProtocol>(data: T.DataType, viewType: T.Type) -> AnyFlexTagItem {
        return AnyFlexTagItem(
            data: data,
            viewCreator: { data, index in
                let view = T(data: data as! T.DataType)
                view.index = index
                return view
            }
        )
    }
    
    /// 创建视图
    func createView(at index: Int, delegate: BRFlexTagItemViewDelegate?) -> any UIView & BRFlexTagItemViewProtocol {
        let view = viewCreator(data, index)
        view.delegate = delegate
        return view
    }
} 