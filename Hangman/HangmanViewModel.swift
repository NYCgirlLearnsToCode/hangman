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
	var numberOfAllowedGuesses = 0
	var guessesLeft = 0
	var correctGuesses = 0
	var incorrectGuesses = 0
	var userHasWon = false
	var gameOver = false
	// TODO: - Cache words?
	// MARK: - functions -
	func getWords(wordsCompletion: @escaping (_ success: Bool) -> Void) {
		WordsClient.manager.getWords(success: { [unowned self] in self.words = $0 })
		DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute:  { [unowned self] in
			print("done getting words")
			self.wordsIntoArray(completion: {
				print("finished turning into array from view model", $0)
				wordsCompletion(true)
			})
		})
	}
	
	func wordsIntoArray(completion: (_ success: Bool) -> Void) {
		wordsArr = words.split(separator: "\n")
		completion(true)
	}
	
	//oncompletion
	func getRandomWord() {
		// TODO: make sure words are done downloading
		let random = Int(arc4random_uniform(162414))
		print("random#", random)
		DispatchQueue.main.async { [unowned self] in
			//self.randomWord = String(self.wordsArr[random])
			self.randomWord = String(self.wordsArr[85892])
			self.numberOfAllowedGuesses = self.randomWord.count
			self.guessesLeft = self.randomWord.count
			print("random word count ",self.numberOfAllowedGuesses)
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
		print(dict)
	}
	
	func check(letter: String) -> [Int] {
		// TODO: Handle wrong guesses
		guessesLeft = guessesLeft - 1
		// TODO: - only allow letter input
		if let arr = dict[Character(letter.lowercased())] {
			correctGuesses = correctGuesses + 1
			if correctGuesses == numberOfAllowedGuesses {
				userHasWon = true
				print("win!!")
			}
			return arr
			
		} else {
			incorrectGuesses = incorrectGuesses + 1
				if incorrectGuesses == numberOfAllowedGuesses || guessesLeft == 0 {
					print("lost!")
					return []
				}
			print("wrong, number of incorrect guesses made", incorrectGuesses)
			return []
		}
	}
}
