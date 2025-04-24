//
//  SolutionViewController.swift
//  MobileTIP
//
//  Created by Tuan Vu on 4/24/25.
//

import UIKit

class SolutionViewController: UIViewController {
    
    @IBOutlet weak var solutionTextView: UITextView!
    var solutionHTML: String?
    
    let noSolution: String = "No solution available."

    override func viewDidLoad() {
        super.viewDidLoad()
        
        solutionTextView.attributedText = solutionHTML?.htmlToPlainText.markdownToAttributedString ?? noSolution.markdownToAttributedString
    }
}

