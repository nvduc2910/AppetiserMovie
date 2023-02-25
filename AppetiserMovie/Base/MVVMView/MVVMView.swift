//
//  MVVMView.swift
//  AppetiserMovie
//
//  Created by Duckie N on 2/24/23.
//

import Foundation

protocol MVVMView {
    
    associatedtype ViewModel: BaseViewModel
    
    var viewModel: ViewModel! { get set }
    
    func bind(to viewModel: ViewModel)
}
