//
//  ModalSaveController.swift
//  BuddhaTimer
//
//  Created by x115 on 10/10/17.
//  Copyright © 2017 x115. All rights reserved.
//

import UIKit
import Foundation


class ModalSaveController: UIViewController {

	private var permanentResult: Int!
	var result: Int?
	var healthManager: HealthKitManager?
	var sender: UIViewController?


	@IBOutlet var resultLabel: UILabel!
	@IBOutlet var saveButton: UIButton!
	@IBOutlet var warningLabel: UILabel!

	@IBAction func saveButton(sender: AnyObject) {
		saveResult()
	}

	@IBAction func cancelButton(sender: AnyObject) {
		dismiss(animated: true, completion: nil)
	}

	@IBAction func plusMinButton(sender: AnyObject) {
		plusMin()
	}
	@IBAction func minusMinButton(sender: AnyObject) {
		minusMin()
	}
	@IBAction func plusSecButton(sender: AnyObject) {
		plusSec()
	}
	@IBAction func minusSecButton(sender: AnyObject) {
		minusSec()
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		permanentResult = result!
		resfreshTimer()

		// если нет доступа к записи данных в HealthKit
		if (!healthManager!.isAvailable()) {
			warningLabel.isHidden = false
		}
	}


	private func saveResult() {
		let sec = result!
		healthManager!.saveMeditation(seconds: sec) { (success: Bool, error: Error?) -> Void in
			if !success {
				print("😡 Failed save meditation")
				if error != nil {
					print("Reason: \(error?.localizedDescription)")
					self.displayAlert(for: error!)
				}
				return
			}
			print("😀 Save meditation success")
			self.dismiss(animated: true, completion: nil)
		}
	}

	func resfreshTimer() {
		let text = Helper().secondsToMinutes(seconds: result!)
		resultLabel.text? = String(text)
	}

	func plusMin() {
		if (result! <= permanentResult - 60) {
			result! += 60
		}
		resfreshTimer()
	}

	func minusMin() {
		if (result! > 60) {
			result! -= 60
		}
		resfreshTimer()
	}

	func plusSec() {
		if (result! < permanentResult) {
			result! += 1
		}
		resfreshTimer()
	}

	func minusSec() {
		if (result! > 1) {
			result! -= 1
		}
		resfreshTimer()
	}


	func displayAlert(for error: Error) {
		let msg = error.localizedDescription + ".\n To save result, allow permission in HealthKit"
		let alert = UIAlertController(title: nil, message: msg, preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
		self.present(alert, animated: true, completion: nil)
	}

}
