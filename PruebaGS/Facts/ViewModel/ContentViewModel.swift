//
//  ContentViewModel.swift
//  PruebaGS
//
//  Created by PEDRO MENDEZ on 30/07/24.
//

import Foundation
import Combine



class ContentViewModel {
    
    // Private variables because they are only used within the view model
    private var service: BreedService
    private var cancellables = Set<AnyCancellable>()

    // Using PassthroughSubject to emit changes that the view can observe
    let breedsSubject = PassthroughSubject<[BreedViewData], Never>()
    let isLoadingSubject = PassthroughSubject<Bool, Never>()
    let errorSubject = PassthroughSubject<Error, Never>()

    // Initializer with the service for dependency injection
    // The service is injected into the view model
    init(service: BreedService) {
        self.service = service
    }
    
    // fetchData method
    func fetchData() {
        isLoadingSubject.send(true) // When data is fetched, set isLoading to true to show the ProgressBar
        
        // Here the service method is used with Combine (reactive programming)
      
        service.fetchBreeds()
            .receive(on: DispatchQueue.main) // Notify on which thread the data will be received
            .map { breedData in // Map (add an index:Int and also create a new structure that has that Int)
                var index = 0 // This int does not exist in the service documentation, so it is added separately
                return breedData.data.map {
                    index += 1
                    return BreedViewData(id: index, breed: $0) // A new model is created that already has the int value
                }
            }.sink(receiveCompletion: { completion in // sink receives the value
                switch completion {
                case .finished: break // this means you receive the data
                case .failure(let failure):
                    // TODO: - Handle Error
                    self.errorSubject.send(failure) // Handle error
                    print(failure) // Handle error
                }
            }, receiveValue: {[weak self] breeds in // Here receive the value
                self?.breedsSubject.send(breeds) // The value is passed to the view model
                self?.isLoadingSubject.send(false) // Set false so the view shows the list
            })
            .store(in: &cancellables) // This is to store the Combine value in memory and execute it
                                      // Without this cancellable, the method does not work, it is necessary to have it
    }
}

