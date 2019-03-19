import Foundation
import UIKit

public class AlbumCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    public var artwork: UIImageView!

    // MARK: - Life cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    // MARK: - UI
    
    func setupViews() {
        artwork = UIImageView(frame: contentView.bounds)
        artwork.layer.cornerRadius = 10.0
        artwork.clipsToBounds = true
        contentView.addSubview(artwork)
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        layer.shadowOpacity = 0.2
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
