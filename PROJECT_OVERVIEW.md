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
├── 📁 Sources/
│   └── BRFlexTagView/
│       ├── 🎯 BRTagView.swift      # 核心组件和协议定义
│       └── 📱 BRTagViewExample.swift # 示例实现和用法
└── 🧪 Tests/
    └── BRFlexTagViewTests/
        └── BRFlexTagViewTests.swift # 单元测试套件
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

### 🔧 协议驱动架构
- `BRTagItemDataProtocol` - 数据层协议
- `BRTagItemViewProtocol` - 视图层协议
- `BRTagItemViewDelegate` - 事件处理协议

## 📋 核心API

### 主要类
```swift
public class BRTagView: UIView                    // 主容器视图
public class BRTagItemView: UIView               // 基础文本标签
public class BRImageTextTagView: UIView          // 图片+文本标签
public class BRButtonTagView: UIView             // 按钮标签
```

### 数据模型
```swift
public struct BRTextTagData: BRTagItemDataProtocol      // 文本数据
public struct BRImageTextTagData: BRTagItemDataProtocol // 图片+文本数据
public struct BRButtonTagData: BRTagItemDataProtocol    // 按钮数据
public struct AnyTagItem                                // 类型擦除包装器
```

### 便利方法
```swift
public func addTextTag(_ text: String)
public func addImageTextTag(text: String, imageName: String)
public func addButtonTag(title: String, style: BRButtonTagData.Style)
public func addMixedTags(_ builder: (inout [AnyTagItem]) -> Void)
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

let tagView = BRTagView()
tagView.tags = ["Swift", "iOS", "Flexible"]
```

### 混合类型
```swift
tagView.addMixedTags { items in
    items.append(AnyTagItem.create(data: BRTextTagData(text: "文本"), viewType: BRTagItemView.self))
    items.append(AnyTagItem.create(data: BRImageTextTagData(text: "图标", imageName: "star"), viewType: BRImageTextTagView.self))
    items.append(AnyTagItem.create(data: BRButtonTagData(title: "按钮", style: .primary), viewType: BRButtonTagView.self))
}
```

### 便利方法
```swift
tagView.addTextTag("文本标签")
tagView.addImageTextTag(text: "图标标签", imageName: "heart.fill")
tagView.addButtonTag(title: "操作按钮", style: .destructive)
```

## 🎖️ 项目亮点

1. **🏆 现代化命名**: `BRFlexTagView` 体现专业性和技术感
2. **🎯 灵活架构**: 支持无限扩展的标签类型
3. **📱 iOS原生**: 完全基于UIKit，性能优异
4. **🧪 测试覆盖**: 完整的单元测试保障
5. **📖 文档完善**: 详细的使用指南和示例
6. **🔄 兼容性强**: 完全向后兼容，平滑升级

---

**BRFlexTagView** - 让标签视图更加灵活、强大、优雅！🎉 