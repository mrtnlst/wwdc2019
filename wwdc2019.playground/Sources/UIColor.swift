import Foundation
import UIKit

public extension UIColor {
    func closestBasicColor() -> Color? {
        var r1: CGFloat = 0
        var g1: CGFloat = 0
        var b1: CGFloat = 0
        var a: CGFloat = 0
        self.getRed(&r1, green: &g1, blue: &b1, alpha: &a)
        //print(UIColor(red: r1, green: g1, blue: b1, alpha: a))
        
        let r2: CGFloat = round(abs(r1 - 0.2))
        let g2: CGFloat = round(abs(g1 - 0.2))
        let b2: CGFloat = round(abs(b1 - 0.2))
        
        let roundedColor = UIColor(red: r2, green: g2, blue: b2, alpha: a)
        if (r2 == 0 && g2 == 0 && b2 == 0) {
            return Color(color: .black, name: "Black")
        }
        if (r2 == 1 && g2 == 1 && b2 == 1) {
            return Color(color: .white, name: "White")
        }
        for color in basicColors {
            if roundedColor.isEqual(color.color) {
                return color
            }
        }
        return nil
    }
    static let colorSelected = UIColor(red:0.51, green:0.72, blue:0.84, alpha:1.0)
}
