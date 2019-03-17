import UIKit
import Foundation
import PlaygroundSupport

class ViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    private var titleLabel = UILabel()
    private var colorPickerView: ColorPickerView!
    private var albumPickerView: AlbumPickerView!
    let colorPickerViewIdentifier = "colorPickerViewCell"
    let albumPickerViewIdentifier = "albumsPickerViewCell"
    private var albums = [Album]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
        configureConstraints()
        
        for index in 1...3 {
            if let artwork = UIImage(named: "artwork\(index).jpg") {
                let artworkColors = artwork.getColors()
                guard let primaryColor = artworkColors.primary.closestBasicColor() else {
                    continue
                }
                guard let secondaryColor = artworkColors.secondary.closestBasicColor() else {
                    continue
                }
                albums.append(Album(artwork: artwork, mediaID: "\(index)", colors: [primaryColor, secondaryColor]))
            }
        }
        albumPickerView.reloadData()
    }

    private func configureViews() {
        view.backgroundColor = .darkGray
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        titleLabel.textColor = .white
        titleLabel.text = "Pick a color"
        view.addSubview(titleLabel)
        
        colorPickerView = ColorPickerView(frame: .zero)
        colorPickerView.delegate = self
        colorPickerView.dataSource = self
        colorPickerView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: colorPickerViewIdentifier)

        colorPickerView.backgroundColor = .lightGray
        view.addSubview(colorPickerView)
        
        albumPickerView = AlbumPickerView(frame: .zero)
        albumPickerView.delegate = self
        albumPickerView.dataSource = self
        albumPickerView.register(AlbumsCell.self, forCellWithReuseIdentifier: albumPickerViewIdentifier)
        
        albumPickerView.backgroundColor = .blue
        view.addSubview(albumPickerView)
    }

    private func configureConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            colorPickerView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            colorPickerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            colorPickerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            colorPickerView.heightAnchor.constraint(equalToConstant: view.bounds.height * 1/6),
            
            albumPickerView.topAnchor.constraint(equalTo: colorPickerView.bottomAnchor),
            albumPickerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            albumPickerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            albumPickerView.trailingAnchor.constraint(equalTo: view.centerXAnchor),
            ])
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == colorPickerView {
            return basicColors.count
        }
        else {
            return albums.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == colorPickerView {
            let cellA = collectionView.dequeueReusableCell(withReuseIdentifier: colorPickerViewIdentifier, for: indexPath)
            
            cellA.backgroundColor = basicColors[indexPath.row].color
            return cellA
        }
        else {
            let cellB = collectionView.dequeueReusableCell(withReuseIdentifier: albumPickerViewIdentifier, for: indexPath) as! AlbumsCell
            cellB.artwork.image = albums[indexPath.row].artwork
            return cellB
        }
    }
}

let viewController = ViewController()
PlaygroundPage.current.liveView = viewController
