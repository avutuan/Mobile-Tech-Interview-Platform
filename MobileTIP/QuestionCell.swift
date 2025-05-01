//
//  QuestionCell.swift
//  MobileTIP
//
//  Created by Tuan Vu on 4/24/25.
//

import UIKit

class QuestionCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var selectedButton: UIButton!
    @IBOutlet weak var difficultyLabel: UILabel!
    @IBOutlet weak var acRateLabel: UILabel!
    @IBOutlet weak var isDailyImageView: UIImageView!
    
    var question: Question!
    
    @IBAction func selectedTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected {
            question.addToFinished()
        } else {
            question.removeFromFinished()
        }
        
        print(Question.getQuestions())
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) { }
    override func setHighlighted(_ highlighted: Bool, animated: Bool) { }
}
