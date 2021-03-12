//
//  PokemonViewController.swift
//  Pokedex
//
//  Created by Rithvik Bobbili on 8/8/20.
//  Copyright © 2020 CS50. All rights reserved.
//

import UIKit

class PokemonViewController: UIViewController {
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var numberLabel: UILabel!
    @IBOutlet var type1label: UILabel!
    @IBOutlet var type2label: UILabel!
    @IBOutlet var catchButton: UIButton!
    
    var pokemon: Pokemon!
    
    var caughtStatus = false
    
    @IBAction func toggleCatch() {
        if caughtStatus {
            caughtStatus = false
            catchButton.setTitle("Catch", for: .normal)
        }
        else {
            caughtStatus = true
            catchButton.setTitle("Release", for: .normal)
        }
    }
    
    func capitalize(text: String) -> String {
        return text.prefix(1).uppercased() + text.dropFirst()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        type1label.text = ""
        type2label.text = ""
        
        let url = URL(string: pokemon.url)
        guard let u = url else {
            return
        }
        URLSession.shared.dataTask(with: u) { (data, response, error) in
            guard let data = data else {
                return
            }
            
            do {
                let pokemonData = try JSONDecoder().decode(PokemonData.self, from: data)
                DispatchQueue.main.async {
                    self.nameLabel.text = self.capitalize(text: self.pokemon.name)
                    self.numberLabel.text = String(format: "#%03d", pokemonData.id)
                    
                    for typeEntry in pokemonData.types {
                        if typeEntry.slot == 1 {
                            self.type1label.text = typeEntry.type.name
                        }
                        else if typeEntry.slot == 2 {
                            self.type2label.text = typeEntry.type.name
                        }
                    }
                }
            }
            catch let error {
                print("\(error)")
            }
        }.resume()
        
    }
}
