//
//  ICBackspaceTextField.swift
//  iCook
//
//  Created by Ben on 02/03/2016.
//  Copyright © 2016 Polydice, Inc.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import UIKit

protocol ICBackspaceTextFieldDelegate: class {
  func textFieldShouldDelete(_ textField: ICBackspaceTextField) -> Bool
}

////////////////////////////////////////////////////////////////////////////////


class ICBackspaceTextField: UITextField {

  weak var backspaceDelegate: ICBackspaceTextFieldDelegate?

  var showsCursor = true {
    didSet {
      // Trigger the lazy instantiation of cursorColor
      let color = cursorColor
      tintColor = showsCursor ? color : UIColor.clear
    }
  }

  lazy var cursorColor: UIColor! = { self.tintColor }()

  // MARK: - UIView

  override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
    // Forward touches to the superview when the cursor is hidden.
    return showsCursor && super.point(inside: point, with: event)
  }

  // MARK: - UITextField

  func keyboardInputShouldDelete(_ textField: UITextField) -> Bool {
    return backspaceDelegate?.textFieldShouldDelete(self) ?? true
  }

}
