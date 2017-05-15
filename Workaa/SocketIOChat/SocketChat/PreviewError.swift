//
//  PreviewError.swift
//  Workaa
//
//  Created by IN1947 on 09/12/2016.
//  Copyright © 2016 IN1947. All rights reserved.
//
import Foundation

public enum PreviewError: Error, CustomStringConvertible {
  case noURLHasBeenFound(String?)
  case invalidURL(String?)
  case cannotBeOpened(String?)
  case parseError(String?)
  
  public var description: String {
    switch(self) {
      case .noURLHasBeenFound: return NSLocalizedString("No URL has been found", comment: "")
      case .invalidURL: return NSLocalizedString("This data is not valid URL", comment: "")
      case .cannotBeOpened: return NSLocalizedString("This URL cannot be opened", comment: "")
      case .parseError: return NSLocalizedString("An error occurred when parsing the HTML", comment: "")
    }
  }
}
