import PlaygroundSupport
import UIKit

// The RootViewController provides an introduction to the app and
// asks for access to your local music library.

let rootViewController = RootViewController()
PlaygroundPage.current.liveView = rootViewController
PlaygroundPage.current.needsIndefiniteExecution = true
