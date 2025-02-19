//
//  AppGroup.swift
//  Voley Stats
//
//  Created by Pau Hermosilla on 5/7/24.
//

import Foundation

public enum AppGroup: String {
  case database = "group.voleystats.database"

  public var containerURL: URL {
    switch self {
    case .database:
      return FileManager.default.containerURL(
      forSecurityApplicationGroupIdentifier: self.rawValue)!
    }
  }
}
