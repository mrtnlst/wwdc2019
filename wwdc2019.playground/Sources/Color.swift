import Foundation
import UIKit

public struct Color {
    public var uicolor: UIColor
    public var name: String
    
    public init() {
        self.uicolor = .white
        self.name = "Error"
    }
    
    public init(uicolor: UIColor, name: String) {
        self.uicolor = uicolor
        self.name = name
    }
}

public let basicColors = [Color(uicolor: .red, name: "Red"),
                          Color(uicolor: .green, name: "green"),
                          Color(uicolor: .blue, name: "Blue"),
                          Color(uicolor: .cyan, name: "Cyan"),
                          Color(uicolor: .magenta, name: "Magenta"),
                          Color(uicolor: .yellow, name: "Yellow"),
                          Color(uicolor: .brown, name: "Brown"),
                          Color(uicolor: .orange, name: "Orange"),
                          Color(uicolor: .purple, name: "Purple"),
                          Color(uicolor: .black, name: "Black")]


