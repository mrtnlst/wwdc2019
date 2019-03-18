import UIKit
import Foundation
import PlaygroundSupport

class ViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    private var titleLabel = UILabel()
    private var colorPickerView: ColorPickerView!
    private var albumPickerView: AlbumPickerView!
    let colorPickerViewIdentifier = "colorPickerViewCell"
    let albumPickerViewIdentifier = "albumsPickerViewCell"
    private var sourceAlbums = [Album]()
    private var visibleAlbums = [Album]()
    private var selectedColors = [Color]()
    
    // MARK: - Life cycle
    
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
                sourceAlbums.append(Album(artwork: artwork, mediaID: "\(index)", colors: [primaryColor, secondaryColor]))
            }
        }
        albumPickerView.reloadData()
    }

    // MARK: - UI
    
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
        colorPickerView.register(ColorCell.self, forCellWithReuseIdentifier: colorPickerViewIdentifier)

        colorPickerView.backgroundColor = .lightGray
        view.addSubview(colorPickerView)
        
        albumPickerView = AlbumPickerView(frame: .zero)
        albumPickerView.delegate = self
        albumPickerView.dataSource = self
        albumPickerView.register(AlbumCell.self, forCellWithReuseIdentifier: albumPickerViewIdentifier)
        
        albumPickerView.backgroundColor = .blue
        view.addSubview(albumPickerView)
    }

    private func configureConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            colorPickerView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            colorPickerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            colorPickerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            colorPickerView.heightAnchor.constraint(equalToConstant: view.bounds.height * 1/8),
            
            albumPickerView.topAnchor.constraint(equalTo: colorPickerView.bottomAnchor),
            albumPickerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            albumPickerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            albumPickerView.trailingAnchor.constraint(equalTo: view.centerXAnchor),
            ])
    }
    
    // MARK: - UICollectionViewDelegates
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == colorPickerView {
            return basicColors.count
        }
        else {
            return visibleAlbums.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == colorPickerView {
            let cellA = collectionView.dequeueReusableCell(withReuseIdentifier: colorPickerViewIdentifier, for: indexPath) as! ColorCell
            
            cellA.setColor(to: basicColors[indexPath.row])
            cellA.setSelectionState(to: .unselected)
            return cellA
        }
        else {
            let cellB = collectionView.dequeueReusableCell(withReuseIdentifier: albumPickerViewIdentifier, for: indexPath) as! AlbumCell
            cellB.artwork.image = visibleAlbums[indexPath.row].artwork
            return cellB
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == colorPickerView {
            let cellA = collectionView.cellForItem(at: indexPath) as! ColorCell
            setSelectedColor(cellA.color)
        }
        else {
        }
    }
    
    // MARK: - Helper
    
    /// Makes sure that only 2 colors are selected at the same time.
    
    private func setSelectedColor(_ color: Color) {
        if selectedColors.contains(where: { $0.color.isEqual(color.color) }) {
            if let cell = (colorPickerView.visibleCells as! [ColorCell]).filter({ $0.color.color.isEqual(color.color)}).first {
                cell.setSelectionState(to: .unselected)
                selectedColors.removeAll(where: { $0.color.isEqual(color.color) })
                refreshVisibleAlbums()
                return
            }
        }
        if selectedColors.count < 2 {
            selectedColors.append(color)
        }
        else {
            selectedColors[0] = selectedColors[1]
            selectedColors[1] = color
        }
        for cell in colorPickerView.visibleCells as! [ColorCell] {
            if selectedColors.contains(where: { $0.color.isEqual(cell.color.color) }) {
                cell.setSelectionState(to: .selected)
            }
            else {
                cell.setSelectionState(to: .unselected)
            }
        }
        refreshVisibleAlbums()
    }
    
    /// Manages which albums are shown for selected colors.
    
    private func refreshVisibleAlbums() {
        visibleAlbums.removeAll()
        for color in selectedColors {
            for album in sourceAlbums {
                if album.containsColor(color) && !visibleAlbums.contains(where: { $0.mediaID == album.mediaID }) {
                    visibleAlbums.append(album)
                }
            }
        }
        albumPickerView.reloadData()
    }
}

let viewController = ViewController()
PlaygroundPage.current.liveView = viewController
