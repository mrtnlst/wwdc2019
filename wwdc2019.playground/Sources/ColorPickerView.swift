import UIKit

public class ColorPickerView: UICollectionView {
    
    // MARK: - Life cycle
    
    public init(frame: CGRect) {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        layout.itemSize = CGSize(width: 40, height: 40)
        
        super.init(frame: frame, collectionViewLayout: layout)
        
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .colorPickerBackground
        layer.cornerRadius = 10
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
