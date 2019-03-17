import Foundation
import UIKit

public struct Color {
    public var color: UIColor
    public var name: String
    
    public init() {
        self.color = .white
        self.name = "Error"
    }
    
    public init(color: UIColor, name: String) {
        self.color = color
        self.name = name
    }
}

public let basicColors = [Color(color: .red, name: "Red"),
                          Color(color: .green, name: "green"),
                          Color(color: .blue, name: "Blue"),
                          Color(color: .cyan, name: "Cyan"),
                          Color(color: .magenta, name: "Magenta"),
                          Color(color: .yellow, name: "Yellow"),
                          Color(color: .brown, name: "Brown"),
                          Color(color: .orange, name: "Orange"),
                          Color(color: .purple, name: "Purple"),
                          Color(color: .white, name: "White"),
                          Color(color: .black, name: "Black"),
                          Color(color: .gray, name: "Gray")]


