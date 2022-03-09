//
//  CombineLatest.swift
//  CombineDemo
//
//  Created by Purplle on 07/03/22.
//

import Foundation
import Combine

class UserDataViewModel {
    
    private var cancellables = Set<AnyCancellable>()
    @Published private(set) var albumModel: [Album]?
    @Published private(set) var userModel: [User]?

    func getUserAlldata() {
       Publishers.CombineLatest(
            getPublisher(for: Album.self, url: .albums),
            getPublisher(for: User.self, url: .posts)
       ).sink { completion in
           switch completion {
           case .failure(let error):
               print(error)
           case .finished:
               print("finshed") 
           }
       } receiveValue: { album,user in
           self.albumModel = album
           self.userModel = user
       }.store(in: &cancellables)

    }

    // 3 API call
    func getUserAlldata_3APICall() {
       Publishers.CombineLatest3(
            getPublisher(for: Album.self, url: .albums),
            getPublisher(for: User.self, url: .posts),
            getPublisher(for: User.self, url: .posts)
       ).sink { completion in
           switch completion {
           case .failure(let error):
               print(error)
           case .finished:
               print("finshed")
           }
       } receiveValue: { album,user,user2 in
           print(album)
           print(user)
           print(user2)
       }.store(in: &cancellables)

    }
    
    func getPublisher<T:Decodable>(for type: T.Type, url: Endpoint) -> Future<[T], Error> {
        ApiManager.shared.getAlbums(endpoint: url, type: type)
    }
}


