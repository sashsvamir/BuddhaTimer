//
//  HealthKitManager.swift
//  BuddhaTimer
//
//  Created by x115 on 08/10/17.
//  Copyright © 2017 x115. All rights reserved.
//

import Foundation
import HealthKit


class HealthKitManager: NSObject {

	var available = false
	var healthKitStore: HKHealthStore?
	var hkType: HKCategoryType?



	override init() {
		super.init()

		// Just in case when app runnings on iPad...
		if !(HKHealthStore.isHealthDataAvailable()) {
			return
		}

		available = true
		healthKitStore = HKHealthStore()
		hkType = HKCategoryType.categoryType(forIdentifier: .mindfulSession)!
	}



	/**
	 * @see: https://forums.developer.apple.com/thread/53844
	 */
	func authorizeHealthKit(completion: ((Bool, Error?) -> Void)!) {

		if !(available) {
			let msg = "HealthKit not available on this Device"
			let error = NSError(domain: "99.BuddhaTimer", code: 2, userInfo: [NSLocalizedDescriptionKey:msg])
			if(completion != nil) {
				completion(false, error)
			}
			return
		}

		// State the health data types we want to read/write in HealthKit.
		let hkTypesToWrite: Set = [hkType!]

		// Request authorization to read and/or write the specific data.
		healthKitStore!.requestAuthorization(toShare: hkTypesToWrite, read: nil, completion: completion)

	}



	func authorizationStatus() -> HKAuthorizationStatus {
		return healthKitStore!.authorizationStatus(for: hkType!)
	}



	func saveMeditation(seconds:Int, endDate: Date = Date(), completion: ((Bool, Error?) -> Void)!) {

		let authStatus: HKAuthorizationStatus = authorizationStatus()

		if (authStatus != HKAuthorizationStatus.sharingAuthorized) {
			if (completion != nil) {
				let msg = "Cant write meditation"
				let error = NSError(domain: "99.BuddhaTimer", code: authStatus.rawValue, userInfo: [NSLocalizedDescriptionKey:msg])
				completion(false, error)
			}
			return
		}

		let startDate = Date.init(timeInterval: TimeInterval(-seconds), since: endDate)
		let mindfulSample = HKCategorySample(type: hkType!, value: 0, start: startDate, end: endDate)
		healthKitStore!.save(mindfulSample, withCompletion: completion)
	}



}
