//
//  String+Extensions.swift
//  MobileTIP
//
//  Created by Tuan Vu on 4/24/25.
//

import Foundation

extension String {
    var htmlToPlainText: String {
        guard let data = self.data(using: .utf8) else { return self }
        
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]
        
        let attributedString = try? NSAttributedString(data: data, options: options, documentAttributes: nil)
        
        return attributedString?.string ?? self
    }
    
    var markdownToAttributedString: NSAttributedString {
        if #available(iOS 15.0, *) {
            do {
                let attributed = try AttributedString(markdown: self)
                return NSAttributedString(attributedString: NSAttributedString(attributed))
            } catch {
                print("⚠️ Failed to convert markdown: \(error)")
                return NSAttributedString(string: self)
            }
        } else {
            return NSAttributedString(string: self)
        }
    }
}
