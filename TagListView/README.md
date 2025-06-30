# TagListView

本项目包含两种标签视图的实现：

## 1. TagView (基于 UIView)

传统的基于 UIView 的实现，适合标签数量较少的场景。

### 特点：
- 直接使用 UIView 和子视图实现
- 自定义布局算法
- 适合小量标签（< 50个）
- 代码相对简单

### 用法：
```swift
let tagView = TagView()
tagView.tags = ["Swift", "iOS", "UIKit"]
tagView.heightMode = .adaptive
tagView.onTagTapped = { index in
    print("Tapped tag at index: \(index)")
}
```

## 2. TagCollectionView (基于 UICollectionView)

基于 UICollectionView 的高性能实现，适合大量标签的场景。

### 特点：
- 使用 UICollectionView 的复用机制
- 更好的性能，特别是大量标签时
- 内置滚动支持
- 更容易扩展和自定义
- **支持完全自定义的 Cell**

### 优势：
- **性能优化**: 通过 cell 复用机制，能够处理大量标签而不影响性能
- **内存效率**: 只创建可见的标签视图
- **滚动性能**: 利用 UICollectionView 的优化滚动
- **动画支持**: 更容易添加插入、删除动画
- **自定义 Cell**: 支持完全自定义的标签样式

### 用法：
```swift
let tagCollectionView = TagCollectionView()
tagCollectionView.tags = ["Swift", "iOS", "UIKit"]
tagCollectionView.heightMode = .adaptive
tagCollectionView.onTagTapped = { index in
    print("Tapped tag at index: \(index)")
}
```

## 自定义 Cell 支持 (TagCollectionView)

TagCollectionView 支持完全自定义的 cell，让你能够创建各种样式的标签：

### 基本用法

```swift
// 1. 创建自定义 Cell 类
class CustomTagCell: UICollectionViewCell, TagCollectionViewCellProtocol {
    func configure(with data: TagCellData) {
        // 配置 cell 显示
        // 使用 Auto Layout 设置约束，让 cell 自动计算尺寸
    }
}

// 2. 注册自定义 Cell
tagCollectionView.registerCustomCell(CustomTagCell.self)

// 3. 可选：使用配置处理器
tagCollectionView.cellConfigurationHandler = { cell, data in
    // 自定义配置逻辑
}
```

### 提供的自定义 Cell 示例

- **IconTagCell**: 带图标的标签
- **GradientTagCell**: 渐变背景标签  
- **BorderTagCell**: 边框样式标签
- **DeletableTagCell**: 可删除的标签
- **PriorityTagCell**: 优先级指示器标签

### 高级功能

- **TagCellData**: 统一的数据结构，支持扩展
- **userInfo**: 为每个标签传递额外数据
- **cellConfigurationHandler**: 动态配置回调
- **Auto Layout 自动尺寸**: 无需手动计算 cell 尺寸
- **向后兼容**: 不影响现有 API

### 重要提示

在自定义 cell 中，确保正确设置 Auto Layout 约束：

```swift
// 在 setupView 中设置基础约束
NSLayoutConstraint.activate([
    label.topAnchor.constraint(equalTo: contentView.topAnchor),
    label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
    label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
    label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
])

// 在 configure 中动态更新内边距
NSLayoutConstraint.deactivate(label.constraints)
NSLayoutConstraint.activate([
    label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: data.padding),
    // ... 其他约束
])
```

## 配置选项

两种实现都支持相同的配置选项：

- `tags`: 标签文本数组
- `heightMode`: 高度模式（.adaptive 或 .fixed(CGFloat)）
- `tagMargin`: 标签间距
- `tagPadding`: 标签内边距
- `lineSpacing`: 行间距
- `tagCornerRadius`: 圆角半径
- `tagFont`: 字体
- `tagBackgroundColor`: 背景色
- `tagTextColor`: 文字颜色
- `onTagTapped`: 点击回调

### TagCollectionView 额外选项：

- `customCellClass`: 自定义 Cell 类型
- `customCellNib`: 自定义 Cell Nib
- `cellConfigurationHandler`: Cell 配置回调
- `tagUserInfo`: 为每个标签提供额外数据

## 选择建议

### 使用 TagView 当：
- 标签数量较少（< 50个）
- 不需要频繁更新标签
- 希望代码简单直接

### 使用 TagCollectionView 当：
- 标签数量较多（> 50个）
- 需要频繁添加/删除标签
- 需要更好的滚动性能
- 希望未来扩展更多功能（如拖拽排序等）
- **需要自定义标签样式**

## 高度模式

### Adaptive 模式
- 视图高度自动适应内容
- 适合嵌入到 ScrollView 或其他容器中

### Fixed 模式
- 固定高度，内容超出时可滚动
- 适合需要限制高度的场景

## 演示

运行项目可以看到两种实现的对比演示，包括：
- 基本标签显示
- 高度模式切换
- 动态添加/删除标签
- 点击事件处理
- **自定义 Cell 样式切换**
- **图标、渐变、边框等效果**

## 文件结构

```
TagListView/
├── ViewController.swift              # 原 TagView 演示
├── TagCollectionViewController.swift # TagCollectionView 演示
├── TagCollectionView.swift          # 主要实现文件
├── CustomTagCell.swift              # 自定义 Cell 示例
├── CustomCellUsageExample.swift     # 详细使用指南
└── README.md                        # 说明文档
``` 