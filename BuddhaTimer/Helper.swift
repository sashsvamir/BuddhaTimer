//
//  Helper.swift
//  BuddhaTimer
//
//  Created by x115 on 10/10/17.
//  Copyright © 2017 x115. All rights reserved.
//

import Foundation
import AVFoundation
import AudioToolbox
import UIKit


class Helper {


	let paramTime = "lastElapsedTime"
	var audioPlayer:AVAudioPlayer!


	// convert second to human readably time
	func secondsToMinutes (seconds: Int) -> (String) {
		let hour = seconds / 3600
		let minutes = (seconds % 3600) / 60
		let seconds = (seconds % 3600) % 60
		return String(format:"%d:%02d:%02d", hour, minutes, seconds)
	}



	// save data
	func saveTime(value: Int) {
		UserDefaults.standard.set(value, forKey: paramTime)
	}
	// get data
	func getTime() -> Int {
		return UserDefaults.standard.integer(forKey: paramTime)
	}



	func playSound() {
		do {
			try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, with: AVAudioSessionCategoryOptions.duckOthers)
		}
		catch {
			print("Error play sound")
		}
		//AudioServicesPlayAlertSoundWithCompletion(1008, nil)
		let audioFilePath = Bundle.main.path(forResource: "chime", ofType: "aif")
		if audioFilePath != nil {
			let audioFileUrl = URL.init(fileURLWithPath: audioFilePath!)
			do {
				try audioPlayer = AVAudioPlayer.init(contentsOf: audioFileUrl)
				audioPlayer.play()
			}
			catch {
				print("Error audioPlayer.play() sound")
			}
		} else {
			print("audio file not found")
		}
	}

}
