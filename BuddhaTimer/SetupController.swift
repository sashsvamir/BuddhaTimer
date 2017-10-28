//
//  SetupController.swift
//  BuddhaTimer
//
//  Created by x115 on 08/10/17.
//  Copyright © 2017 x115. All rights reserved.
//

import UIKit
import Foundation


class SetupController: UIViewController {

	let helper = Helper()


	@IBAction func playSoundButton(sender: AnyObject) {
		playSound()
	}



	/*
	override func viewDidLoad() {
		super.viewDidLoad()
	}
	*/


	/*
	override func viewWillAppear(_ animated: Bool) {
	}*/

	
	func playSound() {
		helper.playSound()
	}
	

}
