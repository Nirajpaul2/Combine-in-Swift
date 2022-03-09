//
//  ViewController.swift
//  CombineDemo
//
//  Created by Purplle on 04/03/22.
//

import UIKit
import Combine
class ViewController: UIViewController {
    
    var viewModel = HomeViewModel()
    var viewModel2 = UserDataViewModel()
    var viewModel3 = UserDataViewModel_Zip()
    
    
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //  viewModel.getHomeData()
        // bindViewModel()
        // justFunction()
        //timerPublisher()
        
        // viewModel2.getUserAlldata()
        //pubSubLifeCycle()
        customSubscriber()
    }
    
    //MARK: FUTURE() 😈
    //get it value from viewModel
    
    func bindViewModel(){
        viewModel.$albums.receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                _ = self?.viewModel.albums
                
            }.store(in: &cancellables)
    }
    
    
    //MARK: JUST() 😈
    //A publisher that emits an output to each subscriber just once, and then finishes.
    //struct Just<Output> : Publisher
    func justFunction(){
        _ = Just(5).map{
            value -> String in
            "value is \(value)"
        }.sink(receiveValue: { val in
            print(val)
        })
    }
    
    
    //MARK: TIMER() 😈
    // Emits repeatedly after a defined time interval.
    // Used for stopwatches and timers
    func timerPublisher() {
        let time = Timer.publish(every: 1, on: .main, in: .default).autoconnect().eraseToAnyPublisher()
        print(time)
    }
    
    //MARK: Pub Sub lifecycle 😈
    func addTwoNumbers(a: Int,b: Int) -> Int {
        return a+b
    }
    
    func pubSubLifeCycle() {
        
        let justPublisher = Just(addTwoNumbers(a: 2, b: 5))
        
        let justSubscriber = Subscribers.Sink<Int, Never> { completion in
            switch completion {
            case .failure(let error):
                print(error)
            case .finished:
                print("finish")
            }
        } receiveValue: { valuefromPub in
            print("PubValue:  \(valuefromPub)")
        }
        justPublisher.print().subscribe(justSubscriber)
        
    }
    
    //MARK: Assign Subscription 😈
   // Assign to sub
    func assignToSubscriber() {
        let model = MyModel()
        
        model.$id.sink { val in
            print(val)
        }.store(in: &cancellables)
        
        let myRange = (0...2)
        myRange.publisher.assign(to: &model.$id)

    }
    
    // Assign to on sub
    func assignToOnSubscriber() {
        let myObject = MyClass()

        let myRange = (0...2)
        myRange.publisher
            .assign(to: \.anInt, on: myObject).store(in: &cancellables)
    }
    
    //MARK: Custom subscriber 😈
    func customSubscriber() {
        let publisher = (1...6).publisher
        
        let customSubscriber = IntSubscriber()
        publisher.subscribe(customSubscriber)
        
    }
}


class MyClass {
    var anInt: Int = 0 {
        didSet {
            print("anInt was set to: \(anInt)", terminator: "; ")
        }
    }
}

class MyModel {
    @Published var id: Int = 0
}
