//
//  QuestionDetailViewController.swift
//  MobileTIP
//
//  Created by Tuan Vu on 4/24/25.
//

import UIKit

class QuestionDetailViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var difficultyLabel: UILabel!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var hintsLabel: UILabel!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var dislikesLabel: UILabel!
    @IBAction func solutionsButton(_ sender: Any) {
    }
    
    var question: Question!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = question.title
        difficultyLabel.text = question.difficulty
        contentTextView.text = question.content.htmlToPlainText
        if let hints = question.hints {
            hintsLabel.text = question.hints![0]
        } else {
            hintsLabel.text = "No hints :/"
        }
        
        likesLabel.text = "Likes 👍✅: \(question.likes)"
        dislikesLabel.text = "Dislikes 👎🚫: \(question.dislikes)"
    }
}
