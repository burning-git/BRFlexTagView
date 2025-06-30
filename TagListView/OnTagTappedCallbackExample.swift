//
//  OnTagTappedCallbackExample.swift
//  TagListView
//
//  Created by Assistant
//

import UIKit

/// 演示新的 onTagTapped 回调功能的示例
class OnTagTappedCallbackExample: UIViewController {
    
    private var logTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "onTagTapped 回调示例"
        
        setupUI()
        setupExamples()
    }
    
    private func setupUI() {
        // 创建日志输出区域
        logTextView = UITextView()
        logTextView.isEditable = false
        logTextView.font = UIFont.monospacedSystemFont(ofSize: 12, weight: .regular)
        logTextView.backgroundColor = .systemGray6
        logTextView.layer.cornerRadius = 8
        logTextView.translatesAutoresizingMaskIntoConstraints = false
        
        // 添加清除按钮
        let clearButton = UIButton(type: .system)
        clearButton.setTitle("清除日志", for: .normal)
        clearButton.addTarget(self, action: #selector(clearLog), for: .touchUpInside)
        clearButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(logTextView)
        view.addSubview(clearButton)
        
        NSLayoutConstraint.activate([
            clearButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            clearButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            logTextView.topAnchor.constraint(equalTo: clearButton.bottomAnchor, constant: 8),
            logTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            logTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            logTextView.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    private func setupExamples() {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: logTextView.bottomAnchor, constant: 16),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
        let examples = createTagExamples()
        layoutExamples(examples, in: contentView)
    }
    
    private func createTagExamples() -> [(title: String, tagView: BRFlexTagView)] {
        // 示例1：文本标签 - 展示基础回调功能
        let textTagView = BRFlexTagView(
            contentInsets: UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16),
            tagHorizontalSpacing: 8,
            tagVerticalSpacing: 8,
            lineAlignment: .center
        )
        textTagView.tags = ["Swift", "iOS", "UIKit", "Auto Layout", "闭包回调"]
        textTagView.tagBackgroundColor = .systemBlue
        textTagView.tagTextColor = .white
        textTagView.onTagTapped = { [weak self] index, model, tagView in
            self?.logCallback(
                title: "文本标签点击",
                index: index,
                model: model,
                tagView: tagView
            )
        }
        
        // 示例2：混合类型标签 - 展示不同数据类型的回调
        let mixedTagView = BRFlexTagView(
            contentInset: 12,
            tagSpacing: 6,
            lineAlignment: .left
        )
        mixedTagView.addMixedTags { items in
            // 添加文本标签
            items.append(AnyFlexTagItem.create(
                data: BRFlexTextTagData(text: "文本标签"),
                viewType: BRFlexTagItemView.self
            ))
            
            // 添加图片+文本标签
            items.append(AnyFlexTagItem.create(
                data: BRFlexImageTextTagData(text: "图标", imageName: "star.fill"),
                viewType: BRFlexImageTextTagView.self
            ))
            
            // 添加按钮标签
            items.append(AnyFlexTagItem.create(
                data: BRFlexButtonTagData(title: "按钮", style: .primary),
                viewType: BRFlexButtonTagView.self
            ))
            
            // 再添加一些文本标签
            items.append(AnyFlexTagItem.create(
                data: BRFlexTextTagData(text: "混合类型"),
                viewType: BRFlexTagItemView.self
            ))
        }
        mixedTagView.onTagTapped = { [weak self] index, model, tagView in
            self?.logCallback(
                title: "混合标签点击",
                index: index,
                model: model,
                tagView: tagView
            )
        }
        
        // 示例3：动态标签 - 展示动态操作和回调
        let dynamicTagView = BRFlexTagView(
            horizontalInset: 16,
            verticalInset: 10,
            horizontalSpacing: 10,
            verticalSpacing: 6,
            lineAlignment: .right
        )
        dynamicTagView.addTagData(
            BRFlexTextTagData(text: "可删除1"),
            viewType: BRFlexTagItemView.self
        )
        dynamicTagView.addTagData(
            BRFlexTextTagData(text: "可删除2"),
            viewType: BRFlexTagItemView.self
        )
        dynamicTagView.addTagData(
            BRFlexTextTagData(text: "可删除3"),
            viewType: BRFlexTagItemView.self
        )
        dynamicTagView.tagBackgroundColor = .systemRed
        dynamicTagView.tagTextColor = .white
        dynamicTagView.onTagTapped = { [weak self, weak dynamicTagView] index, model, tagView in
            self?.logCallback(
                title: "动态标签点击 (将被删除)",
                index: index,
                model: model,
                tagView: tagView
            )
            
            // 延迟0.5秒后删除被点击的标签
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                dynamicTagView?.removeTagAt(index: index)
                self?.appendLog("已删除索引 \(index) 的标签")
            }
        }
        
        return [
            ("基础文本标签回调", textTagView),
            ("混合类型标签回调", mixedTagView),
            ("动态删除标签回调", dynamicTagView)
        ]
    }
    
    private func layoutExamples(_ examples: [(title: String, tagView: BRFlexTagView)], in containerView: UIView) {
        var previousView: UIView?
        
        for (index, example) in examples.enumerated() {
            // 创建标题标签
            let titleLabel = UILabel()
            titleLabel.text = "\(index + 1). \(example.title)"
            titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
            titleLabel.textColor = .label
            titleLabel.numberOfLines = 0
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            containerView.addSubview(titleLabel)
            
            // 添加标签视图
            example.tagView.translatesAutoresizingMaskIntoConstraints = false
            example.tagView.backgroundColor = UIColor.systemGray6
            example.tagView.layer.cornerRadius = 8
            containerView.addSubview(example.tagView)
            
            // 设置约束
            NSLayoutConstraint.activate([
                titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
                titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
                
                example.tagView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
                example.tagView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16)
            ])
            
            if let previous = previousView {
                NSLayoutConstraint.activate([
                    titleLabel.topAnchor.constraint(equalTo: previous.bottomAnchor, constant: 24)
                ])
            } else {
                NSLayoutConstraint.activate([
                    titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16)
                ])
            }
            
            NSLayoutConstraint.activate([
                example.tagView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8)
            ])
            
            previousView = example.tagView
            
            // 为最后一个示例添加底部约束
            if index == examples.count - 1 {
                NSLayoutConstraint.activate([
                    example.tagView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -24)
                ])
            }
        }
    }
    
    @objc private func clearLog() {
        logTextView.text = ""
    }
    
    private func appendLog(_ message: String) {
        let timestamp = DateFormatter().string(from: Date())
        let logMessage = "[\(timestamp)] \(message)\n"
        
        DispatchQueue.main.async { [weak self] in
            self?.logTextView.text += logMessage
            
            // 自动滚动到底部
            let bottom = NSMakeRange(self?.logTextView.text.count ?? 0, 0)
            self?.logTextView.scrollRangeToVisible(bottom)
        }
    }
    
    private func logCallback(title: String, index: Int, model: any BRFlexTagItemDataProtocol, tagView: BRFlexTagView) {
        var logMessage = "🔔 \(title)\n"
        logMessage += "   索引: \(index)\n"
        logMessage += "   数据类型: \(type(of: model))\n"
        logMessage += "   数据内容: \(model)\n"
        logMessage += "   标签视图: \(tagView.frame)\n"
        logMessage += "   标签总数: \(tagView.getTagItems().count)"
        
        appendLog(logMessage)
    }
}

