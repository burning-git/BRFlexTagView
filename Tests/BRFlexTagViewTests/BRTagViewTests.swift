import XCTest
@testable import BRFlexTagView

final class BRFlexTagViewTests: XCTestCase {
    
    var tagView: BRFlexTagView!
    
    override func setUpWithError() throws {
        tagView = BRFlexTagView()
    }
    
    override func tearDownWithError() throws {
        tagView = nil
    }
    
    func testBasicTextTags() throws {
        // 测试基础文本标签功能
        let testTags = ["Swift", "iOS", "UIKit"]
        tagView.tags = testTags
        
        let tagData = tagView.getTagData()
        XCTAssertEqual(tagData.count, testTags.count)
        
        for (index, data) in tagData.enumerated() {
            if let textData = data as? BRFlexTextTagData {
                XCTAssertEqual(textData.text, testTags[index])
            } else {
                XCTFail("Expected BRFlexTextTagData")
            }
        }
    }
    
    func testMixedTags() throws {
        // 测试混合类型标签
        tagView.addMixedTags { items in
            items.append(AnyFlexTagItem.create(data: BRFlexTextTagData(text: "文本"), viewType: BRFlexTagItemView.self))
            items.append(AnyFlexTagItem.create(data: BRFlexImageTextTagData(text: "图标", imageName: "star"), viewType: BRFlexImageTextTagView.self))
            items.append(AnyFlexTagItem.create(data: BRFlexButtonTagData(title: "按钮", style: .primary), viewType: BRFlexButtonTagView.self))
        }
        
        let tagData = tagView.getTagData()
        XCTAssertEqual(tagData.count, 3)
        
        XCTAssertTrue(tagData[0] is BRFlexTextTagData)
        XCTAssertTrue(tagData[1] is BRFlexImageTextTagData)
        XCTAssertTrue(tagData[2] is BRFlexButtonTagData)
    }
    
    func testConvenienceMethods() throws {
        // 测试便利方法
        tagView.addTextTag("文本标签")
        tagView.addImageTextTag(text: "图片标签", imageName: "star")
        tagView.addButtonTag(title: "按钮标签", style: .primary)
        
        let tagData = tagView.getTagData()
        XCTAssertEqual(tagData.count, 3)
    }
    
    func testTagManipulation() throws {
        // 测试标签操作
        tagView.addTextTag("标签1")
        tagView.addTextTag("标签2")
        tagView.addTextTag("标签3")
        
        XCTAssertEqual(tagView.getTagData().count, 3)
        
        // 移除标签
        tagView.removeTagAt(index: 1)
        XCTAssertEqual(tagView.getTagData().count, 2)
        
        // 清空标签
        tagView.clearAllTags()
        XCTAssertEqual(tagView.getTagData().count, 0)
    }
    
    func testHeightModes() throws {
        // 测试高度模式
        tagView.heightMode = .adaptive
        XCTAssertEqual(tagView.heightMode, .adaptive)
        
        tagView.heightMode = .fixed(100)
        if case .fixed(let height) = tagView.heightMode {
            XCTAssertEqual(height, 100)
        } else {
            XCTFail("Expected fixed height mode")
        }
    }
    
    func testCustomProperties() throws {
        // 测试自定义属性
        tagView.tagMargin = 15.0
        tagView.tagPadding = 12.0
        tagView.lineSpacing = 8.0
        tagView.tagCornerRadius = 6.0
        
        XCTAssertEqual(tagView.tagMargin, 15.0)
        XCTAssertEqual(tagView.tagPadding, 12.0)
        XCTAssertEqual(tagView.lineSpacing, 8.0)
        XCTAssertEqual(tagView.tagCornerRadius, 6.0)
    }
} 