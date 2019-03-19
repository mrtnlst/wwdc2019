import Foundation
import UIKit

public class Album {
    
    // MARK: - Properties
    
    public var artwork: UIImage
    public var mediaID: String
    public var colors: [Color]
    
    // MARK: - Life cycle
    
    public init(artwork: UIImage, mediaID: String, colors: [Color]) {
        self.artwork = artwork
        self.mediaID = mediaID
        self.colors = colors
    }
    
    // MARK: - Public
    
    // Checks whether both given colors match the artworks colors.
    
    public func containsColors(_ selectedColors: [Color]) -> Bool {
        if selectedColors.isEmpty {
            return false
        }
        for selectedColor in selectedColors {
            if !colors.contains(where: { $0.uicolor.isEqual(selectedColor.uicolor) }) {
                return false
            }
        }
        return true
    }
}
