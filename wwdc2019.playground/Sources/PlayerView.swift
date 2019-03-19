import Foundation
import UIKit

public class PlayerView: UIView {
   
    // MARK: - Properties
    
    private var artwork = UIImageView()
    private var titleLabel = UILabel()
    private var musicToolBar = UIToolbar()
    private var playButton: UIBarButtonItem!
    private var pauseButton: UIBarButtonItem!
    private var backwardButton: UIBarButtonItem!
    private var forwardButton: UIBarButtonItem!
    
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
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        titleLabel.textColor = .white
        titleLabel.text = "Now playing"
        addSubview(titleLabel)
        
        artwork.backgroundColor = .midnightBlueDark
        artwork.translatesAutoresizingMaskIntoConstraints = false
        artwork.layer.cornerRadius = 10.0
        artwork.clipsToBounds = true
        artwork.layer.shadowColor = UIColor.black.cgColor
        artwork.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        artwork.layer.shadowOpacity = 0.2
        addSubview(artwork)
        
        // UIBarButtonItems
        playButton = UIBarButtonItem(barButtonSystemItem: .play, target: self, action: #selector(playAction))
        playButton.tintColor = .white
        
        pauseButton = UIBarButtonItem(barButtonSystemItem: .pause, target: self, action: #selector(pauseAction))
        pauseButton.tintColor = .white
        
        forwardButton = UIBarButtonItem(barButtonSystemItem: .fastForward, target: self, action: nil)
        forwardButton.tintColor = .white
        
        backwardButton = UIBarButtonItem(barButtonSystemItem: .rewind, target: self, action: nil)
        backwardButton.tintColor = .white
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        // UIToolBar
        musicToolBar.translatesAutoresizingMaskIntoConstraints = false
        musicToolBar.isOpaque = false
        musicToolBar.setItems([flexibleSpace, backwardButton, flexibleSpace, playButton, flexibleSpace, forwardButton, flexibleSpace], animated: false)
        musicToolBar.setBackgroundImage(UIImage(), forToolbarPosition: .any, barMetrics: .default)
        musicToolBar.setShadowImage(UIImage(), forToolbarPosition: .any)
        addSubview(musicToolBar)
    }
    
    private func configureConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            artwork.centerXAnchor.constraint(equalTo: centerXAnchor),
            artwork.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            artwork.heightAnchor.constraint(equalToConstant: 120),
            artwork.widthAnchor.constraint(equalToConstant: 120),
            
            musicToolBar.topAnchor.constraint(equalTo: artwork.bottomAnchor, constant: 10),
            musicToolBar.leadingAnchor.constraint(equalTo: leadingAnchor),
            musicToolBar.trailingAnchor.constraint(equalTo: trailingAnchor),
            ])
    }
    
    // MARK: - Actions
    @objc private func playAction() {
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        musicToolBar.setItems([flexibleSpace, backwardButton, flexibleSpace, pauseButton, flexibleSpace, forwardButton, flexibleSpace], animated: true)
    }
    
    @objc private func pauseAction() {
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        musicToolBar.setItems([flexibleSpace, backwardButton, flexibleSpace, playButton, flexibleSpace, forwardButton, flexibleSpace], animated: true)
    }
    
    // MARK: - Public
    
    public func playAlbum(_ album: Album)  {
        artwork.image = album.artwork
        pauseAction()
    }
}
