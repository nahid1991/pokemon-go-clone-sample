//
//  PokeAnnotation.swift
//  PokemonGoClone
//
//  Created by Nahid on 28/6/19.
//  Copyright © 2019 Nahid. All rights reserved.
//

import UIKit
import MapKit

class PokeAnnotation : NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var pokemon : Pokemon
    
    init(coord:CLLocationCoordinate2D, pokemon: Pokemon) {
        self.coordinate = coord
        self.pokemon = pokemon
    }
}
