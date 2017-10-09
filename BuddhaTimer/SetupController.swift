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

	let healthManager = HealthKitManager()
	
	@IBAction func authorizeButton(sender: AnyObject) {}



//	override func viewDidLoad() {
//		super.viewDidLoad()
//	}

	override func viewWillAppear(_ animated: Bool) {
		// We cannot access the user's HealthKit data without specific permission.

		getHealthKitPermission()
	}
	
	
	func getHealthKitPermission() {
		healthManager.authorizeHealthKit { (success:Bool,  error:Error?) -> Void in
			if success {
				print("😀 Permission window success")
			} else {
				print("😡 Permission modal filed")
				if error != nil {
					print(error!)
				}
			}
		}
	}
	

}
