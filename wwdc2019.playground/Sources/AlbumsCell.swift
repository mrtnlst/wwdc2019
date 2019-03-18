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
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
