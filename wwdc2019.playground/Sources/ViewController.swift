import UIKit
import Foundation

public class ViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    private var titleLabel = UILabel()
    private var colorPickerView: ColorPickerView!
    private var albumPickerView: AlbumPickerView!
    let colorPickerViewIdentifier = "colorPickerViewCell"
    let albumPickerViewIdentifier = "albumsPickerViewCell"
    private var sourceAlbums: [Album]
    private var visibleAlbums = [Album]()
    private var selectedColors = [Color]()
    
    // MARK: - Life cycle
    
    public init(sourceAlbums: [Album]) {
        self.sourceAlbums = sourceAlbums
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
        configureConstraints()
    }
    
    // MARK: - UI
    
    private func configureViews() {
        view.backgroundColor = .midnightBlue
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.systemFont(ofSize: 40, weight: .bold)
        titleLabel.textColor = .white
        titleLabel.text = "Pick a color"
        view.addSubview(titleLabel)
        
        colorPickerView = ColorPickerView(frame: .zero)
        colorPickerView.delegate = self
        colorPickerView.dataSource = self
        colorPickerView.register(ColorCell.self, forCellWithReuseIdentifier: colorPickerViewIdentifier)        
        colorPickerView.backgroundColor = .midnightBlue
        view.addSubview(colorPickerView)
        
        albumPickerView = AlbumPickerView(frame: .zero)
        albumPickerView.delegate = self
        albumPickerView.dataSource = self
        albumPickerView.register(AlbumCell.self, forCellWithReuseIdentifier: albumPickerViewIdentifier)
        
        albumPickerView.backgroundColor = .midnightBlue
        view.addSubview(albumPickerView)
    }
    
    private func configureConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            colorPickerView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            colorPickerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            colorPickerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            colorPickerView.heightAnchor.constraint(equalToConstant: view.bounds.height * 1/7),
            
            albumPickerView.topAnchor.constraint(equalTo: colorPickerView.bottomAnchor),
            albumPickerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            albumPickerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            albumPickerView.trailingAnchor.constraint(equalTo: view.centerXAnchor),
            ])
    }
    
    // MARK: - UICollectionViewDelegates
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == colorPickerView {
            return basicColors.count
        }
        else {
            return visibleAlbums.count
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
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
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == colorPickerView {
            let cellA = collectionView.cellForItem(at: indexPath) as! ColorCell
            setSelectedColor(cellA.color)
        }
        else {
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == colorPickerView {
            return 25
        }
        return 10
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == colorPickerView {
            return 20
        }
        return 10
    }
    
    // MARK: - Helper
    
    /// Makes sure that only 2 colors are selected at the same time.
    
    private func setSelectedColor(_ color: Color) {
        if selectedColors.contains(where: { $0.uicolor.isEqual(color.uicolor) }) {
            if let cell = (colorPickerView.visibleCells as! [ColorCell]).filter({ $0.color.uicolor.isEqual(color.uicolor)}).first {
                cell.setSelectionState(to: .unselected)
                selectedColors.removeAll(where: { $0.uicolor.isEqual(color.uicolor) })
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
            if selectedColors.contains(where: { $0.uicolor.isEqual(cell.color.uicolor) }) {
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
        for album in sourceAlbums {
            if album.containsColors(selectedColors) && !visibleAlbums.contains(where: { $0.mediaID == album.mediaID }) {
                visibleAlbums.append(album)
            }
        }
    
        albumPickerView.reloadData()
    }
}
