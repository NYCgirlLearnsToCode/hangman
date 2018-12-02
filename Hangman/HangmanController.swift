//
//  ViewController.swift
//  Hangman
//
//  Created by Lisa Jiang on 12/1/18.
//  Copyright © 2018 Lisa Jiang. All rights reserved.
//

import UIKit
import RxSwift

class HangmanController: UIViewController {
	let disposeBag = DisposeBag()
	private var words = BehaviorSubject<String>(value: "")
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .blue
		getWords()
		print(words)
	}

	func getWords() {
		WordsClient.manager.rxRequest()
		.subscribe(onNext: { [unowned self] in
			self.words.onNext($0)
			print($0)
		})
		.disposed(by: disposeBag)
	}
}

