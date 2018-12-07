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
		viewModel.getWords()
	}
	
	private func wordsIntoArray() {
		viewModel.wordsIntoArray()
	}
	
	private func reset() {
		textField.isEnabled = false
		guessButton.isEnabled = false
		newWordButton.isEnabled = true
		newWordButton.setTitle("New Word", for: .normal)
	}
	
	private func clearStackView() {
		if !stackView.arrangedSubviews.isEmpty {
			var num = 1
			for label in stackView.arrangedSubviews {
				label.removeFromSuperview()
				print("removing", num)
				num = num + 1
			}
		}
		else {
			print("stackview is empty")
		}
		
		if !linesStackView.arrangedSubviews.isEmpty {
			var num = 1
			for label in linesStackView.arrangedSubviews {
				label.removeFromSuperview()
				print("removing line", num)
				num = num + 1
			}
		} else {
			print("empty lines")
		}
	}
	
	private func showWordLines() {
		print("viewModel.randomWord.count",viewModel.randomWord.count)
		clearStackView()
		print("done writing word", viewModel.randomWord)
		// TODO: - Create a stackview of _ under the letters, unhide letters when correctly guessed using index
		viewModel.randomWord.forEach {
			let label = UILabel()
			label.text = "\($0) "
			label.textColor = .white
			//			print("label \($0)")
			stackView.addArrangedSubview(label)
		}
		viewModel.randomWord.forEach { _ in
			let lineLabel = UILabel()
			lineLabel.text = "_ "
			linesStackView.addArrangedSubview(lineLabel)
		}
	}
}
// MARK: - viewCustomizer -
extension HangmanController {
	private func addSubviews() {
		addStackview()
		addLinesStackview()
		addNewWordButton()
		addTextField()
		addGuessButton()
	}
	
	private func addStackview() {
		view.addSubview(stackView)
		stackView.axis = .horizontal
		stackView.alignment = .center
		stackView.spacing = 3.0
		stackView.snp.makeConstraints { make in
			make.centerX.centerY.equalToSuperview()
			make.height.equalTo(100.0)
		}
	}
	
	private func addLinesStackview() {
		view.addSubview(linesStackView)
		linesStackView.axis = .horizontal
		linesStackView.alignment = .center
		linesStackView.spacing = 3.0
		linesStackView.snp.makeConstraints { make in
			make.centerX.equalTo(stackView)
			make.top.equalTo(stackView.snp.bottom).offset(5.0)
			make.height.equalTo(100.0)
		}
	}
	
	private func addNewWordButton() {
		view.addSubview(newWordButton)
		newWordButton.backgroundColor = .blue
		
		newWordButton.snp.makeConstraints { make in
			make.top.trailing.equalToSuperview().inset(50.0)
			make.width.equalTo(100.0)
			make.height.equalTo(25.0)
		}
	}
	
	private func addTextField() {
		view.addSubview(textField)
		textField.backgroundColor = .red
		
		textField.snp.makeConstraints { make in
			make.leading.equalTo(newWordButton).offset(-100.0)
			make.width.height.equalTo(50.0)
			make.top.equalTo(newWordButton)
		}
	}
	
	private func addGuessButton() {
		view.addSubview(guessButton)
		guessButton.backgroundColor = .blue
		
		guessButton.snp.makeConstraints { make in
			make.leading.equalTo(textField).offset(-100.0)
			make.width.height.equalTo(70.0)
			make.top.equalTo(textField)
		}
	}
}
extension HangmanController {
	func setupBindings() {
		setupNewWordButton()
		setupGuessButton()
	}
	
	private func setupNewWordButton() {
		newWordButton.addTarget(self, action: #selector(generateNewWord), for: .touchUpInside)
	}
	
	@objc private func generateNewWord() {
		newWordButton.isEnabled = false
		viewModel.getRandomWord()
		viewModel.drawWordLines = { [unowned self] in self.showWordLines() }
	}
	
	private func setupGuessButton() {
		guessButton.addTarget(self, action: #selector(guessLetter), for: .touchUpInside)
	}
	
	@objc private func guessLetter() {
		viewModel.textFieldText = textField.text ?? "nil,no text"
		print("viewModel.textFieldText", viewModel.textFieldText)
		let indexes = viewModel.check(letter: viewModel.textFieldText)
		textField.text = ""
		if !indexes.isEmpty {
			for index in indexes {
				stackView.arrangedSubviews[index].backgroundColor = .blue
			}
		}
		if viewModel.guessesLeft == 0 || viewModel.userHasWon {
			reset()
		}
	}
}
// MARK: - localize -
extension HangmanController {
	func localize() {
		guessButton.setTitle("Guess", for: .normal)
		newWordButton.setTitle("Start", for: .normal)
	}
}
