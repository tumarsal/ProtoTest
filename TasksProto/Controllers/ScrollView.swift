//
//  ScrollView.swift
//  TasksProto
//
//  Created by tumarsal on 31.07.2021.
//

import Foundation
import UIKit


class UIScrollViewController:UIViewController {
    weak var scrollView: UIScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.scrollView = view.find()
        NotificationCenter.default.addObserver(
          self,
          selector: #selector(keyboardWillShow(_:)),
          name: UIResponder.keyboardWillShowNotification,
          object: nil)

        NotificationCenter.default.addObserver(
          self,
          selector: #selector(keyboardWillHide(_:)),
          name: UIResponder.keyboardWillHideNotification,
          object: nil)
        self.scrollView.keyboardDismissMode = .onDrag
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let bottomConstrint =  scrollView.constraints.find({ (c) -> Bool in
            c.firstAttribute == .bottom
        }) {
            
            if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                    let keyboardHeight = keyboardSize.height
                bottomConstrint.constant = keyboardHeight
                if let textField = view.firstResponderTextField  {
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.01) {
                        self.scrollView.scrollToView(view: textField, animated: true)
                    }
                    
                }
                
            }
        }
       
    }
    @objc func keyboardWillHide(_ notification: Notification) {
        if let bottomConstrint =  scrollView.constraints.find({ (c) -> Bool in
            c.firstAttribute == .bottom
        }) {
            bottomConstrint.constant = 0
        }
    }
    func hideKeyboard(){
       self.view.endEditing(true)
    }
}
extension UIView {
    func find<T>() -> T? where T:UIView {
       

        for subview in subviews {
            if let firstResponder = subview as? T {
                return firstResponder
            }
        }

        return nil
    }
    var firstResponder: UIView? {
        guard !isFirstResponder else { return self }

        for subview in subviews {
            if let firstResponder = subview.firstResponder {
                return firstResponder
            }
        }

        return nil
    }
    var firstResponderTextField: UITextField? {
        if isFirstResponder {
            if let firstResponder = self as? UITextField {
                return firstResponder
            }
        }

        for subview in subviews {
            if let firstResponder = subview.firstResponder as? UITextField {
                return firstResponder
            } else {
                
            }
        }

        return nil
    }
}
extension UIScrollView {

    // Scroll to a specific view so that it's top is at the top our scrollview
    func scrollToView(view:UIView, animated: Bool) {
          if let origin = view.superview {
              // Get the Y position of your child view
            let childStartPoint = origin.convert(view.frame.origin, to: self)
              // Scroll to a rectangle starting at the Y of your subview, with a height of the scrollview
            self.scrollRectToVisible(CGRect(x:0, y:childStartPoint.y,width: view.frame.width,height: self.frame.height), animated: animated)
          }
      }

    // Bonus: Scroll to top
    func scrollToTop(animated: Bool) {
        let topOffset = CGPoint(x: 0, y: -contentInset.top)
        setContentOffset(topOffset, animated: animated)
    }

    // Bonus: Scroll to bottom
    func scrollToBottom() {
        let bottomOffset = CGPoint(x: 0, y: contentSize.height - bounds.size.height + contentInset.bottom)
        if(bottomOffset.y > 0) {
            setContentOffset(bottomOffset, animated: true)
        }
    }

}

