//
//  ZipPublisher.swift
//  CombineDemo
//
//  Created by Purplle on 07/03/22.
//

import Foundation
import Combine

class UserDataViewModel_Zip {
    
    private var cancellables = Set<AnyCancellable>()
    private var albumModel: [Album]?
    private var userModel: [User]?

    //This is similar to DispatchGroup in swift
    // Two API call
    func getUserAlldata() {
        Publishers.Zip(
            getPublisher(for: Album.self, url: .albums),
            getPublisher(for: User.self, url: .posts)
       ).sink { completion in
           switch completion {
           case .failure(let error):
               print(error)
           case .finished:   // .finished will execute, when All API call is done
               print("finshed")
           }
       } receiveValue: { album,user in
           self.albumModel = album
           self.userModel = user
       }.store(in: &cancellables)
    }
    
    // Three API call
    func getUserAlldata_3APICall() {
        Publishers.Zip3(
            getPublisher(for: Album.self, url: .albums),
            getPublisher(for: User.self, url: .posts),
            getPublisher(for: User.self, url: .posts)
       ).sink { completion in
           switch completion {
           case .failure(let error):
               print(error)
           case .finished:    // .finished will execute, when All API call is done
               print("finshed")
           }
       } receiveValue: { album,user, user2 in
           print(album)
           print(user)
           print(user2)
       }.store(in: &cancellables)
    }

    // Three API call
    func getUserAlldata_4APICall() {
        Publishers.Zip4(
            getPublisher(for: Album.self, url: .albums),
            getPublisher(for: User.self, url: .posts),
            getPublisher(for: User.self, url: .posts),
            getPublisher(for: User.self, url: .posts)
       ).sink { completion in
           switch completion {
           case .failure(let error):
               print(error)
           case .finished:            // .finished will execute, when All API call is done
               print("finshed")
           }
       } receiveValue: { album,user, user2, user3 in
           print(album)
           print(user)
           print(user2)
           print(user3)
       }.store(in: &cancellables)
    }
    
    
    func getPublisher<T:Decodable>(for type: T.Type, url: Endpoint) -> Future<[T], Error> {
        ApiManager.shared.getAlbums(endpoint: url, type: type)
    }
}
