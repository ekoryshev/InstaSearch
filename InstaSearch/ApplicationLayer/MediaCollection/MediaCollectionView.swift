import Foundation

import SnapKit

class MediaCollectionView: UIView {
    
    override class var requiresConstraintBasedLayout: Bool {
        return true
    }
    
    convenience init() {
        self.init(frame: .zero)
        
        self.backgroundColor = .cyan
    }
    
    override func updateConstraints() {
        
        super.updateConstraints()
    }
    
}
