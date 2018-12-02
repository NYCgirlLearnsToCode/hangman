//
//  WordsClient.swift
//  Hangman
//
//  Created by Lisa Jiang on 12/2/18.
//  Copyright © 2018 Lisa Jiang. All rights reserved.
//

import Foundation
import Alamofire

enum AppErrors: Error {
	case noData
	case couldNotParseJSON(rawError: Error)
	case badURL(str: String)
	case noResponse
}

struct Words {
	let words: String
	init(words: String) {
		self.words = words
	}
}

struct WordsClient {
	private init() { }
	static let manager = WordsClient()
	
	func getWords(success: @escaping (String) -> Void) {
		var regString = ""
		let urlStr = URL(string: "http://app.linkedin-reach.io/words")
		let urlRequest = URLRequest(url: urlStr!)
		Alamofire.request(urlRequest).response(completionHandler: { (response) in
			if response.error != nil {
				print("error",response.error)
			} else {
				guard let data = response.data else { return }
				let htmlContent = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
				
				regString = String(htmlContent!)
				success(regString)
			}
		})
	}
}
