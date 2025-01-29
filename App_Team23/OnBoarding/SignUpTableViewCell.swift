//
//  SignUpTableViewCell.swift
//  Login Page 3
//
//  Created by Aryan Shukla on 17/01/25.
//

import UIKit

class SignUpTableViewCell: UITableViewCell {

    @IBOutlet var questionOutlet: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func update(with question: Question){
        questionOutlet.placeholder = question.questionAsk
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    

}
