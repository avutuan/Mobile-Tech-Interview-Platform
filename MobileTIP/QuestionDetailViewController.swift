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

    @IBAction func showSolutions(_ sender: Any) {
        // TODO: Push to a solutions view controller
        print("Solution button tapped")
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
    
    private func fetchQuestion(for slug: String) {
        let parameters = "{\"query\":\"query questionTitle($titleSlug: String!) {\\n  question(titleSlug: $titleSlug) {\\n    questionId\\n    content\\n    acRate\\n    title\\n    titleSlug\\n    difficulty\\n    likes\\n    dislikes\\n  }\\n}\",\"variables\":{\"titleSlug\":\"\(slug)\"}}"
        let postData = parameters.data(using: .utf8)

        var request = URLRequest(url: URL(string: "https://leetcode.com/graphql")!,timeoutInterval: Double.infinity)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("csrftoken=qgmuc0zTmSjxTHZwIm0DBNtmtDL1Fmt875CdQDQTYHxly6MGl4xBfIvCTfReW7jA", forHTTPHeaderField: "Cookie")

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
        hintsLabel.text = question.hints?.first ?? "No hints :/"

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
