//
//  ViewController.swift
//  TagListView
//
//

import UIKit

class ViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "TagView Demo"
        
        // 添加导航按钮来切换到 TagCollectionView 演示
        // navigationItem.rightBarButtonItem = UIBarButtonItem(
        //     title: "CollectionView Demo",
        //     style: .plain,
        //     target: self,
        //     action: #selector(showCollectionViewDemo)
        // )
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Custom Demo",
            style: .plain,
            target: self,
            action: #selector(selectedCustomTagView)
        )
        let sss = UIStackView()
        sss.axis = .horizontal //.vertical
        
        let tagView = BRFlexTagView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 0))
        tagView.tags = ["Swift", "iOS Development", "Auto Layout e", "UIKiteyriryqryqw", "Very long tag that might wrap to multiple lines Very long tag that might wrap to multiple lines", "Short", "Swift", "iOS Development", "Auto Layout e", "UIKiteyriryqryqw", "Very long tag that might wrap to multiple lines Very long tag that might wrap to multiple lines", "Short","Swift", "iOS Development", "Auto Layout e", "UIKiteyriryqryqw", "Very long tag that might wrap to multiple lines Very long tag that might wrap to multiple lines", "Short", "Swift", "iOS Development", "Auto Layout e", "UIKiteyriryqryqw", "Very long tag that might wrap to multiple lines Very long tag that might wrap to multiple lines", "Short", "Swift", "iOS Development", "Auto Layout e", "UIKiteyriryqryqw", "Very long tag that might wrap to multiple lines Very long tag that might wrap to multiple lines", "Short","Swift", "iOS Development", "Auto Layout e", "UIKiteyriryqryqw", "Very long tag that might wrap to multiple lines Very long tag that might wrap to multiple lines", "Short"]
        self.view.addSubview(tagView)
//        tagView.heightMode = .fixed(200)
        tagView.heightMode = .adaptive  // 使用 adaptive 模式
        tagView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tagView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            tagView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            tagView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            tagView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0)
//            tagView.heightAnchor.constraint(equalToConstant: 200)  // 设置最大高度为200，超出时会自动滚动
        ])
        
        // Do any additional setup after loading the view.
    }
    
    @objc private func showCollectionViewDemo() {
        let collectionViewController = TagCollectionViewController()
        navigationController?.pushViewController(collectionViewController, animated: true)
    }

    @objc private func selectedCustomTagView() {
        let vc = BRTagViewExampleViewController()
        navigationController?.pushViewController(vc, animated: true)

    }
}