// MARK: - 使用指南注释

/*
 
## onTagTapped 回调增强功能使用指南

### 新的回调签名
```swift
tagView.onTagTapped = { index, model, tagView in
    // index: 被点击标签的索引
    // model: 标签的数据模型 (遵循 BRFlexTagItemDataProtocol)
    // tagView: 标签视图本身 (BRFlexTagView)
}
```

### 参数说明

1. **index (Int)**: 
   - 被点击标签在标签数组中的索引位置
   - 可用于标识具体哪个标签被点击
   - 可用于删除、更新指定位置的标签

2. **model (any BRFlexTagItemDataProtocol)**:
   - 标签的原始数据模型
   - 包含标签的所有业务数据
   - 可以转换为具体的数据类型以获取详细信息

3. **tagView (BRFlexTagView)**:
   - 标签视图本身的引用
   - 可用于获取视图的状态信息
   - 可用于动态操作标签集合

### 实际应用场景

#### 1. 基础点击处理
```swift
tagView.onTagTapped = { index, model, tagView in
    print("点击了第 \(index) 个标签")
    print("标签数据: \(model)")
}
```

#### 2. 根据数据类型处理不同逻辑
```swift
tagView.onTagTapped = { index, model, tagView in
    switch model {
    case let textData as BRFlexTextTagData:
        print("点击了文本标签: \(textData.text)")
    case let imageTextData as BRFlexImageTextTagData:
        print("点击了图片文本标签: \(imageTextData.text)")
    case let buttonData as BRFlexButtonTagData:
        print("点击了按钮标签: \(buttonData.title)")
    default:
        print("点击了其他类型标签")
    }
}
```

#### 3. 动态删除标签
```swift
tagView.onTagTapped = { index, model, tagView in
    // 删除被点击的标签
    tagView.removeTagAt(index: index)
    print("已删除标签: \(model)")
}
```

#### 4. 获取视图状态信息
```swift
tagView.onTagTapped = { index, model, tagView in
    print("标签视图尺寸: \(tagView.frame)")
    print("当前标签总数: \(tagView.getTagItems().count)")
    print("对齐方式: \(tagView.lineAlignment)")
}
```

#### 5. 复杂业务逻辑处理
```swift
tagView.onTagTapped = { [weak self] index, model, tagView in
    // 记录用户行为
    self?.analyticsService.trackTagTap(index: index, data: model)
    
    // 根据业务逻辑处理
    if let textData = model as? BRFlexTextTagData {
        self?.handleTextTagSelection(textData.text)
    }
    
    // 更新UI状态
    self?.updateSelectionState(selectedIndex: index)
}
```

### 向后兼容性
旧的回调签名已不再支持，需要更新为新的三参数版本：

```swift
// ❌ 旧版本 (不再支持)
tagView.onTagTapped = { index in
    print("点击了索引 \(index)")
}

// ✅ 新版本 (推荐)
tagView.onTagTapped = { index, model, tagView in
    print("点击了索引 \(index), 数据: \(model)")
}
```

*/ 