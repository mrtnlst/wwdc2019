import PlaygroundSupport
import UIKit
import MediaPlayer

var sourceAlbums = [Album]()
if let albums = MPMediaQuery.albums().collections {
    for album in albums {
        guard let artwork = (album.representativeItem?.value(forProperty: MPMediaItemPropertyArtwork) as? MPMediaItemArtwork)?.image(at: CGSize(width: 60, height: 60)) else { continue }
        
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
        if let detailColor = artworkColors.detail.closestBasicColor() {
            colorsForAlbum.append(detailColor)
        }
        guard let mediaID = (album.representativeItem?.value(forProperty: MPMediaItemPropertyAlbumPersistentID) as? NSNumber)?.stringValue else { continue }
        
        guard let title = album.representativeItem?.value(forProperty: MPMediaItemPropertyAlbumTitle) as? String else { continue }
        
        sourceAlbums.append(Album(artwork: artwork, mediaID: mediaID, colors: colorsForAlbum))
    }
}
// Gathering test data.

//  for index in 1...10 {
//      if let artwork = UIImage(named: "artwork\(index).jpg") {
//          let artworkColors = artwork.getColors()
//          var colorsForAlbum = [Color]()
//          if let primaryColor = artworkColors.primary.closestBasicColor() {
//              colorsForAlbum.append(primaryColor)
//          }
//          if let secondaryColor = artworkColors.secondary.closestBasicColor() {
//              colorsForAlbum.append(secondaryColor)
//          }
//          if let backgroundColor = artworkColors.background.closestBasicColor() {
//              colorsForAlbum.append(backgroundColor)
//          }
//          if let detailColor = artworkColors.detail.closestBasicColor() {
//              colorsForAlbum.append(detailColor)
//          }
//          albums.append(Album(artwork: artwork, mediaID: "\(index)", colors: colorsForAlbum))
//      }
//  }

// Initialising view controller.
let viewController = ViewController(sourceAlbums: sourceAlbums)
PlaygroundPage.current.liveView = viewController
