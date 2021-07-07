//
//  SearchViewModel.swift
//  ticonMoa
//
//  Created by 채훈기 on 2021/05/02.
//

import Foundation


protocol SearchViewModelInput {
    
}

protocol SearchViewModelOutput {
}

protocol SearchViewModelType {
    var input: SearchViewModelInput { get }
    var output: SearchViewModelOutput { get }
}

class SearchViewModel: SearchViewModelInput, SearchViewModelOutput, SearchViewModelType {
 
    var input: SearchViewModelInput { self }
    var output: SearchViewModelOutput { self }
 

    init() {
        
    }
    
}
