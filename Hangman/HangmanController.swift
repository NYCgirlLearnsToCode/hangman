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
	var wordsArr = [String.SubSequence]()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .white
		getWords()
	}

	func getWords() {
		WordsClient.manager.getWords(success: { [unowned self] in self.words = $0 })
		DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute:  { [unowned self] in
			self.wordsIntoArray()
		})
	}
	
	func wordsIntoArray() {
		wordsArr = words.split(separator: "\n")
		DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute:  { [unowned self] in
			self.randomWord()
		})
	}
	
	func randomWord() {
		let random = Int(arc4random_uniform(162414))
		print(wordsArr.count)
		print("random#", random)
		let randomWord = wordsArr[random]
		print("randomWord", randomWord)
	}
}

