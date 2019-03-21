import Foundation
import UIKit
import MediaPlayer

public class RootViewController: UIViewController {
    
    // MARK: - Properties
    
    private var titleLabel = UILabel()
    private var introductionLabel = UILabel()
    private var accessButton: UIButton!
    private var startButton: UIButton!
    private var waitLabel = UILabel()
    private var activityIndicator: UIActivityIndicatorView!
    private var dataSource: DataSource!
    
    
    // MARK: - Life cycle
    
    public init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
        configureConstraints()
        dataSource = DataSource(context: .iOS)
    }
    
    // MARK: - UI
    
    private func configureViews() {
        view.backgroundColor = .midnightBlue
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.systemFont(ofSize: 40, weight: .bold)
        titleLabel.textColor = .white
        titleLabel.text = "Introduction"
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 1
        view.addSubview(titleLabel)
        
        introductionLabel.translatesAutoresizingMaskIntoConstraints = false
        introductionLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        introductionLabel.textColor = .white
        introductionLabel.text = "1. Grant access to music library. \n\n2. Pick up to two colors. \n\n3. Tap an album you'd like to listen to. \n\n4. Control playback from 'Now playing'."
        introductionLabel.textAlignment = .left
        introductionLabel.numberOfLines = 0
        view.addSubview(introductionLabel)
        
        accessButton = UIButton(type: .roundedRect)
        accessButton.translatesAutoresizingMaskIntoConstraints = false
        accessButton.setTitle("Grant access", for: .normal)
        accessButton.setTitleColor(.white, for: .normal)
        accessButton.backgroundColor = UIColor.midnightBlueSelected
        accessButton.layer.cornerRadius = 10
        accessButton.contentEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        accessButton.addTarget(self, action: #selector(requestMediaAccess), for: .touchUpInside)
        view.addSubview(accessButton)
        
        startButton = UIButton(type: .roundedRect)
        startButton.translatesAutoresizingMaskIntoConstraints = false
        startButton.setTitle("Start Playground", for: .normal)
        startButton.setTitleColor(.white, for: .normal)
        startButton.backgroundColor = UIColor.midnightBlueSelected
        startButton.layer.cornerRadius = 10
        startButton.contentEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        startButton.addTarget(self, action: #selector(continueWithPlayground), for: .touchUpInside)
        startButton.isEnabled = false
        startButton.alpha = 0.6
        view.addSubview(startButton)
        
        waitLabel.translatesAutoresizingMaskIntoConstraints = false
        waitLabel.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        waitLabel.textColor = .white
        waitLabel.text = "Gathering albums"
        waitLabel.textAlignment = .center
        waitLabel.numberOfLines = 1
        waitLabel.isHidden = true
        view.addSubview(waitLabel)
        
        activityIndicator = UIActivityIndicatorView(style: .white)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.isHidden = true
        view.addSubview(activityIndicator)
    }
    private func configureConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 40),
            
            introductionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            introductionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor, constant: -50),
            introductionLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 50),
            introductionLabel.bottomAnchor.constraint(equalTo: view.centerYAnchor),
            
            accessButton.topAnchor.constraint(equalTo: introductionLabel.bottomAnchor, constant: 40),
            accessButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            startButton.topAnchor.constraint(equalTo: accessButton.bottomAnchor, constant: 30),
            startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            waitLabel.topAnchor.constraint(equalTo: startButton.bottomAnchor, constant: 20),
            waitLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            activityIndicator.centerYAnchor.constraint(equalTo: waitLabel.centerYAnchor),
            activityIndicator.leadingAnchor.constraint(equalTo: waitLabel.trailingAnchor, constant: 15)
            ])
    }
    
    @objc private func requestMediaAccess() {
        let status = MPMediaLibrary.authorizationStatus()
        switch status {
        case .authorized:
            enableStartButton()

        case .notDetermined:
            MPMediaLibrary.requestAuthorization() { status in
                if status == .authorized {
                   self.enableStartButton()
                }
                else {
                    self.disableGrantAccess()
                }
            }
            break
        case .denied, .restricted:
            self.disableGrantAccess()
        }
    }
    
    @objc private func continueWithPlayground() {
        self.waitLabel.isHidden = false
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
    
        DispatchQueue.global(qos: .background).async {
            self.dataSource.getData(completion: {
                DispatchQueue.main.async {
                    let viewController = ViewController(sourceAlbums: self.dataSource.sourceAlbums)
                    self.present(viewController, animated: true, completion: nil)
                }
            })
        }
    }
    
    private func disableGrantAccess() {
        DispatchQueue.main.async {
            self.accessButton.isEnabled = false
            self.accessButton.alpha = 0.6
            self.accessButton.setTitle("Access denied", for: .normal)
        }
    }
    
    private func enableStartButton() {
        DispatchQueue.main.async {
            self.startButton.isEnabled = true
            self.startButton.alpha = 1.0
            self.accessButton.isEnabled = false
            self.accessButton.alpha = 0.6
            self.accessButton.setTitle("Access granted", for: .normal)
        }
    }
    
}
