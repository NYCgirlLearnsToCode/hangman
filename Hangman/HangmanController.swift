//
//  ViewController.swift
//  Hangman
//
//  Created by Lisa Jiang on 12/1/18.
//  Copyright © 2018 Lisa Jiang. All rights reserved.
//

import UIKit

class HangmanController: UIViewController {
	var words = ""
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .blue
		getWords()
		print(words)
	}

	func getWords() {
		WordsClient.manager.getWords(success: { self.words = $0 })
		DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute:  {
			print(self.words.count)
		})
	}
}

