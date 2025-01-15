//
//  SectionHeaderCollectionReusableView.swift
//  App_Team23
//
//  Created by Batch - 1 on 15/01/25.
//

import UIKit

class SectionHeaderCollectionReusableView: UICollectionReusableView {
    
    var headerLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        updateSectionHeader()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        updateSectionHeader()
    }
    
    func updateSectionHeader() {
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(headerLabel)
        
        
        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: topAnchor),
            headerLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            headerLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            headerLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
            ])
        
        
    }
}
