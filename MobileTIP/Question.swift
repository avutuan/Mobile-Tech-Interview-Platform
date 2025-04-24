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

struct QuestionData: Codable {
    let data: QuestionWrapper
}

struct QuestionWrapper: Codable {
    let question: Question
}

struct DailyQuestion: Codable {
    let date: String?
    let question: Question
}

struct QuestionListResponse: Codable {
    let data: QuestionListData
}

struct QuestionListData: Codable {
    let problemsetQuestionListV2: QuestionList
}

struct QuestionList: Codable {
    let questions: [Question]
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

struct TopicTag: Codable, Equatable {
    let name: String
    let slug: String
}

struct Question: Codable, Equatable {
    let questionId: String?
    let id: Int?
    let title: String
    let titleSlug: String
    let content: String?
    let difficulty: String
    let paidOnly: Bool?
    let acRate: Double
    let topicTags: [TopicTag]?
    let status: String?
    let frequency: Double?
    let isInMyFavorites: Bool?
    let codeSnippets: [CodeSnippet]?
    let solution: Solution?
    let stats: String?
    let hints: [String]?
    let likes: Int?
    let dislikes: Int?
    
    enum CodingKeys: String, CodingKey {
        case questionId
        case id
        case title
        case titleSlug
        case content
        case difficulty
        case paidOnly
        case acRate
        case topicTags
        case status
        case frequency
        case isInMyFavorites
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
    
    static var empty: Question {
        return Question(
            questionId: "",
            id: 0,
            title: "",
            titleSlug: "",
            content: "",
            difficulty: "",
            paidOnly: false,
            acRate: 0.0,
            topicTags: [],
            status: "",
            frequency: 0.0,
            isInMyFavorites: false,
            codeSnippets: [],
            solution: Solution(content: ""),
            stats: "",
            hints: [],
            likes: 0,
            dislikes: 0
        )
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
