//
//  ViewController.swift
//  Hangman
//
//  Created by Lisa Jiang on 12/1/18.
//  Copyright © 2018 Lisa Jiang. All rights reserved.
//

import UIKit
import SnapKit

class HangmanController: UIViewController {
	// MARK: - properties -
	private let viewModel = HangmanViewModel() 
	private let textfield = UITextField()
	private let guessButton = UIButton()
	private let newWordButton = UIButton()
	private let stackView = UIStackView()
	private let linesStackView = UIStackView()
	private let textField = UITextField()
	private let guessesLeftLabel = UILabel()
	private let incorrectGuessesLabel = UILabel()
	private let correctGuessesLabel = UILabel()
	private let statusLabel = UILabel()
	private let resetGameButton = UIButton()
	private let imageView = UIImageView()
	
	// MARK: - lifecycle -
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .white
		getWords()
		addSubviews()
		setupBindings()
		localize()
	}
	
	// MARK: - functions -
	private func getWords() {
		viewModel.getWords { [unowned self] in
			if $0 {
				self.wordsIntoArray()
			}
		}
	}
	
	private func wordsIntoArray() {
		viewModel.wordsIntoArray { (success) -> Void in
			if success {
				newWordButton.backgroundColor = .green
				newWordButton.isEnabled = true
			}
		}
	}
	
	private func disable() {
		textField.isEnabled = false
		guessButton.isEnabled = false
		newWordButton.isEnabled = true
		resetGameButton.isHidden = false
	}
	
	private func clearStackView() {
		if !stackView.arrangedSubviews.isEmpty {
			var num = 1
			for label in stackView.arrangedSubviews {
				label.removeFromSuperview()
				num = num + 1
			}
		}
		
		if !linesStackView.arrangedSubviews.isEmpty {
			var num = 1
			for label in linesStackView.arrangedSubviews {
				label.removeFromSuperview()
				num = num + 1
			}
		}
	}
	
	private func showWordLines() {
		// Create a stackview of _ under the letters, unhide letters when correctly guessed using index
		guessesLeftLabel.text = "Guesses Left: \(viewModel.guessesLeft)"
		incorrectGuessesLabel.text = "Incorrect Guesses: \(viewModel.incorrectGuesses)"
		correctGuessesLabel.text = "Correct Guesses: \(viewModel.correctGuesses)"
		
		viewModel.randomWord.forEach {
			let label = UILabel()
			label.text = "\($0)"
			label.textColor = .white
			stackView.addArrangedSubview(label)
		}
		
		viewModel.randomWord.forEach { _ in
			let lineLabel = UILabel()
			lineLabel.text = "—"
			linesStackView.addArrangedSubview(lineLabel)
		}
	}
}
// MARK: - viewCustomizer -
extension HangmanController {
	private func addSubviews() {
		addNewWordButton()
		addImageView()
		addGuessesLeftLabel()
		addIncorrectGuessesLeftLabel()
		addCorrectGuessesLabel()
		addStatusLabel()
		addResetGameButton()
		addStackview()
		addLinesStackview()
		addTextField()
		addGuessButton()
	}
	
	private func addNewWordButton() {
		view.addSubview(newWordButton)
		newWordButton.backgroundColor = .gray
		newWordButton.isEnabled = false
		
		newWordButton.snp.makeConstraints { make in
			make.top.trailing.equalToSuperview().inset(50.0)
			make.width.equalTo(100.0)
			make.height.equalTo(25.0)
		}
	}
	
	private func addImageView() {
		view.addSubview(imageView)
		imageView.backgroundColor = .black
		imageView.contentMode = .scaleAspectFit
		imageView.image = UIImage(named: "start")
		
		imageView.snp.makeConstraints { make in
			make.top.equalTo(newWordButton.snp.bottom).offset(20.0)
			make.width.equalTo(110.0)
			make.height.equalTo(200.0)
			make.trailing.equalToSuperview().inset(30.0)
		}
	}
	
	private func addGuessesLeftLabel() {
		view.addSubview(guessesLeftLabel)
		
		guessesLeftLabel.snp.makeConstraints { make in
			make.top.equalToSuperview().inset(150.0)
			make.leading.trailing.equalToSuperview().inset(20.0)
		}
	}
	
	private func addIncorrectGuessesLeftLabel() {
		view.addSubview(incorrectGuessesLabel)
		
		incorrectGuessesLabel.snp.makeConstraints { make in
			make.top.equalTo(guessesLeftLabel.snp.bottom).offset(10.0)
			make.leading.trailing.equalToSuperview().inset(20.0)
		}
	}
	
	private func addCorrectGuessesLabel() {
		view.addSubview(correctGuessesLabel)
		
		correctGuessesLabel.snp.makeConstraints { make in
			make.top.equalTo(incorrectGuessesLabel.snp.bottom).offset(10.0)
			make.leading.trailing.equalToSuperview().inset(20.0)
		}
	}
	
	private func addStatusLabel() {
		view.addSubview(statusLabel)
		
		statusLabel.snp.makeConstraints { make in
			make.centerX.equalToSuperview()
			make.top.equalTo(correctGuessesLabel.snp.bottom).offset(10.0)
			make.leading.equalTo(correctGuessesLabel)
			make .trailing.equalTo(imageView.snp.leading).inset(10.0)
		}
	}
	
