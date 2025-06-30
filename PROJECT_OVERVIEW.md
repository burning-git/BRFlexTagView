# 🎯 BRFlexTagView - 项目概览

## 📦 Package 信息

- **名称**: BRFlexTagView
- **版本**: 1.0.0
- **平台**: iOS 13.0+
- **语言**: Swift 5.9+
- **许可证**: MIT

## 🏗️ 项目结构

```
BRFlexTagView/
├── 📄 Package.swift                 # Swift Package Manager 配置
├── 📖 README.md                     # 完整使用文档
├── 📋 USAGE_GUIDE.md               # 快速使用指南
├── 📝 CHANGELOG.md                 # 更新日志
├── 📄 LICENSE                      # MIT 许可证
├── 🖼️ introImgs/                    # 效果展示图片
│   ├── lineAlignment_left.jpg      # 左对齐效果图
│   ├── lineAlignment_center.jpg    # 居中对齐效果图
│   └── lineAlignment_right.jpg     # 右对齐效果图
├── 📁 Sources/
│   └── BRFlexTagView/
│       ├── 🎯 BRFlexTagView.swift      # 核心组件和协议定义
│       ├── 📊 BRFlexTagData.swift      # 标签数据模型
│       ├── 🏷️ BRFlexTagItemView.swift  # 标签视图实现
│       └── 📋 BRFlexTagProtocols.swift # 协议定义
└── 🧪 Tests/
    └── BRFlexTagViewTests/
        └── BRTagViewTests.swift     # 单元测试套件
```

## 🚀 核心特性

### ✨ 混合类型标签支持
- 在同一视图中支持不同类型的标签
- 文本、图片+文本、按钮等多种内置类型
- 完全可扩展的协议架构

### 🎨 高度可定制
- 自适应高度和固定高度模式
- 可自定义间距、圆角、字体、颜色
- 流式布局，自动换行
- **新增**: 行对齐方式（左对齐、居中对齐、右对齐）
- **新增**: 便利构造函数，支持初始化时直接配置

### 🔧 协议驱动架构
- `BRFlexTagItemDataProtocol` - 数据层协议
- `BRFlexTagItemViewProtocol` - 视图层协议
- `BRFlexTagItemViewDelegate` - 事件处理协议

### 🎯 增强功能
- **增强的回调**: `onTagTapped` 提供索引、数据模型、视图实例三个参数
- **精确间距控制**: 支持水平间距、垂直间距、内容内边距的独立配置
- **便利方法**: 丰富的配置便利方法，简化常用操作
- **效果展示**: 提供三种对齐方式的可视化效果图

## 📋 核心API

### 主要类
```swift
public class BRFlexTagView: UIView               // 主容器视图
public class BRFlexTagItemView: UIView           // 基础文本标签
public class BRFlexImageTextTagView: UIView      // 图片+文本标签
public class BRFlexButtonTagView: UIView         // 按钮标签
```

### 数据模型
```swift
public struct BRFlexTextTagData: BRFlexTagItemDataProtocol      // 文本数据
public struct BRFlexImageTextTagData: BRFlexTagItemDataProtocol // 图片+文本数据
public struct BRFlexButtonTagData: BRFlexTagItemDataProtocol    // 按钮数据
public struct AnyFlexTagItem                                    // 类型擦除包装器
```

### 对齐方式枚举
```swift
public enum LineAlignment {
    case left     // 左对齐
    case center   // 居中对齐
    case right    // 右对齐
}
```

### 高度模式枚举
```swift
public enum HeightMode {
    case adaptive              // 自适应高度
    case fixed(CGFloat)        // 固定高度
}
```

