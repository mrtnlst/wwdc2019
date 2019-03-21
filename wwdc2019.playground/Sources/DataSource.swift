import Foundation
import UIKit
import MediaPlayer

public enum DeviceContext {
    case iOS
    case macOS
}

public class DataSource {
    
    public var sourceAlbums = [Album]()
    private var context: DeviceContext
    
    public init(context: DeviceContext) {
        self.context = context
    }
    
    public func getData(completion: () -> Void) {
        switch context {
        case .iOS:
            getiOSData()
            completion()
        case .macOS:
            getmacOSData()
            completion()
        }
    }
    
    func getmacOSData() {
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
    }
    
    func getiOSData() {
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
//                if let detailColor = artworkColors.detail.closestBasicColor() {
//                    colorsForAlbum.append(detailColor)
//                }
                guard let mediaID = (album.representativeItem?.value(forProperty: MPMediaItemPropertyAlbumPersistentID) as? NSNumber)?.stringValue else { continue }
                
                guard let title = album.representativeItem?.value(forProperty: MPMediaItemPropertyAlbumTitle) as? String else { continue }
                
                sourceAlbums.append(Album(artwork: artwork, mediaID: mediaID, title: title, colors: colorsForAlbum))
                
                if sourceAlbums.count == 30 {
                    break
                }
            }
        }
    }
}
