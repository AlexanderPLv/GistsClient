//
//  UITableViewCell+Ext.swift
//  GistsClient
//
//  Created by Alexander Pelevinov on 18.10.2024.
//

import UIKit

extension UITableViewCell {
    static var reuseIdentifier: String {
        return String(describing: Self.self)
    }
}
