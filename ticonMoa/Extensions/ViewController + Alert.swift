//
//  Alert.swift
//  ticonMoa
//
//  Created by 채훈기 on 2021/07/16.
//  Copyright © 2021 hoon. All rights reserved.
//

import UIKit

extension UIViewController {
    func alert(message: String, title: String = "") {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
}

extension UIViewController {
  typealias AlertActionHandler = ((UIAlertAction) -> Void)
  
  func alert(title: String,
             message: String? = nil,
             okTitle: String = "OK",
             okHandler: AlertActionHandler? = nil,
             okStyle: UIAlertAction.Style,
             cancelTitle: String? = nil,
             cancelHandler: AlertActionHandler? = nil,
             completion: (() -> Void)? = nil) {
    
    let alert: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    
    if let okClosure = okHandler {
        let okAction: UIAlertAction = UIAlertAction(title: okTitle, style: okStyle, handler: okClosure)
      alert.addAction(okAction)
        let cancelAction: UIAlertAction = UIAlertAction(title: cancelTitle, style: UIAlertAction.Style.cancel, handler: cancelHandler)
      alert.addAction(cancelAction)
    } else {
        if cancelTitle != nil {
            let cancelAction: UIAlertAction = UIAlertAction(title: okTitle, style: okStyle, handler: cancelHandler)
            alert.addAction(cancelAction)
        } else {
            let cancelAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: cancelHandler)
            alert.addAction(cancelAction)
        }
        
    }
    self.present(alert, animated: true, completion: completion)
  }
}
