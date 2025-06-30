//
//  InitializerUsageExample.swift
//  TagListView
//
//  Created by Assistant
//

import UIKit

class InitializerUsageExample: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "便利构造函数示例"
        
        setupExamples()
    }
    
    private func setupExamples() {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
        let examples = createExamples()
        layoutExamples(examples, in: contentView)
    }
    
    private func createExamples() -> [(title: String, tagView: BRFlexTagView)] {
        let sampleTags = ["Swift", "iOS开发", "UIKit", "自动布局", "标签视图", "开源项目", "UI组件"]
        
        // 示例1：基础构造
        let basicTagView = BRFlexTagView()
        basicTagView.tags = sampleTags
        
        // 示例2：完整配置构造
        let fullConfigTagView = BRFlexTagView(
            contentInsets: UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16),
            tagHorizontalSpacing: 8,
            tagVerticalSpacing: 12,
            lineAlignment: .center,
            heightMode: .adaptive
        )
        fullConfigTagView.tags = sampleTags
        fullConfigTagView.tagBackgroundColor = .systemBlue
        fullConfigTagView.tagTextColor = .white
        
        // 示例3：统一间距构造（左对齐）
        let uniformSpacingTagView = BRFlexTagView(
            contentInset: 12,
            tagSpacing: 6,
            lineAlignment: .left
        )
        uniformSpacingTagView.tags = sampleTags
        uniformSpacingTagView.tagBackgroundColor = .systemGreen
        uniformSpacingTagView.tagTextColor = .white
        
        // 示例4：水平垂直间距构造（右对齐）
        let hvSpacingTagView = BRFlexTagView(
            horizontalInset: 20,
            verticalInset: 10,
            horizontalSpacing: 10,
            verticalSpacing: 8,
            lineAlignment: .right
        )
        hvSpacingTagView.tags = sampleTags
        hvSpacingTagView.tagBackgroundColor = .systemOrange
        hvSpacingTagView.tagTextColor = .white
        
        // 示例5：固定高度模式
        let fixedHeightTagView = BRFlexTagView(
            contentInsets: UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16),
            tagHorizontalSpacing: 8,
            tagVerticalSpacing: 6,
            lineAlignment: .center,
            heightMode: .fixed(120)
        )
        fixedHeightTagView.tags = sampleTags
        fixedHeightTagView.tagBackgroundColor = .systemPurple
        fixedHeightTagView.tagTextColor = .white
        
        return [
            ("基础构造 - 默认设置", basicTagView),
            ("完整配置构造 - 居中对齐", fullConfigTagView),
            ("统一间距构造 - 左对齐", uniformSpacingTagView),
            ("水平垂直间距构造 - 右对齐", hvSpacingTagView),
            ("固定高度模式 - 120pt", fixedHeightTagView)
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
}

// MARK: - 使用代码示例注释

/*
 
 // 1. 基础构造 - 使用默认设置
 let tagView1 = BRFlexTagView()
 tagView1.tags = ["标签1", "标签2", "标签3"]
 
 // 2. 完整配置构造 - 指定所有参数
 let tagView2 = BRFlexTagView(
     frame: CGRect(x: 0, y: 0, width: 300, height: 100),
     contentInsets: UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16),
     tagHorizontalSpacing: 8,
     tagVerticalSpacing: 12,
     lineAlignment: .center,
     heightMode: .adaptive
 )
 tagView2.tags = ["标签1", "标签2", "标签3"]
 
 // 3. 统一间距构造 - 快速设置相同的内边距和标签间距
 let tagView3 = BRFlexTagView(
     contentInset: 16,        // 所有方向的内边距都是16
     tagSpacing: 8,           // 水平和垂直间距都是8
     lineAlignment: .left     // 左对齐
 )
 tagView3.tags = ["标签1", "标签2", "标签3"]
 
 // 4. 水平垂直间距构造 - 分别设置水平和垂直间距
 let tagView4 = BRFlexTagView(
     horizontalInset: 20,     // 左右内边距
     verticalInset: 10,       // 上下内边距
     horizontalSpacing: 10,   // 标签水平间距
     verticalSpacing: 8,      // 行垂直间距
     lineAlignment: .right,   // 右对齐
     heightMode: .fixed(120)  // 固定高度120pt
 )
 tagView4.tags = ["标签1", "标签2", "标签3"]
 
 // 5. 运行时修改配置
 tagView1.lineAlignment = .center
 tagView1.setContentInsets(12)
 tagView1.setTagSpacing(6)
 
 */ 