//
//  MovieListViewModel.swift
//  AppetiserMovie
//
//  Created by Duckie N on 2/24/23.
//

import Foundation
import RxSwift
import RxCocoa
import RxSwiftExt
import Action

protocol MovieListViewModelType {
    
}

struct MovieListViewModelInput {
    var getAPIStream: Observable<Void>
}

struct MovieListViewModelOutput {
    let itemsStream: BehaviorRelay<[String]>
    let errorStream: Observable<String>
    let isLoadingStream: Observable<Bool>
}

final class MovieListViewModel: BaseViewModel, MovieListViewModelType {
    
    let input: MovieListViewModelInput
    let output: MovieListViewModelOutput
    
    // MARK: - input ref
    let getAPIStreamPublish = PublishRelay<Void>()
    
    // MARK: - output ref
    let itemsRelay = BehaviorRelay<[String]>(value: [])
    let errorPublish = PublishRelay<String>()
    let isLoadingPublish = PublishRelay<Bool>()
    
    private var disposeBag = DisposeBag()
    
    init() {
        input = MovieListViewModelInput(getAPIStream: getAPIStreamPublish.asObservable())
        output = MovieListViewModelOutput(itemsStream: itemsRelay,
                                          errorStream: errorPublish.asObservable(),
                                          isLoadingStream: isLoadingPublish.asObservable())
        
        configureInput()
        configureOutput()
        configureGetMovieList()
    }
    
    func configureInput() {
        getAPIStreamPublish.subscribeNext { [weak self] _ in
            guard let self = self else { return }
            // CALL API here
        }.disposed(by: disposeBag)
    }
    
    func configureOutput() {
        
    }
    
    func configureGetMovieList() {
        
    }
    
    func viewDidLoad() {
        isLoadingPublish.accept(true)
    }
}
