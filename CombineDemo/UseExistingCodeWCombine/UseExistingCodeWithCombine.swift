//
//  UseExistingCodeWithCombine.swift
//  CombineDemo
//
//  Created by Purplle on 10/03/22.
//

import UIKit
import Combine

class UseExistingCodeWithCombine: UIViewController {

    var cancelable = Set<AnyCancellable>()

    @Published var userName: String = ""
    
    var validatedUserName: AnyPublisher<String?,Never> {
        return $userName
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .removeDuplicates()
            .flatMap { userNAme in
                return Future { promise in
                    HttpsManager.fetchEmail(userName: userNAme) { result in
                        switch result {
                        case .success(let emailID):
                            promise(.success(emailID[0].email))
                        case .failure(let error):
                            print(error)
                        }
                    }
                }
                
            }
            .eraseToAnyPublisher()
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        validatedUserName.sink { value in
          print(value ?? "")
        }
        .store(in: &cancelable)
        
        // assign some value to username
        self.userName = "a@b.com"
    }
    
    func serviceCall()  {
        HttpsManager2.fetchEmail()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("finished")
                case .failure(let error):
                    print(error)
                }
            }, receiveValue: { [weak self] value in
                print(value[0].email)
                
            }).store(in: &cancelable)
    }
}

//MARK: If you don't want to change in the API manager, then how to use
class HttpsManager {
   class func fetchEmail(userName: String, completion: @escaping (Result<[EmailID],Error>)->Void ){
        let email = [EmailID(email: "a@b.com"), EmailID(email: "a@b.com"), EmailID(email: "a@b.com"), EmailID(email: "a@b.com"), EmailID(email: "a@b.com")]
        DispatchQueue.main.asyncAfter(deadline: .now()+3) {
          completion(.success(email))
        }
    }
}


//MARK: If you  want to change in the API manager, then how to use
class HttpsManager2 {
    
    // convert to Future publisher
    class func fetchEmail() -> AnyPublisher<[EmailID],Never> {
        return Future { promixe in
            DispatchQueue.main.asyncAfter(deadline: .now()+3) {
                promixe(.success([EmailID(email: "a@b.com"), EmailID(email: "a@b.com"), EmailID(email: "a@b.com"), EmailID(email: "a@b.com"), EmailID(email: "a@b.com")]))
            }
            
        }.eraseToAnyPublisher()
    }
    
    // Use closer
   class func fetchEmail(userName: String, completion: @escaping (Result<[EmailID],Error>)->Void ){
        let comapny = [EmailID(email: "a@b.com"), EmailID(email: "a@b.com"), EmailID(email: "a@b.com"), EmailID(email: "a@b.com"), EmailID(email: "a@b.com")]
        DispatchQueue.main.asyncAfter(deadline: .now()+3) {
          completion(.success(comapny))
        }
    }
}

struct EmailID {
    let email: String
}
