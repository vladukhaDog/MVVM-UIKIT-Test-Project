//
//  HotelListViewModel.swift
//  TestTask
//
//  Created by Владислав Пермяков on 07.11.2022.
//

import Foundation
import Combine

class HotelListViewModel: ObservableObject{
    @Published public var hotels: [Hotel] = []
    
    init(){
        self.updateHotelsList()
    }
    
    ///сортирует массив
    @objc func sortByDistance(){
        DispatchQueue.main.async {
            self.hotels = self.hotels.sorted(by: { ls, rs in
                ls.distance < rs.distance
            })
        }
    }
    @objc func sortByAvailable(){
        DispatchQueue.main.async {
            self.hotels = self.hotels.sorted(by: { ls, rs in
                ls.availableSuites().count < rs.availableSuites().count
            })
        }
    }
    
    @objc func updateHotelsList(){
        Task{
            do{
                let response = try await NetworkManager.shared.getHotelsList()
                DispatchQueue.main.async { [weak self] in
                    self?.hotels = response
                }
            }catch{
                print("got error")
            }
        }

    }
}
