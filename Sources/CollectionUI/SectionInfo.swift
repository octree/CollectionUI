//
//  SectionInfo.swift
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
import UIKit

class SectionInfo: Equatable {
    var id: AnyHashable
    var layout: (NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection

    init(id: AnyHashable, layout: ((NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection)?) {
        self.id = id
        self.layout = layout ?? { _ in .default }
    }

    init(id: AnyHashable, layout: NSCollectionLayoutSection?) {
        self.id = id
        self.layout = { _ in layout ?? .default }
    }

    static func == (lhs: SectionInfo, rhs: SectionInfo) -> Bool {
        lhs.id == rhs.id && weakEqual(lhs.layout, rhs.layout)
    }
}

@inlinable
func weakEqual<Value>(_ lhs: Value, _ rhs: Value) -> Bool {
    withUnsafePointer(to: lhs) { lhs in
        withUnsafePointer(to: rhs) { rhs in
            memcmp(UnsafeRawPointer(lhs), UnsafeRawPointer(rhs), MemoryLayout<Value>.size) == 0
        }
    }
}

extension NSCollectionLayoutSection {
    static let `default`: NSCollectionLayoutSection = {
        let size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(10))
        let group: NSCollectionLayoutGroup = .horizontal(layoutSize: size, subitems: [.init(layoutSize: size)])
        return NSCollectionLayoutSection(group: group)
    }()
}
