//
//  AnnotationModel.swift
//  TestTask
//
//  Created by Владислав Пермяков on 30.10.2022.
//

import Foundation
import MapKit

class Annotation: NSObject, MKAnnotation {
  let title: String?
  let coordinate: CLLocationCoordinate2D

  init(
    title: String?,
    coordinate: CLLocationCoordinate2D
  ) {
    self.title = title
    self.coordinate = coordinate
    super.init()
  }
}
