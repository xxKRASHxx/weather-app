//
//  Initialize.swift
//  WeatherAppCore
//
//  Created by Daniel Lisovoy on 05.10.2019.
//  Copyright © 2019 Daniel Lisovoy. All rights reserved.
//

import Swinject

public func initialize() {
  let _ = AppStore.shared
  let _ = LocationService.shared
  let _ = WeatherService.shared
  let _ = StorageService.shared
  let _ = PhotosService.shared
}
