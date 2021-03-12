//
//  ViewController.swift
//  Pokedex
//
//  Created by Rithvik Bobbili on 8/8/20.
//  Copyright © 2020 CS50. All rights reserved.
//

import UIKit


class ViewController: UITableViewController, UISearchBarDelegate {
    
    @IBOutlet var searchBar: UISearchBar!
    var pokemon: [Pokemon] = []
    var pokemonMatches: [Pokemon]!
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //search
        pokemonMatches = searchText.isEmpty ? pokemon : pokemon.filter { (item: Pokemon) -> Bool in
            return item.name.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
        }
        tableView.reloadData()
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
            self.searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
            searchBar.showsCancelButton = false
            searchBar.text = ""
            searchBar.resignFirstResponder()
            pokemonMatches = pokemon
            tableView.reloadData()
    }
    
    func capitalize(text: String) -> String {
        return text.prefix(1).uppercased() + text.dropFirst()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pokemonMatches.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PokemonCell", for: indexPath)
        cell.textLabel?.text = capitalize(text: pokemonMatches[indexPath.row].name)
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PokemonSegue" {
            if let destination = segue.destination as? PokemonViewController {
                destination.pokemon = pokemonMatches[tableView.indexPathForSelectedRow!.row]
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        // Do any additional setup after loading the view.
        let url = URL(string: "https://pokeapi.co/api/v2/pokemon?limit=151")
        guard let u = url else {
            return
        }
        URLSession.shared.dataTask(with: u) { (data, response, error) in
            guard let data = data else {
                return
            }
            
            do {
                let pokemonList = try JSONDecoder().decode(PokemonList.self, from: data)
                self.pokemon = pokemonList.results
                DispatchQueue.main.async {
                    self.pokemonMatches = self.pokemon
                    self.tableView.reloadData()
                }
            }
            catch let error {
                print("\(error)")
            }
        }.resume()
        pokemonMatches = pokemon
    }

}

