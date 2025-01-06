//
//  Router.swift
//  xSpend
//
//  Created by Mike Paraskevopoulos on 6/1/25.
//

import Foundation
import SwiftUI


enum Destination: Hashable {
    case landingScreen
    case login
    case signUp
    case tabManager
    case expenseDetail(
        addNewExpenseViewModel:AddNewExpenseViewModel,
        fbViewModel: FirebaseViewModel,
        viewType: ExpenseDetailViewType
    )
    case expenseTypes(fbViewModel: FirebaseViewModel)
}

final class Router: ObservableObject {
    
    @Published var navPath = NavigationPath()
    
    func navigate(to destination: Destination) {
        navPath.append(destination)
    }
    
    func navigateBack() {
        navPath.removeLast()
    }
    
    func navigateToRoot() {
        navPath.removeLast(navPath.count)
    }
}
