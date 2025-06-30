# BRFlexTagView Swift Package 使用指南

## 📦 Package 结构

```
BRFlexTagView/
├── Package.swift                     # Swift Package 配置
├── README.md                         # 详细使用文档
├── LICENSE                           # MIT 许可证
├── Sources/
│   └── BRFlexTagView/
│       ├── BRTagView.swift          # 主要组件和协议
│       └── BRTagViewExample.swift   # 示例实现
└── Tests/
    └── BRFlexTagViewTests/
        └── BRFlexTagViewTests.swift # 单元测试
```

## 🚀 在项目中使用

### 1. 添加 Package 依赖

在 Xcode 中：
1. 选择 `File` → `Add Package Dependencies...`
2. 输入 Repository URL
3. 选择版本并添加到项目

### 2. 导入模块

```swift
import BRFlexTagView
```

### 3. 基础使用

```swift
let tagView = BRTagView()
tagView.tags = ["Swift", "iOS", "UIKit"]
view.addSubview(tagView)
```

## 🎯 核心功能

### ✅ 支持的标签类型

1. **BRTextTagData + BRTagItemView** - 文本标签
2. **BRImageTextTagData + BRImageTextTagView** - 图片+文本标签  
3. **BRButtonTagData + BRButtonTagView** - 按钮标签

### ✅ 混合类型支持

```swift
tagView.addMixedTags { items in
    items.append(AnyTagItem.create(data: BRTextTagData(text: "文本"), viewType: BRTagItemView.self))
    items.append(AnyTagItem.create(data: BRImageTextTagData(text: "图标", imageName: "star"), viewType: BRImageTextTagView.self))
    items.append(AnyTagItem.create(data: BRButtonTagData(title: "按钮", style: .primary), viewType: BRButtonTagView.self))
}
```

### ✅ 便利方法

```swift
tagView.addTextTag("文本")
tagView.addImageTextTag(text: "图标", imageName: "star")
tagView.addButtonTag(title: "按钮", style: .primary)
```

## 🔧 自定义扩展

### 创建自定义标签类型

1. **实现数据协议**:
```swift
struct CustomTagData: BRTagItemDataProtocol {
    let identifier: String
    let title: String
    let viewData: Any
    
    init(title: String) {
        self.title = title
        self.identifier = title
        self.viewData = title
    }
}
```

2. **实现视图协议**:
```swift
class CustomTagView: UIView, BRTagItemViewProtocol {
    typealias DataType = CustomTagData
    
    weak var delegate: BRTagItemViewDelegate?
    var index: Int = 0
    
    required init(data: CustomTagData) {
        super.init(frame: .zero)
        // 设置视图...
    }
    
    func updateData(_ data: CustomTagData) {
        // 更新视图数据...
    }
    
    // 其他必需方法...
}
```

3. **使用自定义标签**:
```swift
let customData = CustomTagData(title: "自定义")
tagView.addTagData(customData, viewType: CustomTagView.self)
```

## 📋 API 参考

### 主要属性

```swift
tagView.tagMargin = 10.0           // 标签间距
tagView.tagPadding = 8.0           // 标签内边距  
tagView.lineSpacing = 10.0         // 行间距
tagView.tagCornerRadius = 4.0      // 圆角半径
tagView.heightMode = .adaptive     // 高度模式
```

### 主要方法

```swift
// 设置数据
setTagData(_:viewType:)
setTagItems(_:)
addMixedTags(_:)

// 动态操作
addTagData(_:viewType:)
addTagItem(_:)
removeTagAt(index:)
clearAllTags()

// 获取数据
getTagData()
getTagItems()
```

## 🧪 测试

运行测试：
```bash
swift test
```

## 📝 版本兼容性

- iOS 13.0+
- Swift 5.9+
- Xcode 15.0+

## 📞 支持

如有问题，请查看 README.md 获取详细文档或提交 Issue。 