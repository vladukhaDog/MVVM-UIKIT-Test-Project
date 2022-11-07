//
//  HotelDetailViewController.swift
//  TestTask
//
//  Created by Владислав Пермяков on 30.10.2022.
//

import UIKit
import MapKit
import Combine

class HotelDetailViewController: UIViewController {
    
    //MARK: Data and variables
    var viewModel: HotelDetailViewModel
    var imageHeightConstraint: NSLayoutConstraint?
    private var cancellable = Set<AnyCancellable> ()
    
    //MARK: UI Elemenets
    private let hotelImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.contentMode = .scaleToFill
        view.tintColor = .systemYellow
        
        return view
    }()
    
    private var mapView: MKMapView = {
        var map = MKMapView()
        map.layer.cornerRadius = 15
        map.translatesAutoresizingMaskIntoConstraints = false
        map.isZoomEnabled = false
        map.isScrollEnabled = false
        map.isUserInteractionEnabled = false
        return map
    }()
    
    private var addressLabel: UILabel = {
        var label = UILabel()
        label.text = ""
        label.textColor = .darkGray
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 18)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.isUserInteractionEnabled = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    
    
    private var ratingLabel: UILabel = {
        var label = UILabel()
        label.text = ""
        label.textAlignment = .left
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var availableSuitsLabel: UILabel = {
        var label = UILabel()
        label.text = ""
        label.textAlignment = .left
        label.font = UIFont.boldSystemFont(ofSize: 25)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let starImage: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(systemName: "star.fill")
        view.sizeToFit()
        view.tintColor = .systemYellow
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    
    //MARK: - Связка input в ViewModel
    
    ///Если есть координаты, предлагаем построить маршрут с помощью какой-либо карты, которые можно открыть
    @objc private func openRoute(){
        
        if let alert = viewModel.getRouteAlert(){
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    //MARK: Начальные функции
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        setupViews()
        setConstraints()
        setupBindings()
    }
    
    ///Настройка биндингов
    private func setupBindings(){
        viewModel.$hotel
            .sink { hotel in
                //настройка карты при координатах
                if let long = hotel.lon, let lat = hotel.lat{
                    let coordinates = CLLocationCoordinate2D.init(latitude: lat, longitude: long)
                    let region = MKCoordinateRegion(
                        center: coordinates,
                        latitudinalMeters: 500,
                        longitudinalMeters: 500)
                    self.mapView.addAnnotation(Annotation(title: hotel.name, coordinate: coordinates ))
                    self.mapView.setCameraBoundary(
                        MKMapView.CameraBoundary(coordinateRegion: region),
                        animated: true)
                    let zoomRange = MKMapView.CameraZoomRange(maxCenterCoordinateDistance: 20000)
                    self.mapView.setCameraZoomRange(zoomRange, animated: true)
                }
                //заполнение основных данных
                self.addressLabel.text = hotel.address
                self.ratingLabel.text = hotel.stars.clean
                self.availableSuitsLabel.text = "Available suites: \(hotel.availableSuites().count.description)"
                self.title = hotel.name
            }
            .store(in: &cancellable)
        
        
        viewModel.$hotelImage
            .sink { image in
                guard let croppedImage = image else {return}
                self.hotelImageView.image = croppedImage
                //ставим высоту UIImageView в зависимости от отношения высоты картинки к ширине UIViewImage
                let ratio = croppedImage.size.height / croppedImage.size.width
                self.imageHeightConstraint?.constant = self.hotelImageView.frame.width * ratio
                
                self.imageHeightConstraint?.isActive = true
                //анимируем смену констрейнта
                UIView.animate(withDuration: 0.2) {
                    self.view.layoutIfNeeded()
                }
            }
            .store(in: &cancellable)
    }
    
    
    ///добавление и начальная настройка views к viewController
    func setupViews(){
        self.view.addSubview(hotelImageView)
        self.view.addSubview(mapView)
        self.view.addSubview(addressLabel)
        self.view.addSubview(ratingLabel)
        self.view.addSubview(starImage)
        self.view.addSubview(availableSuitsLabel)
        let addressTap = UITapGestureRecognizer(target: self, action: #selector(openRoute))
        addressLabel.addGestureRecognizer(addressTap)
    }
    
    ///Настройка констрейкнтов
    func setConstraints(){
        NSLayoutConstraint.activate([
            hotelImageView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            hotelImageView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0),
            hotelImageView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0),
            
        ])
        self.imageHeightConstraint = hotelImageView.heightAnchor.constraint(equalToConstant: 200)
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: self.hotelImageView.bottomAnchor, constant: 5),
            mapView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 5),
            mapView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0),
            mapView.heightAnchor.constraint(equalToConstant: 150)
            
        ])
        NSLayoutConstraint.activate([
            addressLabel.topAnchor.constraint(equalTo: self.mapView.bottomAnchor, constant: 5),
            addressLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 5),
            addressLabel.trailingAnchor.constraint(lessThanOrEqualTo: self.view.trailingAnchor, constant: -5),
        ])
        NSLayoutConstraint.activate([
            starImage.topAnchor.constraint(equalTo: self.addressLabel.bottomAnchor, constant: 5),
            starImage.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 5),
            starImage.widthAnchor.constraint(equalToConstant: 40),
            starImage.heightAnchor.constraint(equalToConstant: 40),
        ])
        NSLayoutConstraint.activate([
            ratingLabel.centerYAnchor.constraint(equalTo: self.starImage.centerYAnchor, constant: 0),
            ratingLabel.leadingAnchor.constraint(equalTo: self.starImage.trailingAnchor, constant: 5),
            ratingLabel.trailingAnchor.constraint(lessThanOrEqualTo: self.view.trailingAnchor, constant: -5),
        ])
        NSLayoutConstraint.activate([
            availableSuitsLabel.topAnchor.constraint(equalTo: self.starImage.bottomAnchor, constant: 5),
            availableSuitsLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 5),
            availableSuitsLabel.trailingAnchor.constraint(lessThanOrEqualTo: self.view.trailingAnchor, constant: -5),
        ])
        
    }
    
    
    //MARK: инициализатор для удобности
    init(_ hotel: Hotel){
        self.viewModel = .init(hotel: hotel)
        super.init(nibName: nil, bundle: nil)
        
        
    }
    required init?(coder aDecoder: NSCoder) {
        self.viewModel = .init(hotel: .init(id: 0,
                                              name: "",
                                              address: "",
                                              stars: 0.0,
                                              distance: 0.0,
                                              image: nil,
                                              suitesAvailability: "",
                                              lat: nil,
                                              lon: nil)
        )
        super.init(coder: aDecoder)
    }
    
    
}