	private func addResetGameButton() {
		view.addSubview(resetGameButton)
		resetGameButton.backgroundColor = .blue
		resetGameButton.isHidden = true
		
		resetGameButton.snp.makeConstraints { make in
			make.top.equalTo(statusLabel.snp.bottom).offset(10.0)
			make.width.equalTo(100.0)
			make.height.equalTo(50.0)
			make.centerX.equalToSuperview()
		}
	}
	
	private func addStackview() {
		view.addSubview(stackView)
		stackView.axis = .horizontal
		stackView.alignment = .center
		stackView.spacing = 29.0
		stackView.snp.makeConstraints { make in
			make.centerX.equalToSuperview()
			make.top.equalTo(correctGuessesLabel.snp.bottom).offset(100.0)
			make.height.equalTo(20.0)
		}
	}
	
	private func addLinesStackview() {
		view.addSubview(linesStackView)
		linesStackView.axis = .horizontal
		linesStackView.alignment = .center
		linesStackView.spacing = 20.0
		linesStackView.snp.makeConstraints { make in
			make.centerX.equalTo(stackView)
			make.top.equalTo(stackView.snp.bottom).offset(5.0)
			make.height.equalTo(10.0)
		}
	}
	
	private func addTextField() {
		view.addSubview(textField)
		textField.backgroundColor = .blue
		textField.textColor = .white
		textField.textAlignment = .center
		
		textField.snp.makeConstraints { make in
			make.centerX.equalToSuperview()
			make.width.height.equalTo(50.0)
			make.top.equalTo(linesStackView.snp.bottom).offset(20.0)
		}
	}
	
	private func addGuessButton() {
		view.addSubview(guessButton)
		guessButton.backgroundColor = .blue
		guessButton.isEnabled = false
		
		guessButton.snp.makeConstraints { make in
			make.width.height.equalTo(70.0)
			make.centerX.equalTo(stackView)
			make.top.equalTo(textField.snp.bottom).offset(10.0)
		}
	}
	
}
extension HangmanController {
	func setupBindings() {
		setupNewWordButton()
		setupGuessButton()
		setupResetButton()
	}
	
	private func setupNewWordButton() {
		newWordButton.addTarget(self, action: #selector(generateNewWord), for: .touchUpInside)
	}
	
	@objc private func generateNewWord() {
		viewModel.getRandomWord()
		viewModel.drawWordLines = { [unowned self] in
			self.showWordLines()
			self.newWordButton.isEnabled = false
			self.newWordButton.backgroundColor = .gray
			self.guessButton.isEnabled = true
		}
	}
	
	private func setupGuessButton() {
		guessButton.addTarget(self, action: #selector(guessLetter), for: .touchUpInside)
	}
	
	@objc private func guessLetter() {
		viewModel.textFieldText = textField.text ?? "nil,no text"
		let indexes = viewModel.check(letter: viewModel.textFieldText)
		guessesLeftLabel.text = "Guesses Left: \(viewModel.guessesLeft)"
		incorrectGuessesLabel.text = "Incorrect Guesses: \(viewModel.incorrectGuesses)"
		correctGuessesLabel.text = "Correct Guesses: \(viewModel.correctGuesses)"
		textField.text = ""
		
		if !indexes.isEmpty {
			for index in indexes {
				stackView.arrangedSubviews[index].backgroundColor = .blue
			}
		} else {
			switch viewModel.incorrectGuesses {
			case 1: imageView.image = UIImage(named: "one")
			case 2: imageView.image = UIImage(named: "two")
			case 3: imageView.image = UIImage(named: "three")
			case 4: imageView.image = UIImage(named: "four")
			case 5: imageView.image = UIImage(named: "five")
			case 6: imageView.image = UIImage(named: "six")
			default: print("default")
			}
		}
		
		if viewModel.userHasWon {
			statusLabel.text = "You Won!"
			viewModel.gameOver = true
			disable()
		}
		
		if !viewModel.userHasWon  && viewModel.guessesLeft == 0 {
			statusLabel.text = "You Lost! Word: \(viewModel.randomWord)"
			viewModel.gameOver = true
			disable()
		}
	}
	
	private func setupResetButton() {
		resetGameButton.addTarget(self, action: #selector(resetGame), for: .touchUpInside)
	}
	
	@objc private func resetGame() {
		textField.isEnabled = true
		guessButton.isEnabled = true
		newWordButton.isEnabled = true
		viewModel.incorrectGuesses = 0
		viewModel.correctGuesses = 0
		viewModel.guessesLeft = 6
		incorrectGuessesLabel.text = "Incorrect Guesses:"
		correctGuessesLabel.text = "Correct Guesses:"
		statusLabel.text = ""
		viewModel.userHasWon = false
		viewModel.getRandomWord()
		clearStackView()
		resetGameButton.isHidden = true
		guessesLeftLabel.text = "Guesses Left: \(viewModel.guessesLeft)"
		imageView.image = UIImage(named: "start")
	}
}
// MARK: - localize -
extension HangmanController {
	func localize() {
		guessButton.setTitle("Guess", for: .normal)
		newWordButton.setTitle("Start", for: .normal)
		incorrectGuessesLabel.text = "Incorrect Guesses:"
		guessesLeftLabel.text = "Guesses Left: \(viewModel.guessesLeft)"
		correctGuessesLabel.text = "Correct Guesses:"
		statusLabel.text = ""
		resetGameButton.setTitle("Reset Game", for: .normal)
	}
}
