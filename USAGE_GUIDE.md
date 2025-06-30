# BRFlexTagView Swift Package 使用指南

## 📦 Package 结构

```
BRFlexTagView/
├── Package.swift                     # Swift Package 配置
├── README.md                         # 详细使用文档
├── LICENSE                           # MIT 许可证
├── introImgs/                        # 效果展示图片
│   ├── lineAlignment_left.jpg        # 左对齐效果图
│   ├── lineAlignment_center.jpg      # 居中对齐效果图
│   └── lineAlignment_right.jpg       # 右对齐效果图
├── Sources/
│   └── BRFlexTagView/
│       ├── BRFlexTagView.swift       # 主要组件和协议
│       ├── BRFlexTagData.swift       # 标签数据模型
│       ├── BRFlexTagItemView.swift   # 标签视图实现
│       └── BRFlexTagProtocols.swift  # 协议定义
└── Tests/
    └── BRFlexTagViewTests/
        └── BRTagViewTests.swift      # 单元测试
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
let tagView = BRFlexTagView()
tagView.tags = ["Swift", "iOS", "UIKit"]
tagView.lineAlignment = .center    // 设置居中对齐
view.addSubview(tagView)
```

### 4. 便利构造函数使用

```swift
// 完整配置构造
let tagView = BRFlexTagView(
    contentInsets: UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16),
    tagHorizontalSpacing: 8,
    tagVerticalSpacing: 12,
    lineAlignment: .center,
    heightMode: .adaptive
)

// 快速设置统一间距
let tagView = BRFlexTagView(
    contentInset: 16,
    tagSpacing: 8,
    lineAlignment: .center
)
```

## 🎯 核心功能

### ✅ 支持的标签类型

1. **BRFlexTextTagData + BRFlexTagItemView** - 文本标签
2. **BRFlexImageTextTagData + BRFlexImageTextTagView** - 图片+文本标签  
3. **BRFlexButtonTagData + BRFlexButtonTagView** - 按钮标签

### ✅ 混合类型支持

```swift
tagView.addMixedTags { items in
    items.append(AnyFlexTagItem.create(data: BRFlexTextTagData(text: "文本"), viewType: BRFlexTagItemView.self))
    items.append(AnyFlexTagItem.create(data: BRFlexImageTextTagData(text: "图标", imageName: "star"), viewType: BRFlexImageTextTagView.self))
    items.append(AnyFlexTagItem.create(data: BRFlexButtonTagData(title: "按钮", style: .primary), viewType: BRFlexButtonTagView.self))
}
```

### ✅ 便利方法

```swift
tagView.addTextTag("文本")
tagView.addImageTextTag(text: "图标", imageName: "star")
tagView.addButtonTag(title: "按钮", style: .primary)
```

### ✅ 行对齐方式

```swift
// 三种对齐方式
tagView.lineAlignment = .left       // 左对齐
tagView.lineAlignment = .center     // 居中对齐
tagView.lineAlignment = .right      // 右对齐

// 便利方法
tagView.setLeftAlignment()
tagView.setCenterAlignment() 
tagView.setRightAlignment()
```

### ✅ 增强的点击回调

```swift
tagView.onTagTapped = { index, model, tagView in
    print("点击了第 \(index) 个标签")
    print("标签数据: \(model)")
    print("标签视图: \(tagView)")
    
    // 根据类型进行不同处理
    if let textData = model as? BRFlexTextTagData {
        print("文本标签: \(textData.text)")
    }
}
```

## 🔧 自定义扩展

### 创建自定义标签类型

1. **实现数据协议**:
```swift
struct CustomTagData: BRFlexTagItemDataProtocol {
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
class CustomTagView: UIView, BRFlexTagItemViewProtocol {
    typealias DataType = CustomTagData
    
    weak var delegate: BRFlexTagItemViewDelegate?
    var index: Int = 0
    
    required init(data: CustomTagData) {
        super.init(frame: .zero)
        // 设置视图...
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func updateData(_ data: CustomTagData) {
        // 更新视图数据...
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        // 返回视图的理想尺寸
        return CGSize(width: 100, height: 30)
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
// 间距配置
tagView.contentInsets = UIEdgeInsets(...)      // 内容内边距
tagView.tagHorizontalSpacing = 8.0             // 标签水平间距
tagView.tagVerticalSpacing = 12.0              // 标签垂直间距（行间距）

// 对齐方式
tagView.lineAlignment = .center                // 行对齐方式

// 样式配置
tagView.tagCornerRadius = 4.0                  // 圆角半径
tagView.tagFont = .systemFont(ofSize: 14)      // 字体
tagView.tagBackgroundColor = .systemBlue       // 背景色
tagView.tagTextColor = .white                  // 文字颜色

// 高度模式
tagView.heightMode = .adaptive                 // 高度模式

// 回调
tagView.onTagTapped = { index, model, tagView in
    // 处理点击事件
}
```

### 主要方法

```swift
// 设置数据
setTagData(_:viewType:)                       // 设置统一类型标签
setTagItems(_:)                               // 设置混合类型标签
addMixedTags(_:)                              // 批量添加混合标签

// 动态操作
addTagData(_:viewType:)                       // 添加单个标签
addTagItem(_:)                                // 添加标签项
removeTagAt(index:)                           // 移除指定索引标签
clearAllTags()                                // 清空所有标签

// 获取数据
getTagData()                                  // 获取标签数据
getTagItems()                                 // 获取标签项

// 间距配置便利方法
setContentInsets(_:)                          // 设置统一内边距
setContentInsets(horizontal:vertical:)        // 设置水平垂直内边距
setTagSpacing(horizontal:vertical:)           // 设置标签间距
setTagSpacing(_:)                             // 设置统一标签间距
configureSpacing(contentInsets:tagHorizontalSpacing:tagVerticalSpacing:)

// 对齐方式便利方法
setLeftAlignment()                            // 设置左对齐
setCenterAlignment()                          // 设置居中对齐
setRightAlignment()                           // 设置右对齐
configureLayout(alignment:contentInsets:tagHorizontalSpacing:tagVerticalSpacing:)
```

### 便利构造函数

```swift
// 完整配置构造函数
BRFlexTagView(
    frame: CGRect = .zero,
    contentInsets: UIEdgeInsets = ...,
    tagHorizontalSpacing: CGFloat = 10.0,
    tagVerticalSpacing: CGFloat = 10.0,
    lineAlignment: LineAlignment = .center,
    heightMode: HeightMode = .adaptive
)

// 统一间距构造函数
BRFlexTagView(
    frame: CGRect = .zero,
    contentInset: CGFloat,
    tagSpacing: CGFloat,
    lineAlignment: LineAlignment = .center,
    heightMode: HeightMode = .adaptive
)

// 水平垂直间距构造函数
BRFlexTagView(
    frame: CGRect = .zero,
    horizontalInset: CGFloat,
    verticalInset: CGFloat,
    horizontalSpacing: CGFloat,
    verticalSpacing: CGFloat,
    lineAlignment: LineAlignment = .center,
    heightMode: HeightMode = .adaptive
)
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