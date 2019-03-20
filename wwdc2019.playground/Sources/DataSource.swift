import Foundation
import UIKit
import MediaPlayer

public enum DeviceContext {
    case iOS
    case macOS
}

public class DataSource {
    
    public static func getAlbumData(for context: DeviceContext) -> [Album] {
        switch context {
        case .iOS:
            return getiOSData()
        case .macOS:
            return getmacOSData()
        }
    }
    
    static func getmacOSData() -> [Album] {
        var sourceAlbums = [Album]()
        
        for index in 1...10 {
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
              if let detailColor = artworkColors.detail.closestBasicColor() {
                  colorsForAlbum.append(detailColor)
              }
            let title = "Test \(index)"
            sourceAlbums.append(Album(artwork: artwork, mediaID: "\(index)", title: title, colors: colorsForAlbum))
          }
        }
        return sourceAlbums
    }
    
    static func getiOSData() -> [Album] {
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
                
                sourceAlbums.append(Album(artwork: artwork, mediaID: mediaID, title: title, colors: colorsForAlbum))
                
                if sourceAlbums.count == 20 {
                    break
                }
            }
        }
        return sourceAlbums
    }
}
