//
//  UIStoryBoard.swift
//  ticonMoa
//
//  Created by 채훈기 on 2021/03/31.
//

import UIKit

extension UIStoryboard {
    func instantiate<T>() -> T? {
        return instantiateViewController(withIdentifier: String(describing: T.self)) as? T
    }
    
    func instantiate<T>(name: String) -> T? {
        return instantiateViewController(withIdentifier: name) as? T
    }

    static let main = UIStoryboard(name: "Main", bundle: nil)
}
