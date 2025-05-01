//
//  QuestionListViewController.swift
//  MobileTIP
//
//  Created by Tuan Vu on 4/24/25.
//

import UIKit

class QuestionListViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    private var questions: [Question] = []
    private var dailyQuestion: Question =
    Question.empty

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        Question.clearFromFinished()

        tableView.dataSource = self
        
        fetchDailyQuestion()
        
        fetchQuestions()
    }
    
//    private func sortQuestions() {
//        let finished = Set(Question.getQuestions())
//        questions.sort {
//            let aFinished = finished.contains($0)
//            let bFinished = finished.contains($1)
//            return !aFinished && bFinished // unfinished first
//        }
//    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selectedIndexPath, animated: animated)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questions.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuestionCell", for: indexPath) as! QuestionCell
        
        var question: Question
        
        if indexPath.row == 0 {
            question = dailyQuestion
            
            cell.isDailyImageView.image = UIImage(systemName: "star.fill")
            cell.acRateLabel.text = String(format: "%.1f%%", question.acRate)
        } else {
            question = questions[indexPath.row - 1]
            
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
        
        guard let detailViewController = segue.destination as? QuestionDetailViewController else { return }

        if selectedIndexPath.row == 0 {
            detailViewController.question = dailyQuestion
        } else {
            let slug = questions[selectedIndexPath.row - 1].titleSlug
            detailViewController.titleSlug = slug
        }
    }

    
    private func fetchDailyQuestion() {
        let parameters = "{\"query\":\"query questionOfToday {\\n  activeDailyCodingChallengeQuestion {\\n    date\\n    question {\\n      questionId\\n      content\\n      acRate\\n      difficulty\\n      title\\n      titleSlug\\n      codeSnippets {\\n        lang\\n        langSlug\\n        code\\n      }\\n      solution {\\n        content\\n      }\\n      stats\\n      hints\\n      likes\\n      dislikes\\n    }\\n  }\\n}\\n\",\"variables\":{}}"
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
            
            do {
                let decoder = JSONDecoder()
                
                let questionResponse = try decoder.decode(DailyChallengeData.self, from: data)
                
                let question = questionResponse.data.activeDailyCodingChallengeQuestion.question
                
                DispatchQueue.main.async { [weak self] in
                    print("✅ SUCCESS!!! Fetched the daily question")
                    print("Title: \(question.title)")
                    
                    self?.dailyQuestion = question
                    
                    self?.tableView.reloadData()
                }
            } catch {
                print("🚨 Error decoding JSON data into Question Response: \(error.localizedDescription)")
                return
            }
        }

        task.resume()

    }
    
    private func fetchQuestions() {
        let parameters = "{\"query\":\"query problemsetQuestionList($limit: Int) {\\n  problemsetQuestionListV2(\\n    categorySlug: \\\"\\\",\\n    limit: $limit,\\n    skip: 0\\n  ) {\\n    questions {\\n      titleSlug\\n    }\\n  }\\n}\\n\",\"variables\":{\"limit\":20}}"
        let postData = parameters.data(using: .utf8)
        
        var request = URLRequest(url: URL(string: "https://leetcode.com/graphql")!,timeoutInterval: Double.infinity)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("csrftoken=qgmuc0zTmSjxTHZwIm0DBNtmtDL1Fmt875CdQDQTYHxly6MGl4xBfIvCTfReW7jA", forHTTPHeaderField: "Cookie")
        
        request.httpMethod = "POST"
        request.httpBody = postData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print(String(describing: error))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                
                let questionResponse = try decoder.decode(QuestionListResponse.self, from: data)
                
                let questions = questionResponse.data.problemsetQuestionListV2.questions
                
                DispatchQueue.main.async { [weak self] in
                    print("✅ SUCCESS!!! Fetched the questions")
                    
                    self?.questions = questions
                    
                    self?.tableView.reloadData()
                }
            } catch {
                print("🚨 Error decoding JSON data into Question Response: \(error.localizedDescription)")
                return
            }
        }
        
        task.resume()
    }
}
