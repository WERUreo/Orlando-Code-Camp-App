//
//  ReusableView.swift
//  OrlandoCodeCamp
//
//  Created by Keli'i Martin on 3/31/17.
//  Copyright © 2017 WERUreo. All rights reserved.
//

import UIKit

protocol ReusableView: class {}

extension ReusableView where Self: UIView
{
    static var reuseIdentifier: String
    {
        return String(describing: self)
    }
}

extension UITableViewCell: ReusableView {}
