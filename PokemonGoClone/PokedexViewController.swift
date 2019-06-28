//
//  PokedexViewController.swift
//  PokemonGoClone
//
//  Created by Nahid on 28/6/19.
//  Copyright © 2019 Nahid. All rights reserved.
//

import UIKit

class PokedexViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    var caughtPokemon = [Pokemon]()
    var unCaughtPokemon = [Pokemon]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        caughtPokemon = getCaughtPokemon()
        unCaughtPokemon = getUnCaughtPokemon()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "CAUGHT"
        } else {
            return "UNCAUGHT"
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return caughtPokemon.count
        } else {
            return unCaughtPokemon.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        var pokemon : Pokemon
        
        if indexPath.section == 0 {
            pokemon = caughtPokemon[indexPath.row]
        } else {
            pokemon = unCaughtPokemon[indexPath.row]
        }
        
        cell.textLabel?.text = pokemon.name
        
        if let imageName = pokemon.imageName {
            cell.imageView?.image = UIImage(named: imageName)
        }
        
        return cell
    }

    @IBAction func cancelTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
