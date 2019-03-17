import Foundation
import UIKit

public extension UIColor {
    func closestBasicColor() -> Color? {
        var r1: CGFloat = 0
        var g1: CGFloat = 0
        var b1: CGFloat = 0
        var a: CGFloat = 0
        self.getRed(&r1, green: &g1, blue: &b1, alpha: &a)
//        print(UIColor(red: r1, green: g1, blue: b1, alpha: a))
        
        let r2: CGFloat = round(abs(r1 - 0.2))
        let g2: CGFloat = round(abs(g1 - 0.2))
        let b2: CGFloat = round(abs(b1 - 0.2))
        
        let roundedColor = UIColor(red: r2, green: g2, blue: b2, alpha: a)
        for color in basicColors {
            if roundedColor.isEqual(color.color) {
                return color
            }
        }
        return nil
    }
}
