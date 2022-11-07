//
//  UIImage + extension.swift
//  TestTask
//
//  Created by Владислав Пермяков on 03.11.2022.
//

import Foundation
import UIKit

extension UIImage{
    func cropAround(_ px: CGFloat = 1.0) -> UIImage?{
        let sourceImage = self
        //получаем RECT без красных краев
        let cropRect = CGRect(
            x: px,
            y: px,
            width: sourceImage.size.width-(px*2),
            height: sourceImage.size.height-(px*2)
        )
        //обрезаем картинку
        
        //переводим в CGImage
        guard let sourceCGImage = sourceImage.cgImage else {return nil}
        //обрезаем
        guard let croppedCGImage = sourceCGImage.cropping(to: cropRect) else {return nil}
        
        //переводим обратно в UIImage
        let croppedImage = UIImage(
            cgImage: croppedCGImage)
        return croppedImage
    }
}
