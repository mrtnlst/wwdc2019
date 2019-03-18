import PlaygroundSupport
import UIKit

// Gathering test data.
var albums = [Album]()
for index in 1...3 {
    if let artwork = UIImage(named: "artwork\(index).jpg") {
        let artworkColors = artwork.getColors()
        guard let primaryColor = artworkColors.primary.closestBasicColor() else {
            continue
        }
        guard let secondaryColor = artworkColors.secondary.closestBasicColor() else {
            continue
        }
        albums.append(Album(artwork: artwork, mediaID: "\(index)", colors: [primaryColor, secondaryColor]))
    }
}

// Initialising view controller.
let viewController = ViewController(sourceAlbums: albums)
PlaygroundPage.current.liveView = viewController
