//
//  Extensions.swift
//  PruebaGS
//
//  Created by PEDRO MENDEZ on 30/07/24.
//

import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach({
            addSubview($0)
        })
    }
}
