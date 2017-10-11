//
//  ViewController.swift
//  BuddhaTimer
//
//  Created by x115 on 07/10/17.
//  Copyright © 2017 x115. All rights reserved.
//

import UIKit
import Foundation
import UserNotifications


class ViewController: UIViewController {

	let healthManager = HealthKitManager()
	let helper = Helper()

	var timerElapsedActive = false
	var timerExcessActive = false

	var ElapsedTimer = Timer()
	var ExcessTimer = Timer()
	var elapsedCounter = 0
	var excessCounter = 0


	
	@IBOutlet var startButton: UIBarButtonItem!
	@IBOutlet var stopButton: UIBarButtonItem!
	@IBOutlet var elapsedLabel: UILabel!
	@IBOutlet var excessLabel: UILabel!
	@IBOutlet var plusMinButton: UIButton!
	@IBOutlet var minusMinButton: UIButton!
	@IBOutlet var plusSecButton: UIButton!
	@IBOutlet var minusSecButton: UIButton!


	@IBAction func startButton(sender: AnyObject) {
		start()
	}
	@IBAction func stopButton(sender: AnyObject) {
		stop()
	}
	@IBAction func plusMinButton(sender: AnyObject) {
		if (timerExcessActive || timerElapsedActive) {
			return
		}
		elapsedCounter += 60
		refreshTimers()
	}
	@IBAction func minusMinButton(sender: AnyObject) {
		if (timerExcessActive || timerElapsedActive) {
			return
		}
		if (elapsedCounter >= 60) {
			elapsedCounter -= 60
			refreshTimers()
		}
	}
	@IBAction func plusSecButton(sender: AnyObject) {
		if (timerExcessActive || timerElapsedActive) {
			return
		}
		elapsedCounter += 1
		refreshTimers()
	}
	@IBAction func minusSecButton(sender: AnyObject) {
		if (timerExcessActive || timerElapsedActive) {
			return
		}
		if (elapsedCounter > 0) {
			elapsedCounter -= 1
			refreshTimers()
		}
	}
	
	
	//var backgroundTaskIdentifier: UIBackgroundTaskIdentifier?
	//func startBackgroundUsing() {
	//	backgroundTaskIdentifier = UIApplication.shared.beginBackgroundTask(expirationHandler: {
	//		UIApplication.shared.endBackgroundTask(self.backgroundTaskIdentifier!)
	//	})
	//}


	/*
	 * Нажали запуск тамера
	 */
	func start() {
		if (timerExcessActive || timerElapsedActive) {
			return
		}

		excessCounter = 0
		refreshTimers()

		setTimeButtonsStatus(status: false)
		startButton.isEnabled = false
		stopButton.isEnabled = true

		helper.saveTime(value: elapsedCounter) // save data

		ElapsedTimer = Timer.scheduledTimer(
			timeInterval: 1,
			target: self,
			selector: #selector(self.updateElapsedCounter),
			userInfo: nil,
			repeats: true)

		// prevent dim screen and sleep
		UIApplication.shared.isIdleTimerDisabled = true

		timerElapsedActive = true
	}


	/*
	 * Нажали стоп тамер
	 */
	func stop() {
		if (!timerExcessActive && !timerElapsedActive) {
			return
		}

		ElapsedTimer.invalidate()
		ExcessTimer.invalidate()

		// расчитваем время медитации
		let total = helper.getTime() - elapsedCounter + excessCounter

		// enables dim screen back
		UIApplication.shared.isIdleTimerDisabled = false

		// предложим сохранить общее время
		requestSaveResult(total: total)

		elapsedCounter = helper.getTime()
		refreshTimers()

		setTimeButtonsStatus(status: true)
		startButton.isEnabled = true
		stopButton.isEnabled = false

		timerElapsedActive = false
		timerExcessActive = false
	}


	private func refreshTimers() {
		elapsedLabel.text = Helper().secondsToMinutes(seconds: elapsedCounter)
		excessLabel.text = Helper().secondsToMinutes(seconds: excessCounter)
	}

	private func setTimeButtonsStatus(status: Bool) {
		plusMinButton.isEnabled = status
		minusMinButton.isEnabled = status
		plusSecButton.isEnabled = status
		minusSecButton.isEnabled = status
	}


	func updateElapsedCounter() {
		elapsedCounter -= 1
		refreshTimers()
		if (elapsedCounter <= 0) {
			print("🔥 Fire!")
			stopElapsedTimer()
			startExcessTimer()
			helper.playSound()
		}
	}

	private func stopElapsedTimer() {
		timerElapsedActive = false
		ElapsedTimer.invalidate()
		refreshTimers()
	}

	private func startExcessTimer() {
		timerExcessActive = true
		ExcessTimer = Timer.scheduledTimer(
			timeInterval: 1,
			target: self,
			selector: #selector(self.updateExcessCounter),
			userInfo: nil,
			repeats: true)
	}

	func updateExcessCounter() {
		excessCounter += 1
		refreshTimers()
	}




	private func requestSaveResult(total: Int) {
		// show Modal to saving result
		let modalSave = storyboard?.instantiateViewController(withIdentifier: "ModalSave") as! ModalSaveController
		modalSave.healthManager = healthManager
		modalSave.result = total
		modalSave.sender = self
		present(modalSave, animated: true, completion: nil)
	}

	
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		
		// get permanent data
		elapsedCounter = helper.getTime()
		refreshTimers()

		// HealthKit Authorize
		healthManager.requestAuthorize{ (success:Bool,  error:Error?) -> Void in
			guard success else {
				print("😡 Permission modal filed")
				if error != nil {
					print("Reason: \(error?.localizedDescription)")
				}
				return
			}
			print("😀 Permission window success")
		}

//		let alert = UIAlertController(title: nil, message: "Message", preferredStyle: .alert)
//		alert.addAction(UIAlertAction(title: "O.K.", style: .default, handler: nil))
//		present(alert, animated: true, completion: nil)
	}






}

