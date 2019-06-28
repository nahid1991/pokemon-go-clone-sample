//
//  CoreDataHelper.swift
//  PokemonGoClone
//
//  Created by Nahid on 28/6/19.
//  Copyright © 2019 Nahid. All rights reserved.
//

import Foundation
import UIKit
import CoreData

func addAllPokemon() {
    createPokemon(name: "Pikachu", imageName: "pikachu-2")
    createPokemon(name: "Pidgey", imageName: "pidgey")
    createPokemon(name: "Bullbasaur", imageName: "bullbasaur")
    createPokemon(name: "Squirtle", imageName: "squirtle")
}

func createPokemon(name: String, imageName: String) {
    if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
        let pokemon = Pokemon(context: context)
        pokemon.name = name
        pokemon.imageName = imageName
        pokemon.caught = false
    }
}

func getAllPokemon() -> [Pokemon] {
    if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
        if let pokeData = try? context.fetch(Pokemon.fetchRequest()) as? [Pokemon] {
            if pokeData.count == 0 {
                addAllPokemon()
                return getAllPokemon()
            } else {
                return pokeData
            }
        }
    }
    
    return []
}

func getCaughtPokemon() -> [Pokemon] {
    if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
        let fetchRequest = Pokemon.fetchRequest() as NSFetchRequest<Pokemon>
        fetchRequest.predicate = NSPredicate(format: "caught == true")
        if let pokemon = try? context.fetch(fetchRequest) {
            return pokemon
        }
    }
    
    return []
}

func getUnCaughtPokemon() -> [Pokemon] {
    if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
        let fetchRequest = Pokemon.fetchRequest() as NSFetchRequest<Pokemon>
        fetchRequest.predicate = NSPredicate(format: "caught == false")
        if let pokemon = try? context.fetch(fetchRequest) {
            return pokemon
        }
    }
    
    return []
}
