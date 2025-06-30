//
//  BRFlexTagData.swift
//  TagListView
//
//  Created by Assistant
//

import Foundation

// MARK: - Data Models

/// 文本标签数据模型
public struct BRFlexTextTagData: BRFlexTagItemDataProtocol {
    public let identifier: String
    public let text: String
    public let viewData: Any
    
    public init(text: String, identifier: String? = nil) {
        self.text = text
        self.identifier = identifier ?? text
        self.viewData = text
    }
} 