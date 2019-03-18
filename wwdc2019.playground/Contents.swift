import PlaygroundSupport
import UIKit

// Gathering test data.
var albums = [Album]()
for index in 1...4 {
    if let artwork = UIImage(named: "artwork\(index).jpg") {
        let artworkColors = artwork.getColors()
        var colorsForAlbum = [Color]()
        if let primaryColor = artworkColors.primary.closestBasicColor() {
            colorsForAlbum.append(primaryColor)
        }
        if let secondaryColor = artworkColors.secondary.closestBasicColor() {
            colorsForAlbum.append(secondaryColor)
        }
        if let backgroundColor = artworkColors.background.closestBasicColor() {
            colorsForAlbum.append(backgroundColor)
        }
//        if let detailColor = artworkColors.detail.closestBasicColor() {
//            colorsForAlbum.append(detailColor)
//        }
        albums.append(Album(artwork: artwork, mediaID: "\(index)", colors: colorsForAlbum))
    }
}

// Initialising view controller.
let viewController = ViewController(sourceAlbums: albums)
PlaygroundPage.current.liveView = viewController
