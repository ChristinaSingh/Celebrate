//
//  Filter.swift
//  BaseApp
//
//  Created by Ihab yasser on 07/06/2024.
//

import Foundation
protocol Filter {
    func apply(prices: PriceFilter?, stores:[Vendor])
}
