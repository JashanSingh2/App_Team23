//
//  LetsGoCollectionReusableView.swift
//  App_Team23
//
//  Created by Batch - 1 on 17/01/25.
//

import UIKit

class LetsGoCollectionReusableView: UICollectionReusableView {
        
    var headerLabel = UILabel()
    var button = UIButton(type: .system)
    
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
        button.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(headerLabel)
        addSubview(button)
        
        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: topAnchor),
            headerLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            headerLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            headerLabel.trailingAnchor.constraint(equalTo: button.leadingAnchor, constant: -8),
            
            button.topAnchor.constraint(equalTo: topAnchor),
            button.bottomAnchor.constraint(equalTo: bottomAnchor),
            button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            button.leadingAnchor.constraint(equalTo: headerLabel.trailingAnchor, constant: 300)
            
        ])
        
    }
    
    
    
}
