import UIKit
import Foundation

public class ViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    // MARK: - Properties
    
    private var colorPickerTitle = UILabel()
    private var albumListTitle = UILabel()
    private var nowPlayingTitle = UILabel()
    private var albumListTitleView = UIView()
    private var nowPlayingTitleView = UIView()
    
    private var colorPickerView: ColorPickerView!
    private var albumPickerView: AlbumPickerView!
    private var playerView: PlayerView!
    private var sourceAlbums: [Album]
    private var visibleAlbums = [Album]()
    private var selectedColors = [Color]()
    let colorPickerViewIdentifier = "colorPickerViewCell"
    let albumPickerViewIdentifier = "albumsPickerViewCell"
    
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
        
        nowPlayingTitleView.translatesAutoresizingMaskIntoConstraints = false
        nowPlayingTitleView.backgroundColor = .colorPickerBackground
        view.addSubview(nowPlayingTitleView)
        
        nowPlayingTitle.translatesAutoresizingMaskIntoConstraints = false
        nowPlayingTitle.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        nowPlayingTitle.textColor = .white
        nowPlayingTitle.text = "Now playing"
        nowPlayingTitle.textAlignment = .center
        nowPlayingTitleView.addSubview(nowPlayingTitle)
        
        colorPickerTitle.translatesAutoresizingMaskIntoConstraints = false
        colorPickerTitle.font = UIFont.systemFont(ofSize: 40, weight: .bold)
        colorPickerTitle.textColor = .white
        colorPickerTitle.text = "Pick a color"
        view.addSubview(colorPickerTitle)
        
        albumListTitleView.translatesAutoresizingMaskIntoConstraints = false
        albumListTitleView.backgroundColor = .colorPickerBackground
        albumListTitleView.layer.cornerRadius = 10
        view.addSubview(albumListTitleView)

        albumListTitle.translatesAutoresizingMaskIntoConstraints = false
        albumListTitle.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        albumListTitle.textColor = .white
        albumListTitle.text = "Albums"
        albumListTitle.textAlignment = .center
        albumListTitleView.addSubview(albumListTitle)
        
        colorPickerView = ColorPickerView(frame: .zero)
        colorPickerView.delegate = self
        colorPickerView.dataSource = self
        colorPickerView.register(ColorCell.self, forCellWithReuseIdentifier: colorPickerViewIdentifier)
        view.addSubview(colorPickerView)
        
        albumPickerView = AlbumPickerView(frame: .zero)
        albumPickerView.delegate = self
        albumPickerView.dataSource = self
        albumPickerView.register(AlbumCell.self, forCellWithReuseIdentifier: albumPickerViewIdentifier)
        view.insertSubview(albumPickerView, belowSubview: albumListTitleView)
        
        playerView = PlayerView(frame: .zero)
        playerView.translatesAutoresizingMaskIntoConstraints = false
        view.insertSubview(playerView, belowSubview: nowPlayingTitleView)
    }
    
    private func configureConstraints() {
        NSLayoutConstraint.activate([
            colorPickerTitle.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            colorPickerTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            colorPickerView.topAnchor.constraint(equalTo: colorPickerTitle.bottomAnchor, constant: 10),
            colorPickerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            colorPickerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            colorPickerView.heightAnchor.constraint(equalToConstant: view.bounds.height * 1/6),
            
            albumListTitleView.topAnchor.constraint(equalTo: colorPickerView.bottomAnchor, constant: 10),
            albumListTitleView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            albumListTitleView.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -5),
            
            albumListTitle.topAnchor.constraint(equalTo: albumListTitleView.topAnchor, constant: 10),
            albumListTitle.bottomAnchor.constraint(equalTo: albumListTitleView.bottomAnchor, constant: -10),
            albumListTitle.centerXAnchor.constraint(equalTo: albumListTitleView.centerXAnchor),
                                                   
            albumPickerView.topAnchor.constraint(equalTo: albumListTitle.bottomAnchor, constant: -5),
            albumPickerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            albumPickerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10),
            albumPickerView.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -5),
            
            nowPlayingTitleView.topAnchor.constraint(equalTo: colorPickerView.bottomAnchor, constant: 10),
            nowPlayingTitleView.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: 5),
            nowPlayingTitleView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            
            nowPlayingTitle.topAnchor.constraint(equalTo: nowPlayingTitleView.topAnchor, constant: 10),
            nowPlayingTitle.bottomAnchor.constraint(equalTo: nowPlayingTitleView.bottomAnchor, constant: -10),
            nowPlayingTitle.centerXAnchor.constraint(equalTo: nowPlayingTitleView.centerXAnchor),
            
            playerView.topAnchor.constraint(equalTo: nowPlayingTitle.bottomAnchor, constant: -5),
            playerView.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: 5),
            playerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10),
            playerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            
            
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
            cellB.album = visibleAlbums[indexPath.row]
            return cellB
        }
    }
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == colorPickerView {
            let cellA = collectionView.cellForItem(at: indexPath) as! ColorCell
            setSelectedColor(cellA.color)
        }
        else {
            let cellB = collectionView.cellForItem(at: indexPath) as! AlbumCell
            playerView.playAlbum(cellB.album)
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
