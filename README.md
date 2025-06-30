# BRFlexTagView

一个灵活且强大的iOS标签视图组件，支持混合类型标签、自定义样式和自适应布局。

> **🎉 新名称说明**: 从 `BRTagView` 升级为 `BRFlexTagView`，体现组件的核心特性：**灵活性 (Flexibility)** 和 **可扩展性 (Extensibility)**。同时保持完全向后兼容，现有代码无需修改！

## 特性

- ✅ **混合类型支持**: 在同一个视图中显示不同类型的标签（文本、图片+文本、按钮等）
- ✅ **协议驱动**: 基于协议的架构，易于扩展自定义标签类型
- ✅ **自适应布局**: 支持自适应高度和固定高度两种模式
- ✅ **流式布局**: 自动换行，智能布局标签
- ✅ **高度可定制**: 支持自定义间距、圆角、字体、颜色等
- ✅ **向后兼容**: 完全兼容原有的字符串数组API
- ✅ **内置示例**: 提供文本、图片+文本、按钮标签的示例实现

## 安装

### Swift Package Manager

在Xcode中，选择 `File → Add Package Dependencies...`，然后输入：

```
https://github.com/your-username/BRFlexTagView
```

或者在 `Package.swift` 中添加：

```swift
dependencies: [
    .package(url: "https://github.com/your-username/BRFlexTagView", from: "1.0.0")
]
```

## 快速开始

### 基础用法

```swift
import BRFlexTagView

// 推荐使用新名称
let tagView = BRFlexTagView()
// 或者继续使用旧名称（向后兼容）
// let tagView = BRTagView()

tagView.tags = ["Swift", "iOS", "UIKit", "Auto Layout"]
tagView.tagBackgroundColor = .systemBlue
tagView.tagTextColor = .white
tagView.onTagTapped = { index in
    print("Tapped tag at index: \(index)")
}

// 添加到视图
view.addSubview(tagView)
```

### 混合类型标签（推荐）

```swift
import BRFlexTagView

let tagView = BRFlexTagView()

// 批量添加不同类型的标签
tagView.addMixedTags { items in
    // 文本标签
    items.append(AnyFlexTagItem.create(
        data: BRFlexTextTagData(text: "文本标签"), 
        viewType: BRFlexTagItemView.self
    ))
    
    // 图片+文本标签
    items.append(AnyFlexTagItem.create(
        data: BRFlexImageTextTagData(text: "图标", imageName: "star.fill"), 
        viewType: BRFlexImageTextTagView.self
    ))
    
    // 按钮标签
    items.append(AnyFlexTagItem.create(
        data: BRFlexButtonTagData(title: "按钮", style: .primary), 
        viewType: BRFlexButtonTagView.self
    ))
}

tagView.onTagTapped = { index in
    print("Tapped mixed tag at index: \(index)")
}
```

### 便利方法

```swift
// 快速添加不同类型的标签
tagView.addTextTag("简单文本")
tagView.addImageTextTag(text: "星星", imageName: "star.fill")
tagView.addButtonTag(title: "删除", style: .destructive)
tagView.addTextTags(["标签1", "标签2", "标签3"])
```

### 动态操作

```swift
// 添加单个标签
tagView.addTagData(BRFlexTextTagData(text: "新标签"), viewType: BRFlexTagItemView.self)

// 移除标签
tagView.removeTagAt(index: 0)

// 清空所有标签
tagView.clearAllTags()

// 获取当前标签数据
let currentData = tagView.getTagData()
let currentItems = tagView.getTagItems()
```

## 自定义标签类型

### 1. 创建数据模型

```swift
struct CustomTagData: BRFlexTagItemDataProtocol {
    let identifier: String
    let title: String
    let subtitle: String
    let viewData: Any
    
    init(title: String, subtitle: String) {
        self.title = title
        self.subtitle = subtitle
        self.identifier = "\(title)_\(subtitle)"
        self.viewData = (title: title, subtitle: subtitle)
    }
}
```

### 2. 创建视图类

```swift
class CustomTagView: UIView, BRFlexTagItemViewProtocol {
    typealias DataType = CustomTagData
    
    weak var delegate: BRFlexTagItemViewDelegate?
    var index: Int = 0
    
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    
    required init(data: CustomTagData) {
        super.init(frame: .zero)
        setupView()
        updateData(data)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    func updateData(_ data: CustomTagData) {
        titleLabel.text = data.title
        subtitleLabel.text = data.subtitle
    }
    
    private func setupView() {
        // 设置视图布局...
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        // 计算视图尺寸...
    }
}
```

### 3. 使用自定义标签

```swift
let customData = CustomTagData(title: "主标题", subtitle: "副标题")
tagView.addTagData(customData, viewType: CustomTagView.self)
```

## 配置选项

```swift
tagView.tagMargin = 10.0           // 标签间距
tagView.tagPadding = 8.0           // 标签内边距
tagView.lineSpacing = 10.0         // 行间距
tagView.tagCornerRadius = 4.0      // 圆角半径
tagView.tagFont = .systemFont(ofSize: 14)
tagView.tagBackgroundColor = .systemBlue
tagView.tagTextColor = .white

// 高度模式
tagView.heightMode = .adaptive      // 自适应高度
tagView.heightMode = .fixed(100)    // 固定高度100
```

## 内置标签类型

### BRFlexTextTagData + BRFlexTagItemView
基础文本标签，支持单行和多行文本。

### BRFlexImageTextTagData + BRFlexImageTextTagView
图片+文本标签，左侧显示图标，右侧显示文本。

### BRFlexButtonTagData + BRFlexButtonTagView
按钮样式标签，支持不同样式（primary、secondary、destructive）。

> **向后兼容性**: 旧名称（如 `BRTextTagData`、`BRTagItemView` 等）仍然可用，它们是新名称的类型别名。

## 示例

查看 `BRTagViewExampleViewController` 了解完整的使用示例。

## 系统要求

- iOS 13.0+
- Swift 5.9+
- Xcode 15.0+

## 许可证

MIT License

## 贡献

欢迎提交 Issue 和 Pull Request！ 