### 便利方法
```swift
// 添加标签
public func addTextTag(_ text: String)
public func addImageTextTag(text: String, imageName: String)
public func addButtonTag(title: String, style: BRFlexButtonTagData.Style)
public func addMixedTags(_ builder: (inout [AnyFlexTagItem]) -> Void)

// 间距配置
public func setContentInsets(_ inset: CGFloat)
public func setContentInsets(horizontal: CGFloat, vertical: CGFloat)
public func setTagSpacing(horizontal: CGFloat, vertical: CGFloat)
public func setTagSpacing(_ spacing: CGFloat)

// 对齐方式配置
public func setLeftAlignment()
public func setCenterAlignment()
public func setRightAlignment()

// 批量配置
public func configureSpacing(contentInsets:tagHorizontalSpacing:tagVerticalSpacing:)
public func configureLayout(alignment:contentInsets:tagHorizontalSpacing:tagVerticalSpacing:)
```

### 便利构造函数
```swift
// 完整配置构造
public init(contentInsets:tagHorizontalSpacing:tagVerticalSpacing:lineAlignment:heightMode:)

// 统一间距构造  
public init(contentInset:tagSpacing:lineAlignment:heightMode:)

// 水平垂直间距构造
public init(horizontalInset:verticalInset:horizontalSpacing:verticalSpacing:lineAlignment:heightMode:)
```

## 💡 设计理念

### 🎯 "Flex" 的含义
- **Flexible**: 灵活的类型支持
- **Flow**: 流式布局体验
- **Extensible**: 可扩展的架构
- **Efficient**: 高效的性能

### 🔄 向后兼容
保持原有 `BRTagView` 所有API完全不变，只是Package名称升级为更现代化的 `BRFlexTagView`。

## 🎨 使用示例

### 基础用法
```swift
import BRFlexTagView

let tagView = BRFlexTagView()
tagView.tags = ["Swift", "iOS", "Flexible"]
tagView.lineAlignment = .center    // 设置居中对齐
```

### 便利构造函数使用
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

### 混合类型
```swift
tagView.addMixedTags { items in
    items.append(AnyFlexTagItem.create(data: BRFlexTextTagData(text: "文本"), viewType: BRFlexTagItemView.self))
    items.append(AnyFlexTagItem.create(data: BRFlexImageTextTagData(text: "图标", imageName: "star"), viewType: BRFlexImageTextTagView.self))
    items.append(AnyFlexTagItem.create(data: BRFlexButtonTagData(title: "按钮", style: .primary), viewType: BRFlexButtonTagView.self))
}
```

### 便利方法
```swift
tagView.addTextTag("文本标签")
tagView.addImageTextTag(text: "图标标签", imageName: "heart.fill")
tagView.addButtonTag(title: "操作按钮", style: .destructive)
```

### 增强的点击回调
```swift
tagView.onTagTapped = { index, model, tagView in
    print("点击了第 \(index) 个标签")
    print("标签数据: \(model)")
    print("标签视图: \(tagView)")
    
    // 根据数据类型进行不同处理
    if let textData = model as? BRFlexTextTagData {
        print("文本标签: \(textData.text)")
    }
}
```

### 对齐方式配置
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

## 🎖️ 项目亮点

1. **🏆 现代化命名**: `BRFlexTagView` 体现专业性和技术感
2. **🎯 灵活架构**: 支持无限扩展的标签类型
3. **📐 行对齐支持**: 三种对齐方式（左对齐、居中对齐、右对齐）
4. **🎨 便利构造**: 丰富的构造函数，支持初始化时直接配置
5. **💡 增强回调**: onTagTapped 提供索引、数据模型、视图实例三个参数
6. **🎛️ 精确间距**: 支持水平间距、垂直间距、内容内边距的独立配置
7. **🖼️ 效果展示**: 提供可视化的对齐方式效果图
8. **📱 iOS原生**: 完全基于UIKit，性能优异
9. **🧪 测试覆盖**: 完整的单元测试保障
10. **📖 文档完善**: 详细的使用指南和示例
11. **🔄 兼容性强**: 完全向后兼容，平滑升级

---

**BRFlexTagView** - 让标签视图更加灵活、强大、优雅！🎉 