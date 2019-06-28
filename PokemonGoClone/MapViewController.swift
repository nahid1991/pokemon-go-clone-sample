//
//  MapViewController.swift
//  PokemonGoClone
//
//  Created by Nahid on 28/6/19.
//  Copyright © 2019 Nahid. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var manager = CLLocationManager()
    var updateCount = 0
    var pokemons = [Pokemon]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pokemons = getAllPokemon()
        
        manager.delegate = self
        
        if CLLocationManager.authorizationStatus() != .authorizedWhenInUse {
            manager.requestWhenInUseAuthorization()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            setUp()
        }
    }
    
    func setUp() {
        mapView.showsUserLocation = true
        manager.startUpdatingLocation()
        mapView.delegate = self
        
        spawnPokemon()
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        mapView.deselectAnnotation(view.annotation, animated: true)
        if view.annotation is MKUserLocation {
            centerTapped("Hello")
        } else {
            if let center = manager.location?.coordinate {
                if let pokemonCenter = view.annotation?.coordinate {
                    let region = MKCoordinateRegion(center: pokemonCenter, latitudinalMeters: 200, longitudinalMeters: 200)
                    
                    if let pokemonAnnotation = view.annotation as? PokeAnnotation {
                        if let pokeName = pokemonAnnotation.pokemon.name {
                            mapView.setRegion(region, animated: true)
                            
                            if mapView.visibleMapRect.contains(MKMapPoint(center)) {
                                pokemonAnnotation.pokemon.caught = true
                                (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
                                
                                
                                let alertVC = UIAlertController(title: "Congrats!", message: "You have caught a \(pokeName)", preferredStyle: .alert)
                                let pokedexAction = UIAlertAction(title: "Pokedex", style: .default) {
                                    (action) in self.performSegue(withIdentifier: "moveToPokedex", sender: nil)
                                }
                                let okAction = UIAlertAction(title: "Ok", style: .default) {
                                    (action) in alertVC.dismiss(animated: true, completion: nil)
                                }
                                alertVC.addAction(pokedexAction)
                                alertVC.addAction(okAction)
                                present(alertVC, animated: true, completion: nil)
                            } else {
                                let alertVC = UIAlertController(title: "Oops!", message: "You are too far away from this \(pokeName) to catch it! Try moving closer!", preferredStyle: .alert)
                                
                                let okAction = UIAlertAction(title: "Ok", style: .default) {
                                    (action) in alertVC.dismiss(animated: true, completion: nil)
                                }
                                alertVC.addAction(okAction)
                                present(alertVC, animated: true, completion: nil)
                            }
                        }
                    }
                }
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annoView = MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
        
        if annotation is MKUserLocation {
            // Show the trainer
            annoView.image = UIImage(named: "player")
            
            var frame = annoView.frame
            frame.size.height = 50
            frame.size.width = 50
            
            annoView.frame = frame
        } else {
            if let pokeAnnotation = annotation as? PokeAnnotation {
                if let imageName = pokeAnnotation.pokemon.imageName {
                    annoView.image = UIImage(named: imageName)
                    
                    var frame = annoView.frame
                    frame.size.height = 50
                    frame.size.width = 50
                    
                    annoView.frame = frame
                }
            }
        }
        
        return annoView
    }
    
    func spawnPokemon() {
        Timer.scheduledTimer(withTimeInterval: 5, repeats: true ) {
            (timer) in
            if let center = self.manager.location?.coordinate {
                var annoCord = center
                annoCord.latitude += (Double(arc4random_uniform(200)) - 100.0) / 50000
                annoCord.longitude += (Double(arc4random_uniform(200)) - 100.0) / 50000
                
                let randomIndex = Int(arc4random_uniform(UInt32(self.pokemons.count)))
                let randomPokemon = self.pokemons[randomIndex]
                
                let anno = PokeAnnotation(coord: annoCord, pokemon: randomPokemon)
                
                self.mapView.addAnnotation(anno)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if updateCount < 3 {
            centerMap()
            updateCount += 1
        } else {
            manager.stopUpdatingLocation()
        }
    }
    
    @IBAction func centerTapped(_ sender: Any) {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            centerMap()
        }
    }
    
    func centerMap() {
        if let center = manager.location?.coordinate {
            let region = MKCoordinateRegion(center: center, latitudinalMeters: 200, longitudinalMeters: 200)
            mapView.setRegion(region, animated: true)
        }
    }
}
