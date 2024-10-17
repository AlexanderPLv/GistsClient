//
//  Presentable.swift
//  GistsClient
//
//  Created by Alexander Pelevinov on 16.10.2024.
//

import UIKit

protocol Presentable {
    var toPresent: UIViewController? { get }
}
 
extension UIViewController: Presentable {
    var toPresent: UIViewController? {
        return self
    }
}
