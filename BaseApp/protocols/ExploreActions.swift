//
//  ExploreActions.swift
//  BaseApp
//
//  Created by Ihab yasser on 27/04/2024.
//

import Foundation
protocol ExploreActions {
    func viewAllCompanies()
    func viewAllOffers()
    func viewAllNewArrivals()
    func viewAllTopPicks()
    func viewAllPlanners()
    func show(vendor:Vendor)
    func show(category:Category)
    func show(planner:Planner)
    func show(banner:Banner)
    func show(product:Product)
}
