//
//  WordsClient.swift
//  Hangman
//
//  Created by Lisa Jiang on 12/2/18.
//  Copyright © 2018 Lisa Jiang. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift

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
//		Alamofire.request(urlRequest).response(completionHandler: { (response) in
//			if response.error != nil {
//				print("error",response.error)
//			} else {
//				guard let data = response.data else { return }
//				let htmlContent = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
//
//				regString = String(htmlContent!)
//				success(regString)
//			}
//		})
	}
	
	func rxRequest() -> Observable<String> {
		return Observable.create { observer in
			let urlStr = URL(string: "http://app.linkedin-reach.io/words")
			let urlRequest = URLRequest(url: urlStr!)
			let request = Alamofire.request(urlRequest).responseData(completionHandler: { response in
				defer { observer.onCompleted() }
				guard let statusCode = response.response?.statusCode,
					(200...299).contains(statusCode)
					else {
						print("error in response")
						return
				}
				
				if let result = response.result.value {
					guard let data = response.data else { return }
					let htmlContent = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
					
					let regString = String(htmlContent!)
					observer.onNext(regString)
//					print("result", result)
				} else {
					print("response error")
				}
			}
		)
			return Disposables.create {
				request.cancel()
			}
		}
	}
}
