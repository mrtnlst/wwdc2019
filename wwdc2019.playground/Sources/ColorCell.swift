import Foundation
import UIKit

// MARK: - Types

public enum SelectionState {
    case selected
    case unselected
}

public class ColorCell: UICollectionViewCell {
    
    // MARK: - Properties

    private var selectionLayer = UIView()
    public var selectionState: SelectionState!
    public var color: Color!

    // MARK: - Life cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI
    
    func setupViews() {
        layer.cornerRadius = 20
        
        selectionLayer = UIView(frame: CGRect(x: bounds.origin.x - 4,
                                              y: bounds.origin.y - 4,
                                              width: bounds.size.width + 8,
                                              height: bounds.size.height + 8))
        selectionLayer.layer.cornerRadius = 24.0
        selectionLayer.layer.borderWidth = 4.0
        selectionLayer.layer.borderColor = UIColor.colorSelected.cgColor
        selectionLayer.backgroundColor = UIColor.clear
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        layer.shadowOpacity = 0.2
        
        contentView.addSubview(selectionLayer)
    }
    
    // MARK: - Public
    
    public func setSelectionState(to selectionState: SelectionState) {
        self.selectionState = selectionState
        switch selectionState {
        case .selected:
            selectionLayer.isHidden = false
        case .unselected:
            selectionLayer.isHidden = true
        }
    }
    
    public func setColor(to color: Color) {
        self.color = color
        backgroundColor = color.uicolor
    }
}
