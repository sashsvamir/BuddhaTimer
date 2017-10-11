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

	var healthKitStore: HKHealthStore = HKHealthStore()
	var hkType: HKCategoryType = HKObjectType.categoryType(forIdentifier: .mindfulSession)!


	//	override init() {
	//		super.init()
	//
	//	}


	/**
	 * Перечислим ошибки
	 */
	enum HealthkitSetupError: LocalizedError {
		case notAvailableOnDevice
		case sharingDenied

		var errorDescription: String? {
			switch self {
				case .notAvailableOnDevice:
					return "HealthKit not available on this Device"
				case .sharingDenied:
					return "Cant write meditation"
			}
		}
	}


	/**
	 * Окно авторизации
	 * @see: forums.developer.apple.com/thread/53844
	 */
	func requestAuthorize(completion: ((Bool, Error?) -> Void)!) {

		guard HKHealthStore.isHealthDataAvailable() else {
			completion(false, HealthkitSetupError.notAvailableOnDevice)
			return
		}

		// создаем набор данных которые будем писать в HealthKit
		let hkTypesToWrite: Set = [hkType]

		// запросим разрешение у пользователя
		healthKitStore.requestAuthorization(toShare: hkTypesToWrite, read: nil, completion: completion)
	}


	/**
	 * Сохраним данные
	 */
	func saveMeditation(seconds:Int, endDate: Date = Date(), completion: ((Bool, Error?) -> Void)!) {

		// узнаем есть ли доступ для записи данных
		if !isAvailable() {
			completion(false, HealthkitSetupError.sharingDenied)
			return
		}

		// сохраняем данные
		let startDate = Date.init(timeInterval: TimeInterval(-seconds), since: endDate)
		let mindfulSample = HKCategorySample(type: hkType, value: 0, start: startDate, end: endDate)
		healthKitStore.save(mindfulSample, withCompletion: completion)
	}


	/**
	 * Узнаем есть ли доступ для записи данных
	 */
	func isAvailable() -> Bool {
		return healthKitStore.authorizationStatus(for: hkType) == HKAuthorizationStatus.sharingAuthorized
	}

}
