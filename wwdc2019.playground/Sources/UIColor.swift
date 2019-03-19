import Foundation
import UIKit

public extension UIColor {
    func closestBasicColor() -> Color? {
        var r1: CGFloat = 0
        var g1: CGFloat = 0
        var b1: CGFloat = 0
        var a1: CGFloat = 0
        self.getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
  
        var shortestDistance: CGFloat = 0
        var indexOfColor: Int = 0
        for (index, color) in basicColors.enumerated() {
            var r2: CGFloat = 0
            var g2: CGFloat = 0
            var b2: CGFloat = 0
            var a2: CGFloat = 0
            
            color.uicolor.getRed(&r2, green: &g2, blue: &b2, alpha: &a2)

            let distance: CGFloat = sqrt(((r2 - r1) * (r2 - r1)) + ((g2 - g1) * (g2 - g1)) + ((b2 - b1) * (b2 - b1)));

            if shortestDistance == 0 {
                shortestDistance = distance
                indexOfColor = index
            }
            else if distance < shortestDistance {
                shortestDistance = distance
                indexOfColor = index
            }
        }
        return basicColors[indexOfColor]
    }
    static let colorSelected = UIColor.white
}

