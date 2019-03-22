import Foundation
import UIKit
import MediaPlayer

public class RootViewController: UIViewController {
    
    // MARK: - Properties
    
    private var titleLabel = UILabel()
    private var introductionLabel = UILabel()
    private var stepsLabel = UILabel()
    private var accessButton: UIButton!
    private var startButton: UIButton!
    private var waitLabel = UILabel()
    private var activityIndicator: UIActivityIndicatorView!
    private var dataSource: DataSource!
    private var processingView = UIView()
    
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
        
        introductionLabel.translatesAutoresizingMaskIntoConstraints = false
        introductionLabel.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        introductionLabel.textColor = .white
        introductionLabel.text = "Follow this playground to discover your albums sorted by their artwork's colors."
        introductionLabel.textAlignment = .center
        introductionLabel.numberOfLines = 0
        introductionLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        view.addSubview(introductionLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        titleLabel.textColor = .white
        titleLabel.text = "Albums by Color"
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 1
        titleLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        titleLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        view.addSubview(titleLabel)
        
        stepsLabel.translatesAutoresizingMaskIntoConstraints = false
        stepsLabel.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        stepsLabel.textColor = .white
        stepsLabel.text = "1. Grant access to music library \n\n2. Wait until albums are processed \n\n3. Pick up to two colors \n\n4. Tap an album to start playback \n\n5. Control playback from 'Now Playing'"
        stepsLabel.textAlignment = .left
        stepsLabel.numberOfLines = 0
        view.addSubview(stepsLabel)
        
        accessButton = UIButton(type: .roundedRect)
        accessButton.translatesAutoresizingMaskIntoConstraints = false
        accessButton.setTitle("Grant access", for: .normal)
        accessButton.setTitleColor(.white, for: .normal)
        accessButton.backgroundColor = UIColor.midnightBlueSelected
        accessButton.layer.cornerRadius = 10
        accessButton.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        accessButton.contentEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        accessButton.addTarget(self, action: #selector(requestMediaAccess), for: .touchUpInside)
        view.addSubview(accessButton)
        
        startButton = UIButton(type: .roundedRect)
        startButton.translatesAutoresizingMaskIntoConstraints = false
        startButton.setTitle("Start Playground", for: .normal)
        startButton.setTitleColor(.white, for: .normal)
        startButton.backgroundColor = UIColor.midnightBlueSelected
        startButton.layer.cornerRadius = 10
        startButton.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        startButton.contentEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        startButton.addTarget(self, action: #selector(continueWithPlayground), for: .touchUpInside)
        startButton.isEnabled = false
        startButton.alpha = 0.6
        view.addSubview(startButton)
        
        processingView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(processingView)
        
        waitLabel.translatesAutoresizingMaskIntoConstraints = false
        waitLabel.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        waitLabel.textColor = .white
        waitLabel.text = "Processing albums"
        waitLabel.textAlignment = .center
        waitLabel.numberOfLines = 1
        waitLabel.isHidden = true
        processingView.addSubview(waitLabel)
        
        activityIndicator = UIActivityIndicatorView(style: .white)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.isHidden = true
        processingView.addSubview(activityIndicator)
    }
    private func configureConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            introductionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            introductionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor, constant: -40),
            introductionLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 40),
            
            stepsLabel.topAnchor.constraint(equalTo: introductionLabel.bottomAnchor, constant: 20),
            stepsLabel.leadingAnchor.constraint(equalTo: introductionLabel.leadingAnchor, constant: -5),
            stepsLabel.trailingAnchor.constraint(equalTo: introductionLabel.trailingAnchor, constant: 5),
            stepsLabel.bottomAnchor.constraint(equalTo: view.centerYAnchor, constant: 30),
            
            accessButton.topAnchor.constraint(equalTo: stepsLabel.bottomAnchor, constant: 40),
            accessButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            startButton.topAnchor.constraint(equalTo: accessButton.bottomAnchor, constant: 30),
            startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            processingView.topAnchor.constraint(equalTo: startButton.bottomAnchor, constant: 20),
            processingView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            waitLabel.topAnchor.constraint(equalTo: processingView.topAnchor),
            waitLabel.bottomAnchor.constraint(equalTo: processingView.bottomAnchor),
            waitLabel.leadingAnchor.constraint(equalTo: processingView.leadingAnchor),
//            waitLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            activityIndicator.centerYAnchor.constraint(equalTo: waitLabel.centerYAnchor),
            activityIndicator.leadingAnchor.constraint(equalTo: waitLabel.trailingAnchor, constant: 15),
            activityIndicator.trailingAnchor.constraint(equalTo: processingView.trailingAnchor),
            ])
    }
    
    // MARK: - Helper
    
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
