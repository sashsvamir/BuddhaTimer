//
//  ViewController.swift
//  BuddhaTimer
//
//  Created by x115 on 07/10/17.
//  Copyright © 2017 x115. All rights reserved.
//

import UIKit
import Foundation
import AVFoundation
import AudioToolbox
import UserNotifications

class ViewController: UIViewController {

	var ElapsedTimer = Timer()
	var ExcessTimer = Timer()
	var elapsedCounter = 0
	var excessCounter = 0

//	var backgroundTaskIdentifier: UIBackgroundTaskIdentifier?
	
	
	@IBOutlet var elapsedLabel: UILabel!
	@IBOutlet var excessLabel: UILabel!
	@IBOutlet var messageLabel: UILabel!
	
	@IBAction func startButton(sender: AnyObject) {
		startElapsedTimer()
		ExcessTimer.invalidate()
		// prevent dim screen and sleep
		UIApplication.shared.isIdleTimerDisabled = true
	}
	@IBAction func pauseButton(sender: AnyObject) {
		ElapsedTimer.invalidate()
		ExcessTimer.invalidate()
		// enables dim screen and sleep
		UIApplication.shared.isIdleTimerDisabled = false
	}
	@IBAction func defaultsButton(sender: AnyObject) {
		loadDefaults()
	}
	@IBAction func clearButton(sender: AnyObject) {
		clearElapsedTimer()
	}
	@IBAction func plusMinButton(sender: AnyObject) {
		elapsedCounter += 60
		updateTimers()
	}
	@IBAction func plusSecButton(sender: AnyObject) {
		elapsedCounter += 1
		updateTimers()
	}
	@IBAction func minusMinButton(sender: AnyObject) {
		if (elapsedCounter >= 60) {
			elapsedCounter -= 60
			updateTimers()
		}
	}
	@IBAction func minusSecButton(sender: AnyObject) {
		if (elapsedCounter > 0) {
			elapsedCounter -= 1
			updateTimers()
		}
	}
	
	
	
//	func startBackgroundUsing() {
//		backgroundTaskIdentifier = UIApplication.shared.beginBackgroundTask(expirationHandler: {
//			UIApplication.shared.endBackgroundTask(self.backgroundTaskIdentifier!)
//		})
//	}
	
	func updateTimers() {
		elapsedLabel.text = secondsToMinutes(seconds: elapsedCounter)
		excessLabel.text = secondsToMinutes(seconds: excessCounter)
	}
	
	func secondsToMinutes (seconds: Int) -> (String) {
		let hour = seconds / 3600
		let minutes = (seconds % 3600) / 60
		let seconds = (seconds % 3600) % 60
		return String(format:"%d:%02d:%02d", hour, minutes, seconds)
	}
	
	func startElapsedTimer() {
		messageLabel.text = "last timer is: " + secondsToMinutes(seconds: elapsedCounter)
		
		// save permanent data
		UserDefaults.standard.set(elapsedCounter, forKey: "lastElapsedTime")
		
//		startBackgroundUsing()
		
		ElapsedTimer = Timer.scheduledTimer(
			timeInterval: 1,
			target: self,
			selector: #selector(self.updateElapsedCounter),
			userInfo: nil,
			repeats: true)
		
	}
	
	func startExcessTimer() {
		ExcessTimer = Timer.scheduledTimer(
			timeInterval: 1,
			target: self,
			selector: #selector(self.updateExcessCounter),
			userInfo: nil,
			repeats: true)
	}
	
	func clearElapsedTimer() {
		ElapsedTimer.invalidate()
		elapsedCounter = 0
		
		ExcessTimer.invalidate()
		excessCounter = 0
		
		updateTimers()
	}
	
	func loadDefaults() {
		clearElapsedTimer()
		elapsedCounter = UserDefaults.standard.integer(forKey: "lastElapsedTime")
		updateTimers()
	}
	
	func updateElapsedCounter() {
		elapsedCounter -= 1
		updateTimers()
		if (elapsedCounter <= 0) {
			clearElapsedTimer()
			startExcessTimer()
			playSound()
		}
	}
	
	func updateExcessCounter() {
		excessCounter += 1
		updateTimers()
	}
	
	
	func playSound() {
		NSLog("Fire!")
		do {
//			print(AVAudioSession.sharedInstance().availableModes)
//			print(AVAudioSession.sharedInstance().availableCategories)
			try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, with: AVAudioSessionCategoryOptions.duckOthers)
		}
		catch {
			// report for an error
			NSLog("Error play sound")
		}
//		AudioServicesPlayAlertSoundWithCompletion(1008, nil)
		
		
		// Play sound
		let audioFilePath = Bundle.main.path(forResource: "chime", ofType: "aif")
		if audioFilePath != nil {
			let audioFileUrl = URL.init(fileURLWithPath: audioFilePath!)
			do {
				try audioPlayer = AVAudioPlayer.init(contentsOf: audioFileUrl)
				audioPlayer.play()
			}
			catch {
				NSLog("Error audioPlayer.play() sound")
			}
		} else {
			NSLog("audio file not found")
		}
//		let path = Bundle.main.path(forResource: "chime", ofType:"aif")!
//		let url = URL(fileURLWithPath: path)
//		do {
//			let sound = try AVAudioPlayer(contentsOf: url)
//			self.player = sound
//			sound.numberOfLoops = 1
//			sound.prepareToPlay()
//			sound.play()
//		} catch {
//			print("error loading file")
//		}
	}
	var audioPlayer:AVAudioPlayer!
//	var player : AVAudioPlayer?
	

	
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		
		// get permanent data
		elapsedCounter = UserDefaults.standard.integer(forKey: "lastElapsedTime")
		
		updateTimers()
		
		
	}
	
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}


}

