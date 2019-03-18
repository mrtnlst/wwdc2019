import Foundation
import UIKit

public class Album {
    public var artwork: UIImage
    public var mediaID: String
    public var colors: [Color]
    
    public init(artwork: UIImage, mediaID: String, colors: [Color]) {
        self.artwork = artwork
        self.mediaID = mediaID
        self.colors = colors
    }
    
    public func containsColors(_ selectedColors: [Color]) -> Bool {
        if selectedColors.isEmpty {
            return false
        }
        for selectedColor in selectedColors {
            if !colors.contains(where: { $0.color.isEqual(selectedColor.color) }) {
                return false
            }
        }
        return true
    }
}
