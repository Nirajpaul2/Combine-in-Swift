//
//  HomeViewModel.swift
//  CombineDemo
//
//  Created by Purplle on 07/03/22.
//

import Foundation
import Combine

class HomeViewModel {

    // Set of AnyCancellable will be use for retaining our subscription, so whatever publisher will be subscribing to we will retain and hold the subscribing.
    
    // we can store all the sink references in the Set AnyCancellable
    private var cancellables = Set<AnyCancellable>()
    
    // @Published property wrapper propery will automatically wright a willSet block for your property.whenever the propery will change, an observer will notify.
    @Published var albums = [Album]()
    
    
    func getHomeData() {
        
        ApiManager.shared.getAlbums(endpoint: .albums , type: Album.self)
            .sink { completion in
                switch completion {
                case .failure(let err):
                    print("Error is \(err.localizedDescription)")
                case .finished:
                    print("Finished")
                }
            }
            receiveValue: { [weak self] albums in
                self?.albums = albums
            }
            .store(in: &cancellables)
        }
}
