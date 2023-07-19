//
//  ContentView.swift
//  CollectionUI
//
//  Created by octree on 2023/7/19.
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

import CollectionUI
import SwiftUI
import UIKit

struct ContentView: View {
    @State private var emojis1: [String] = ["😭", "😂", "🥺", "🤣", "❤️", "✨"]
    @State private var emojis2: [String] = ["🥹", "🩷", "👀", "🗓", "🏅"]
    @State private var queue: [String] = ["🥰", "🫠", "🙃", "🤡", "🚀"]

    var body: some View {
        VStack {
            HStack {
                Button("Insert 1") {
                    withAnimation {
                        guard !queue.isEmpty else { return }
                        emojis1.insert(queue.removeFirst(), at: 0)
                    }
                }
                .buttonStyle(.borderedProminent)

                Button("Insert 2") {
                    withAnimation {
                        guard !queue.isEmpty else { return }
                        emojis2.insert(queue.removeFirst(), at: 0)
                    }
                }
                .buttonStyle(.borderedProminent)
            }
            CollectionView {
                CollectionSection(id: 0, layout: orthogonalSection()) {
                    ForEach(emojis1, id: \.self) { text in
                        Text(text)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                    }
                }

                CollectionSection(id: 1, layout: listSection(environment:)) {
                    ForEach(emojis2, id: \.self) { text in
                        HStack {
                            Text(text)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(Color(white: 0.85))
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(.white)
                    }
                }
            }
        }
        .background(Color(white: 0.96))
    }

    func orthogonalSection() -> NSCollectionLayoutSection {
        let size = NSCollectionLayoutSize(widthDimension: .absolute(120), heightDimension: .absolute(80))
        let item = NSCollectionLayoutItem(layoutSize: size)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: size,
                                                       subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = 16
        section.contentInsets = NSDirectionalEdgeInsets(top: 16,
                                                        leading: 16,
                                                        bottom: 16,
                                                        trailing: 16)
        return section
    }

    private func listSection(environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        var configuration = UICollectionLayoutListConfiguration(appearance: .plain)
        configuration.showsSeparators = true
        configuration.backgroundColor = .white
        return NSCollectionLayoutSection.list(using: configuration, layoutEnvironment: environment)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
