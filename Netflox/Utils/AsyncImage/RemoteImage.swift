//
//  AsyncImage.swift
//  Netflox
//
//  Created by Budia Tirado, Guillem on 3/4/21.
//

import SwiftUI

struct RemoteImage: View {
    private enum LoadState {
        case loading, success, failure
    }

    private class Loader: ObservableObject {
        var image: UIImage?
        var state = LoadState.loading

        init(url: URL?) {
            guard let url = url else {
                self.state = .success
                return
            }
            
            ImageLoader.shared.load(url) { (image) in
                if let image = image {
                    self.image = image
                    self.state = .success
                } else {
                    self.state = .failure
                }

                DispatchQueue.main.async {
                    self.objectWillChange.send()
                }
            }
        }
    }

    @StateObject private var loader: Loader
    var placeholder: Image?

    var body: some View {
        Group {
            if let image = selectImage() {
                image
                    .resizable()
            } else {
                Color.clear
            }
        }
    }

    init(url: URL?, placeholder: Image? = nil) {
        _loader = StateObject(wrappedValue: Loader(url: url))
        self.placeholder = placeholder
    }

    private func selectImage() -> Image? {
        switch loader.state {
        case .loading:
            return placeholder
        case .failure:
            return placeholder
        default:
            if let image = loader.image {
                return Image(uiImage: image)
            } else {
                return placeholder
            }
        }
    }
}
