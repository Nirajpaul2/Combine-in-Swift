//
//  CustomSubscriber.swift
//  CombineDemo
//
//  Created by Purplle on 08/03/22.
//

import Foundation
import Combine

 enum MyError: Error {
   case test
 }

final class IntSubscriber: Subscriber {
    
    func receive(completion: Subscribers.Completion<MyError>) {
        print("Received completion", completion)
    }
    
    typealias Input = Int
    
    typealias Failure = Never
    
    //You did not receive a completion event. This is because the publisher has a finite number of values, and you specified a demand of .max(3).
    func receive(subscription: Subscription) {
        subscription.request(.max(3))
       // subscription.request(.unlimited)
    }
    
    func receive(_ input: Int) -> Subscribers.Demand {
        print("Received value", input)
        return .none
    }
    
    func receive(completion: Subscribers.Completion<Never>) {
        print("Received completion", completion)
    }

}
