// Created by Martin List as a WWDC19 Scholarship submission.
//
// To experience this playground, please make sure to have at
// least 5-30 albums in the iPad's music app. 

import PlaygroundSupport
import UIKit

// The RootViewController provides an introduction to the app and
// asks for access to your local music library.

let rootViewController = RootViewController()
PlaygroundPage.current.liveView = rootViewController
PlaygroundPage.current.needsIndefiniteExecution = true
