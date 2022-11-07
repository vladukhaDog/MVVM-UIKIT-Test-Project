//
//  HotelCell.swift
//  TestTask
//
//  Created by Владислав Пермяков on 27.10.2022.
//

import Foundation
import UIKit

class HotelCell: UICollectionViewCell {

    //MARK: - Vars and Data
    static let identifier = "HotelCell"
    
  
    
    
    //MARK: - UI components

    private var nameLabel: UILabel = {
        var label = UILabel()
        label.text = ""
        label.textAlignment = .left
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private var addressLabel: UILabel = {
        var label = UILabel()
        label.text = ""
        label.textColor = .darkGray
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 15)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    private var distanceLabel: UILabel = {
        var label = UILabel()
        label.text = ""
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 12)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var ratingLabel: UILabel = {
        var label = UILabel()
        label.text = ""
        label.textAlignment = .left
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var availableSuitsLabel: UILabel = {
        var label = UILabel()
        label.text = ""
        label.textAlignment = .left
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let background: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 15
        view.backgroundColor = .lightGray
        view.layer.opacity = 0.25
        return view
    }()
    private let starImage: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(systemName: "star.fill")
        view.sizeToFit()
        view.tintColor = .systemYellow
        return view
    }()
    
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var isHighlighted: Bool {
        didSet {
            if self.isHighlighted {
                alpha = 0.5
            } else {
                alpha = 1.0
            }
        }
    }

    
    //MARK: - functions
    
    func setupUI(_ hotel: Hotel){
        self.nameLabel.text = hotel.name
        self.addressLabel.text = hotel.address
        self.distanceLabel.text = "\(hotel.distance.clean) meters from center of the city."
        self.ratingLabel.text = hotel.stars.clean
        let suitesCount = hotel.availableSuites().count
        self.availableSuitsLabel.text = suitesCount > 0 ? "available suites: \(suitesCount)" : "No suites are available right now"
    }
    
    
    

}

//MARK: - Setup functions
extension HotelCell{
    
    private func setupViews(){
        self.addSubview(background)

        self.addSubview(nameLabel)
        self.addSubview(addressLabel)
        self.addSubview(distanceLabel)
        
        self.addSubview(starImage)
        self.addSubview(ratingLabel)
        self.addSubview(availableSuitsLabel)
    }
    
    private func setConstraints(){
        NSLayoutConstraint.activate([
            background.topAnchor.constraint(equalTo: self.topAnchor),
            background.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            background.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            background.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        

        NSLayoutConstraint.activate([
            starImage.topAnchor.constraint(equalTo: self.background.topAnchor, constant: 5),
            starImage.heightAnchor.constraint(equalToConstant: 35),
            starImage.widthAnchor.constraint(equalTo: self.starImage.heightAnchor),
            starImage.trailingAnchor.constraint(equalTo: self.background.trailingAnchor, constant: -5),
            
        ])
        NSLayoutConstraint.activate([
            ratingLabel.centerYAnchor.constraint(equalTo: self.starImage.centerYAnchor),
            ratingLabel.centerXAnchor.constraint(equalTo: self.starImage.centerXAnchor),
            
        ])

        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: self.background.leadingAnchor, constant: 5),
            nameLabel.topAnchor.constraint(equalTo: self.background.topAnchor, constant: 5),
            nameLabel.trailingAnchor.constraint(lessThanOrEqualTo: self.starImage.leadingAnchor, constant: -5)
        ])
        NSLayoutConstraint.activate([
            addressLabel.leadingAnchor.constraint(equalTo: self.background.leadingAnchor, constant: 5),
            addressLabel.topAnchor.constraint(equalTo: self.nameLabel.bottomAnchor, constant: 5),
            addressLabel.trailingAnchor.constraint(lessThanOrEqualTo: self.trailingAnchor, constant: -5)
        ])
        NSLayoutConstraint.activate([
            distanceLabel.leadingAnchor.constraint(equalTo: self.background.leadingAnchor, constant: 5),
            distanceLabel.topAnchor.constraint(equalTo: self.addressLabel.bottomAnchor, constant: 5),
            distanceLabel.trailingAnchor.constraint(lessThanOrEqualTo: self.trailingAnchor, constant: -5)
        ])
        NSLayoutConstraint.activate([
            availableSuitsLabel.leadingAnchor.constraint(equalTo: self.background.leadingAnchor, constant: 5),
            availableSuitsLabel.topAnchor.constraint(greaterThanOrEqualTo: self.addressLabel.bottomAnchor, constant: 5),
            availableSuitsLabel.bottomAnchor.constraint(equalTo: self.background.bottomAnchor, constant: -5),
            availableSuitsLabel.trailingAnchor.constraint(lessThanOrEqualTo: self.trailingAnchor, constant: -5)
        ])
        
    }
    
    
    
}

