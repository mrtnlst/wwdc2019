import Foundation
import UIKit

public struct Color {
   
    // MARK: - Properties

    public var uicolor: UIColor
    public var name: String

    // MARK: - Life cycle

    public init() {
        self.uicolor = .white
        self.name = "Error"
    }
    
    public init(uicolor: UIColor, name: String) {
        self.uicolor = uicolor
        self.name = name
    }
}

public let basicColors = [Color(uicolor: UIColor(red:0.97, green:0.09, blue:0.21, alpha:1.0), name: "Red"),
                          Color(uicolor: UIColor(red:0.49, green:0.88, blue:0.51, alpha:1.0), name: "green"),
                          Color(uicolor: UIColor(red:0.26, green:0.51, blue:0.76, alpha:1.0), name: "Blue"),
                          Color(uicolor: UIColor(red:0.20, green:0.96, blue:0.95, alpha:1.0), name: "Cyan"),
                          Color(uicolor: UIColor(red:1.00, green:0.45, blue:0.62, alpha:1.0), name: "Magenta"),
                          Color(uicolor: UIColor(red:0.90, green:0.76, blue:0.16, alpha:1.0), name: "Yellow"),
                          Color(uicolor: .brown, name: "Brown"),
                          Color(uicolor: UIColor(red:0.95, green:0.44, blue:0.02, alpha:1.0), name: "Orange"),
                          Color(uicolor: UIColor(red:0.39, green:0.20, blue:0.43, alpha:1.0), name: "Purple"),
                          Color(uicolor: .black, name: "Black")]


