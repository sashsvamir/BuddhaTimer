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
	var startDate: Date?
	var healthManager: HealthKitManager?
	var sender: UIViewController?


	@IBOutlet var resultLabel: UILabel!
	@IBOutlet var saveButton: UIButton!
	@IBOutlet var warningLabel: UILabel!
	@IBOutlet var startDateLabel: UILabel!

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

		startDate = Date.init(timeInterval: TimeInterval(-result!), since: Date())

		permanentResult = result!
		resfreshTimers()

		// если нет доступа к записи данных в HealthKit
		if (!healthManager!.isAvailable()) {
			warningLabel.isHidden = false
		}
	}


	private func saveResult() {
		let finishDate = Date.init(timeInterval: TimeInterval(result!), since: startDate!)
		healthManager!.saveMeditation(seconds: result!, endDate: finishDate) {
			(success: Bool, error: Error?) -> Void in
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

	func resfreshTimers() {
		let text = Helper().secondsToMinutes(seconds: result!)
		resultLabel.text = String(text)

		let formatter = DateFormatter()
		formatter.dateFormat = "HH:mm"
		startDateLabel.text = formatter.string(from: startDate!)
	}

	func plusMin() {
		if (result! <= permanentResult - 60) {
			result! += 60
		}
		resfreshTimers()
	}

	func minusMin() {
		if (result! > 60) {
			result! -= 60
		}
		resfreshTimers()
	}

	func plusSec() {
		if (result! < permanentResult) {
			result! += 1
		}
		resfreshTimers()
	}

	func minusSec() {
		if (result! > 1) {
			result! -= 1
		}
		resfreshTimers()
	}


	func displayAlert(for error: Error) {
		let msg = error.localizedDescription + ".\n To save result, allow permission in HealthKit"
		let alert = UIAlertController(title: nil, message: msg, preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
		self.present(alert, animated: true, completion: nil)
	}

}
