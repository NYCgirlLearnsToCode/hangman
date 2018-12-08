//
//  HangmanViewModel.swift
//  Hangman
//
//  Created by Lisa Jiang on 12/2/18.
//  Copyright © 2018 Lisa Jiang. All rights reserved.
//

import Foundation

class HangmanViewModel {
	private var words = ""
	private var wordsArr = [String.SubSequence]()
	private var doneTurningIntoArray = false
	var randomWord = ""
	var drawWordLines: (() -> Void)?
	var dict = [Character: [Int]]()
	var textFieldText = ""
	var numberOfAllowedGuesses = 6
	var guessesLeft = 6
	var correctGuesses = 0
	var incorrectGuesses = 0
	var userHasWon = false
	var gameOver = false
	
	// MARK: - functions -
	func getWords(wordsCompletion: @escaping (_ success: Bool) -> Void) {
		WordsClient.manager.getWords(success: { [unowned self] in self.words = $0 })
		DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute:  { [unowned self] in
			self.wordsIntoArray(completion: { _ in
				wordsCompletion(true)
			})
		})
	}
	
	func wordsIntoArray(completion: (_ success: Bool) -> Void) {
		wordsArr = words.split(separator: "\n")
		completion(true)
	}
	
	
	func getRandomWord() {
		let randomNumber = Int(arc4random_uniform(162414))
		print("random#", randomNumber)
		DispatchQueue.main.async { [unowned self] in
			self.randomWord = String(self.wordsArr[randomNumber])
			print("randomWord", self.randomWord)
			self.wordToDict(word: self.randomWord)
			self.drawWordLines?()
		}
	}
	
	func wordToDict(word: String) {
		var numArr = [Int]()
		var currentLetter: Character = "a"
		for (thisIndex,thisLetter) in word.enumerated() {
			currentLetter = thisLetter
			//for each letter check the whole word for indexes
			for (index,letter) in word.enumerated() {
				if thisLetter == letter {
					numArr.append(index)
				}
			}
			dict[thisLetter] = numArr
			numArr = []
		}
	}
	
	func check(letter: String) -> [Int] {
		guessesLeft = guessesLeft - 1
		if let arr = dict[Character(letter.lowercased())] {
			correctGuesses = correctGuesses + 1
//			if correctGuesses == numberOfAllowedGuesses {
//				// TODO win without using all guesses
//				userHasWon = true
//				print("win!!")
//			}
			
			if correctGuesses == dict.count  {
				userHasWon = true
				print("won before max guesses correctGuesses == dict.count",correctGuesses == dict.count)
			}
			return arr
			
		} else {
			incorrectGuesses = incorrectGuesses + 1
				if incorrectGuesses == numberOfAllowedGuesses || guessesLeft == 0 {
					print("lost!")
					return []
				}
			return []
		}
	}
}
