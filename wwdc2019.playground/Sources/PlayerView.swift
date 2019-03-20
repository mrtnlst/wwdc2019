import Foundation
import UIKit
import MediaPlayer

public class PlayerView: UIView {
   
    // MARK: - Properties
    
    private var artwork = UIImageView()
    private var currentAlbum: Album?
    private var playToolBar = UIToolbar()
    private var forwardToolBar = UIToolbar()
    private var backwardToolBar = UIToolbar()
    private var playButton: UIBarButtonItem!
    private var pauseButton: UIBarButtonItem!
    private var backwardButton: UIBarButtonItem!
    private var forwardButton: UIBarButtonItem!
    private var albumTitle = UILabel()
    
    // MARK: - Life cycle
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        configureViews()
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }
    
    // MARK: - UI
    
    private func configureViews() {
        layer.cornerRadius = 10.0
        backgroundColor = .colorPickerBackground

        artwork.backgroundColor = .midnightBlueDark
        artwork.translatesAutoresizingMaskIntoConstraints = false
        artwork.layer.cornerRadius = 10.0
        artwork.clipsToBounds = true
        artwork.layer.shadowColor = UIColor.black.cgColor
        artwork.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        artwork.layer.shadowOpacity = 0.2
        addSubview(artwork)
        
        albumTitle.translatesAutoresizingMaskIntoConstraints = false
        albumTitle.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        albumTitle.textColor = .white
        albumTitle.text = ". . ."
        albumTitle.textAlignment = .center
        albumTitle.numberOfLines = 1
        albumTitle.textAlignment = .center
        addSubview(albumTitle)
        
        // UIBarButtonItems
        playButton = UIBarButtonItem(barButtonSystemItem: .play, target: self, action: #selector(playAction))
        playButton.tintColor = .white
        
        pauseButton = UIBarButtonItem(barButtonSystemItem: .pause, target: self, action: #selector(pauseAction))
        pauseButton.tintColor = .white
        
        forwardButton = UIBarButtonItem(barButtonSystemItem: .fastForward, target: self, action: #selector(forwardAction))
        forwardButton.tintColor = .white
        
        backwardButton = UIBarButtonItem(barButtonSystemItem: .rewind, target: self, action: #selector(backwardAction))
        backwardButton.tintColor = .white
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        // UIToolBar
        playToolBar.translatesAutoresizingMaskIntoConstraints = false
        playToolBar.isOpaque = false
        playToolBar.setItems([flexibleSpace, playButton, flexibleSpace], animated: false)
        playToolBar.setBackgroundImage(UIImage(), forToolbarPosition: .any, barMetrics: .default)
        playToolBar.setShadowImage(UIImage(), forToolbarPosition: .any)
        addSubview(playToolBar)
        
        forwardToolBar.translatesAutoresizingMaskIntoConstraints = false
        forwardToolBar.isOpaque = false
        forwardToolBar.setItems([flexibleSpace, forwardButton, flexibleSpace], animated: false)
        forwardToolBar.setBackgroundImage(UIImage(), forToolbarPosition: .any, barMetrics: .default)
        forwardToolBar.setShadowImage(UIImage(), forToolbarPosition: .any)
        addSubview(forwardToolBar)
        
        backwardToolBar.translatesAutoresizingMaskIntoConstraints = false
        backwardToolBar.isOpaque = false
        backwardToolBar.setItems([flexibleSpace, backwardButton, flexibleSpace], animated: false)
        backwardToolBar.setBackgroundImage(UIImage(), forToolbarPosition: .any, barMetrics: .default)
        backwardToolBar.setShadowImage(UIImage(), forToolbarPosition: .any)
        addSubview(backwardToolBar)
    }
    
    private func configureConstraints() {
        NSLayoutConstraint.activate([
            artwork.centerXAnchor.constraint(equalTo: centerXAnchor),
            artwork.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            artwork.heightAnchor.constraint(equalToConstant: 120),
            artwork.widthAnchor.constraint(equalToConstant: 120),
            
            albumTitle.topAnchor.constraint(equalTo: artwork.bottomAnchor, constant: 10),
            albumTitle.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            albumTitle.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            
            playToolBar.topAnchor.constraint(equalTo: albumTitle.bottomAnchor, constant: 10),
            playToolBar.leadingAnchor.constraint(equalTo: artwork.leadingAnchor, constant: 15),
            playToolBar.trailingAnchor.constraint(equalTo: artwork.trailingAnchor, constant: -15),
            
            backwardToolBar.topAnchor.constraint(equalTo: albumTitle.bottomAnchor, constant: 10),
            backwardToolBar.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            backwardToolBar.trailingAnchor.constraint(equalTo: playToolBar.leadingAnchor),
            
            forwardToolBar.topAnchor.constraint(equalTo: albumTitle.bottomAnchor, constant: 10),
            forwardToolBar.leadingAnchor.constraint(equalTo: playToolBar.trailingAnchor),
            forwardToolBar.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            ])
    }
    
    // MARK: - Actions
    @objc private func playAction() {
        guard let albumToPlay = currentAlbum else { return }
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        playToolBar.setItems([flexibleSpace, pauseButton, flexibleSpace], animated: true)
        
//        // Resume playback on current song.
        if let nowPlayingItem = MPMusicPlayerController.systemMusicPlayer.nowPlayingItem {
            if let nowPlayingItemID = (nowPlayingItem.value(forProperty: MPMediaItemPropertyAlbumPersistentID) as? NSNumber)?.stringValue {
                if nowPlayingItemID == albumToPlay.mediaID {
                    MPMusicPlayerController.systemMusicPlayer.play()
                    return
                }
            }
        }

        let predicate = MPMediaPropertyPredicate(value: albumToPlay.mediaID, forProperty: MPMediaItemPropertyAlbumPersistentID, comparisonType: MPMediaPredicateComparison.equalTo)

        let filter: Set<MPMediaPropertyPredicate> = [predicate]
        let query = MPMediaQuery(filterPredicates: filter)
        MPMusicPlayerController.systemMusicPlayer.setQueue(with: query)
        MPMusicPlayerController.systemMusicPlayer.prepareToPlay()
        MPMusicPlayerController.systemMusicPlayer.play()
    }
    
    @objc private func pauseAction() {
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        playToolBar.setItems([flexibleSpace, playButton, flexibleSpace], animated: true)
        
        MPMusicPlayerController.systemMusicPlayer.pause()
    }
    
    @objc private func forwardAction() {
        MPMusicPlayerController.systemMusicPlayer.skipToNextItem()
    }
    
    @objc private func backwardAction() {
        if MPMusicPlayerController.systemMusicPlayer.currentPlaybackTime < 5 {
            MPMusicPlayerController.systemMusicPlayer.skipToPreviousItem()
            return
        }
        MPMusicPlayerController.systemMusicPlayer.skipToBeginning()
    }
    
    // MARK: - Public
    
    public func playAlbum(_ album: Album)  {
        artwork.image = album.artwork
        currentAlbum = album
        albumTitle.text = album.title
        playAction()
    }
}
