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
    @IBOutlet weak var hintsTextView: UITextView!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var dislikesLabel: UILabel!
    @IBAction func showSolution(_ sender: Any) {
        guard question.solution?.content.isEmpty == false else {
            let alert = UIAlertController(title: "No Solution", message: "This problem doesn't have a public solution available.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            return
        }

        performSegue(withIdentifier: "ShowSolution", sender: self)
    }

    var question: Question!
    var titleSlug: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let question = question {
            updateUI(with: question)
        } else if let titleSlug = titleSlug {
            fetchQuestion(for: titleSlug)
        } else {
            question = Question.empty
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowSolution" {
            guard let destination = segue.destination as? SolutionViewController else { return }
            destination.solutionHTML = question.solution?.content
        }
    }
    
    private func fetchQuestion(for slug: String) {
        let parameters = "{\"query\":\"query questionTitle($titleSlug: String!) {\\n  question(titleSlug: $titleSlug) {\\n    questionId\\n    content\\n    acRate\\n    hints\\n    title\\n    titleSlug\\n    difficulty\\n    solution {\\n        content\\n    }\\n    likes\\n    dislikes\\n  }\\n}\",\"variables\":{\"titleSlug\":\"\(slug)\"}}"
        let postData = parameters.data(using: .utf8)

        var request = URLRequest(url: URL(string: "https://leetcode.com/graphql")!,timeoutInterval: Double.infinity)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        request.httpMethod = "POST"
        request.httpBody = postData

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                print("Server Error: response: \(String(describing: response))")
                return
            }
            
            guard let data = data else {
                print(String(describing: error))
                return
            }
            
            print(String(data: data, encoding: .utf8)!)
            
            do {
                let decoder = JSONDecoder()
                
                let questionResponse = try decoder.decode(QuestionData.self, from: data)
                
                let question = questionResponse.data.question
                
                DispatchQueue.main.async { [weak self] in
                    print("✅ SUCCESS!!! Fetched the daily question")
                    print("Title: \(question.title)")
                    
                    self?.question = question
                    
                    self?.updateUI(with: question)
                }
            } catch {
                print("🚨 Error decoding JSON data into Question Response: \(error.localizedDescription)")
                return
            }
        }
        task.resume()

    }
    
    private func updateUI(with question: Question) {
        titleLabel.text = question.title
        difficultyLabel.text = question.difficulty
        contentTextView.text = question.content?.htmlToPlainText ?? "No content"
        
        if question.hints?.count ?? 0 > 0 {
            var hintsText: String = ""
            for (idx, hint) in question.hints!.enumerated() {
                hintsText = hintsText + "<p>Hint \(idx + 1): \(hint)<p>"
            }
            
            hintsTextView.text = hintsText.htmlToPlainText
        } else {
            hintsTextView.text = "No hints :/"
        }
        
        
        if let likes = question.likes {
            likesLabel.text = "Likes 👍✅: \(likes)"
        } else {
            likesLabel.text = "Likes 👍✅: n/a"
        }

        if let dislikes = question.dislikes {
            dislikesLabel.text = "Dislikes 👎🚫: \(dislikes)"
        } else {
            dislikesLabel.text = "Dislikes 👎🚫: n/a"
        }
    }
}
