import PlaygroundSupport
import UIKit

//var sourceAlbums: [Album] = DataSource.getAlbumData(for: .iOS)

var sourceAlbums: [Album] = DataSource.getAlbumData(for: .macOS)

// Initialising view controller.
let viewController = ViewController(sourceAlbums: sourceAlbums)
PlaygroundPage.current.liveView = viewController
