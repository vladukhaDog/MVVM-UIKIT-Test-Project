//
//  HotelDetailViewModel.swift
//  TestTask
//
//  Created by Владислав Пермяков on 07.11.2022.
//

import Foundation
import Combine
import UIKit

class HotelDetailViewModel: ObservableObject{
    @Published var hotel: Hotel
    @Published var hotelImage: UIImage?
    
    init(hotel: Hotel) {
        self.hotel = hotel
        self.fetchData()
    }
    public func getRouteAlert() -> UIAlertController?{
        
        //предохраняемся данными
        if let long = hotel.lon, let lat = hotel.lat{
            let coordsString = "\(lat),\(long)"
            //создаем алерт
            let alert = UIAlertController(title: "Build a route", message: "Choose which app you want to use", preferredStyle: .actionSheet)
            //однозначно знаем, что эпл карты у нас есть
            if let link = URL(string:"http://maps.apple.com/?daddr=\(coordsString)&dirflg=d"){
                alert.addAction(UIAlertAction(title: "Apple Maps", style: .default, handler: {_ in
                    UIApplication.shared.open(link)
                }))
            }
            //в дальнейшем мы проверяем, можем ли мы открыть подобное приложение
            //Если нет, то просто не предлагаем открывать такое приложение
            
            //MARK: - GOOGLE MAPS
            if let scheme = URL(string: "comgooglemaps://"),
               UIApplication.shared.canOpenURL(scheme),
               let link = URL(string: "comgooglemaps://?daddr=\(coordsString)&directionsmode=driving") {
                alert.addAction(UIAlertAction(title: "Google Maps", style: .default, handler: {_ in
                    UIApplication.shared.open(link)
                }))
            }
            
            //MARK: - YANDEX NAVIGATOR
            if let scheme = URL(string: "yandexnavi://"),
               UIApplication.shared.canOpenURL(scheme),
               let link = URL(string: "yandexnavi://build_route_on_map?lat_to=\(lat)&lon_to=\(long)") {
                alert.addAction(UIAlertAction(title: "Yandex Navigator", style: .default, handler: {_ in
                    UIApplication.shared.open(link)
                }))
            }
            
            //MARK: - YANDEX MAPS
            if let scheme = URL(string:"yandexmaps://"),
               UIApplication.shared.canOpenURL(scheme),
               let link = URL(string: "yandexmaps://maps.yandex.ru/?rtt=auto&rtext=\(coordsString)"){
                alert.addAction(UIAlertAction(title: "Yandex Maps", style: .default, handler: {_ in
                    UIApplication.shared.open(link)
                }))
            }
            
            //MARK: - 2GIS
            if let scheme = URL(string:"dgis://"),
               UIApplication.shared.canOpenURL(scheme),
               let link = URL(string: "dgis://2gis.ru/routeSearch/rsType/car/to/\(coordsString)"){
                alert.addAction(UIAlertAction(title: "2 GIS", style: .default, handler: {_ in
                    UIApplication.shared.open(link)
                }))
            }
            //добавляем кнопку отмена
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            //возвращаем весь алерт
            return alert
        }else{
            return nil
        }
        
    }
    
    ///выставляет с нужными размерами картинку отеля, если она есть
    private func prepareAndSetImage(_ sourceImage: UIImage?){
        //получаем картинку с обрезанными краями в 1 пиксель, так как все картинки имеют красную рамку
        guard let croppedImage = sourceImage?.cropAround(1) else {return}
        //выставляем картинку
        DispatchQueue.main.async {
            self.hotelImage = croppedImage
            
        }
        
        
    }
    
    ///Метод загрузки подробных данных об отеле
    private func fetchData(){
        Task{
            do{
                let response = try await NetworkManager.shared.getHotelDetails(hotel.id)
                
                DispatchQueue.main.async {
                    self.hotel = response
                }
                if let imageID = response.image, !imageID.isEmpty{
                    let image = try await NetworkManager.shared.getHotelImage(imageID)
                    self.prepareAndSetImage(image)
                }
            }catch{
                print("recieved error")
            }
        }
    }
}
