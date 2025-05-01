//
//  FinishedListViewController.swift
//  MobileTIP
//
//  Created by Tuan Vu on 4/24/25.
//

import UIKit

class FinishedListViewController: UIViewController, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    private var finishedQuestions: [Question] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let questions = Question.getQuestions()
        
        self.finishedQuestions = questions
        
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return finishedQuestions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuestionCell", for: indexPath) as! QuestionCell
        
        let question = finishedQuestions[indexPath.row]
        
        if indexPath.row == 0 {
            cell.isDailyImageView.image = UIImage(systemName: "star.fill")
            cell.acRateLabel.text = String(format: "%.1f%%", question.acRate)
        } else {
            cell.isDailyImageView.image = nil
            cell.acRateLabel.text = String(format: "%.1f%%", question.acRate * 100)
        }
        
        cell.titleLabel.text = question.title
        cell.difficultyLabel.text = question.difficulty.uppercased()
        
        cell.question = question
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let selectedIndexPath = tableView.indexPathForSelectedRow else { return }
        
        let finishedQuestion = finishedQuestions[selectedIndexPath.row]
        
        guard let detailViewController = segue.destination as? QuestionDetailViewController else { return }
        
        detailViewController.question = finishedQuestion
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
