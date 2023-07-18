//
//  CollectionSection.swift
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

public struct CollectionSection<Content: View>: View {
    let tree: _VariadicView.Tree<SectionLayout, Content>

    public init(id: AnyHashable,
                layout: ((NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection)? = nil,
                @ViewBuilder content: () -> Content) {
        tree = .init(SectionLayout(info: .init(id: id, layout: layout))) { content() }
    }

    @_disfavoredOverload
    public init(id: AnyHashable,
                layout: NSCollectionLayoutSection? = nil,
                @ViewBuilder content: () -> Content) {
        tree = .init(SectionLayout(info: .init(id: id, layout: layout))) { content() }
    }

    public var body: some View {
        tree
    }
}

struct SectionLayout: _VariadicView.MultiViewRoot {
    let info: SectionInfo
    func body(children: _VariadicView.Children) -> some View {
        children.sectionInfo(info)
    }
}
