//
//  ViewController.swift
//  TestTask
//
//  Created by Владислав Пермяков on 27.10.2022.
//

import UIKit
import Foundation
import Combine

class HotelListViewController: UIViewController {
    //MARK: Данные и переменные
    
    let viewModel = HotelListViewModel()
    private var cancellable = Set<AnyCancellable> ()
    
    //MARK: UI Элементы
    
    private let hotelsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10.0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.bounces = true
        collectionView.register(HotelCell.self, forCellWithReuseIdentifier: HotelCell.identifier)
        collectionView.backgroundColor = .clear
        let refresh = UIRefreshControl()
        collectionView.refreshControl = refresh
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private var SortByDistanceButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.systemBlue, for: .normal)
        button.setTitleColor(.systemBlue.withAlphaComponent(0.7), for: .highlighted)
        button.setTitle("Distance", for: .normal)
        button.tintColor = .systemBlue
        return button
    }()
    
    private var SortByAvailabilityButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.systemBlue, for: .normal)
        button.setTitleColor(.systemBlue.withAlphaComponent(0.7), for: .highlighted)
        button.setTitle("Available suites", for: .normal)
        button.tintColor = .systemBlue

        
        return button
    }()
    
    private var SortByLabel: UILabel = {
        var label = UILabel()
        label.text = "Sort By:"
        label.textAlignment = .left
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
   
    //MARK: - Связка input в ViewModel
    
    ///нажатие на кнопку сортировки по дистанции от центра
    @objc private func sortByDistance(){
        viewModel.sortByDistance()
    }
    
    ///нажатие на кнопку сортровки по колисчеству доступных
    @objc private func sortByAvailable(){
        viewModel.sortByAvailable()
    }
    
   


    //MARK: Начальные настройки
    
    ///добавляет views к viewcontroller
    private func addViewsToController(){
        self.view.addSubview(hotelsCollectionView)
        self.view.addSubview(SortByLabel)
        self.view.addSubview(SortByDistanceButton)
        self.view.addSubview(SortByAvailabilityButton)
        hotelsCollectionView.delegate = self
        hotelsCollectionView.dataSource = self
    }
    
    ///настраивает констрейнты
    private func setConstraints(){
        
        NSLayoutConstraint.activate([
            SortByDistanceButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -5),
            SortByDistanceButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 5),
            SortByDistanceButton.trailingAnchor.constraint(equalTo: self.view.centerXAnchor, constant: -5),
            SortByDistanceButton.heightAnchor.constraint(greaterThanOrEqualToConstant: 20),
        ])
        NSLayoutConstraint.activate([
            SortByAvailabilityButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -5),
            SortByAvailabilityButton.leadingAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 5),
            SortByAvailabilityButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -5),
            SortByAvailabilityButton.heightAnchor.constraint(greaterThanOrEqualToConstant: 20),
        ])
        NSLayoutConstraint.activate([
            SortByLabel.bottomAnchor.constraint(equalTo: self.SortByAvailabilityButton.topAnchor, constant: -5),
            SortByLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 5),
        ])
        NSLayoutConstraint.activate([
            hotelsCollectionView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0),
            hotelsCollectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0),
            hotelsCollectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0),
            hotelsCollectionView.bottomAnchor.constraint(equalTo: self.SortByLabel.topAnchor, constant: -10)
        ])
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        title = "Our Hotels"
        addViewsToController()
        setConstraints()
        setupBindings()
        self.hotelsCollectionView.refreshControl?.beginRefreshing()
        
    }
    
    ///функция, которая биндит значения из vm к vc
    private func setupBindings(){
        viewModel.$hotels
            .sink {[weak self] hotels in
                self?.hotelsCollectionView.reloadData()
                self?.hotelsCollectionView.refreshControl?.endRefreshing()
            }
            .store(in: &cancellable)
        
        
        self.hotelsCollectionView.refreshControl?.addTarget(self, action: #selector(viewModel.updateHotelsList), for: .valueChanged)
        self.SortByAvailabilityButton.addTarget(nil, action: #selector(sortByAvailable), for: .touchUpInside)
        self.SortByDistanceButton.addTarget(nil, action: #selector(sortByDistance), for: .touchUpInside)
    }


}

//Делегат работы
extension HotelListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    //Источник данных
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.hotels.count
    }
    
    //Настройка ячейки
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HotelCell.identifier, for: indexPath) as? HotelCell{
            let hotel = viewModel.hotels[indexPath.row]
            cell.setupUI(hotel)
            cell.layer.opacity = 0
            cell.widthAnchor.constraint(equalToConstant: collectionView.frame.width).isActive = true
            UIView.animate(withDuration: 0.2) {
                cell.layer.opacity = 1
            }
            return cell
        }
        return UICollectionViewCell()
    }

    //Обработка нажатия на ячейку
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let hotel = viewModel.hotels[indexPath.row]
        self.navigationController?.pushViewController(HotelDetailViewController(hotel), animated: true)
    }
    
    //Размер ячейки
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: collectionView.frame.width, height: 150)
    }
    
    
}
