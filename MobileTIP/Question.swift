//
//  Question.swift
//  MobileTIP
//
//  Created by Tuan Vu on 4/24/25.
//

import Foundation

struct DailyChallengeData: Codable {
    let data: DailyChallengeWrapper
}

struct DailyChallengeWrapper: Codable {
    let activeDailyCodingChallengeQuestion: DailyQuestion
}

// MARK: - Daily Question Structure
struct DailyQuestion: Codable {
    let date: String
    let question: Question
}

struct QuestionList: Decodable {
    let results: [Question]
}

struct CodeSnippet: Codable, Equatable {
    let lang: String
    let langSlug: String
    let code: String
    
    enum CodingKeys: String, CodingKey {
        case lang
        case langSlug
        case code
    }
}

struct Solution: Codable, Equatable {
    let content: String
    
    enum CodingKeys: String, CodingKey {
        case content
    }
}

struct Question: Codable, Equatable {
    let questionId: String
    let title: String
    let content: String
    let difficulty: String
    let acRate: Double
    let codeSnippets: [CodeSnippet]
    let solution: Solution?
    let stats: String
    let hints: [String]?
    let likes: Int
    let dislikes: Int
    
    enum CodingKeys: String, CodingKey {
        case questionId
        case title
        case content
        case difficulty
        case acRate
        case codeSnippets
        case solution
        case stats
        case hints
        case likes
        case dislikes
    }
}

extension Question {
    static var finishedKey: String {
        return "Finished"
    }
    
    static func save(_ questions: [Question]) {
        let defaults = UserDefaults.standard
        
        let encodedData = try! JSONEncoder().encode(questions)
        
        defaults.set(encodedData, forKey: Question.finishedKey)
    }
    
    static func getQuestions() -> [Question] {
        let defaults = UserDefaults.standard
        
        if let data = defaults.data(forKey: Question.finishedKey) {
            let decodedQuestions = try! JSONDecoder().decode( [Question].self, from: data)
            return decodedQuestions
        } else {
            return []
        }
    }
    
    func addToFinished() {
        var finishedQuestions = Question.getQuestions()
        
        print("Added to Finished")
        finishedQuestions.append(self)
        
        Question.save(finishedQuestions)
    }
    
    func removeFromFinished() {
        var finishedQuestions = Question.getQuestions()
        
        finishedQuestions.removeAll { question in
            return self == question
        }
        
        Question.save(finishedQuestions)
    }
}
