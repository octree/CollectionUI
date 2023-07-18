# CollectionUI

**CollectionUI** brings **UICollectionView** and **ComposableLayout** to **SwiftUI**.



## Usage



```swift
struct ContentView : View {
  @State var data: [String] = ["hello", "world"]
  var body: some View {
    CollectionView {
      CollectionSection(id: 0) {
        ForEach(data, id:\.self) {
          Text($0)
          	.frame(maxWidth: .infinity)
          	.frame(height: 66)
        }
      }
    }
  }
}
```



## License

**CollectionUI** is licensed under the MIT license.
