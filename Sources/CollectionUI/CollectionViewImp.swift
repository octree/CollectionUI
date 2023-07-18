//
//  CollectionViewImp.swift
//  CollectionUI
//
//  Created by octree on 2023/7/17.
//
//  Copyright (c) 2023 Octree <fouljz@gmail.com>
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

import Foundation
import SwiftUI
import UIKit

struct CollectionViewImp: UIViewControllerRepresentable {
    var children: _VariadicView.Children

    func makeUIViewController(context: Context) -> ViewController {
        .init()
    }

    func updateUIViewController(_ vc: ViewController, context: Context) {
        vc.update(children: children)
    }

    final class ViewController: UIViewController {
        private var sections: [SectionInfo] = []

        private var childrenByID: [AnyHashable: _VariadicView.Children.Element] = [:]
        private lazy var dataSource: UICollectionViewDiffableDataSource = {
            let registration = UICollectionView.CellRegistration<UICollectionViewCell, AnyHashable> { [unowned self] cell, _, itemIdentifier in
                cell.contentConfiguration = UIHostingConfiguration {
                    childrenByID[itemIdentifier]
                }
                .margins(.all, 0)
            }
            return UICollectionViewDiffableDataSource<AnyHashable, AnyHashable>(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
                collectionView.dequeueConfiguredReusableCell(using: registration, for: indexPath, item: itemIdentifier)
            }
        }()

        private lazy var collectionView: UICollectionView = .init(frame: .zero, collectionViewLayout: createLayout())

        init() {
            super.init(nibName: nil, bundle: nil)
        }

        @available(*, unavailable)
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        private func createLayout() -> UICollectionViewCompositionalLayout {
            .init { [unowned self] index, env in
                sections[index].layout(env)
            }
        }

        override func viewDidLoad() {
            super.viewDidLoad()
            collectionView.frame = view.bounds
            view.addSubview(collectionView)
        }
    }
}

private extension CollectionViewImp.ViewController {
    func update(children: _VariadicView.Children) {
        childrenByID = [:]
        children.forEach { childrenByID[$0.id] = $0 }
        var itemsBySection: [AnyHashable: [AnyHashable]] = [:]
        var sections: [SectionInfo] = []
        for child in children {
            let info = child[SectionInfoTraitKey.self]
            if !sections.contains(where: { $0.id == info.id }) {
                sections.append(info)
            }
            itemsBySection[info.id, default: []].append(child.id)
        }
        self.sections = sections
        var snapshot = NSDiffableDataSourceSnapshot<AnyHashable, AnyHashable>()
        snapshot.appendSections(sections.map(\.id))
        itemsBySection.forEach {
            snapshot.appendItems($0.value, toSection: $0.key)
        }
        dataSource.apply(snapshot)
    }
}
