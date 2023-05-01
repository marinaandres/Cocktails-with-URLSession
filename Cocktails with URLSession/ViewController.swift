//
//  ViewController.swift
//  Cocktails with URLSession
//
//  Created by Marina Andrés Aragón on 1/5/23.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var nameLabel: UILabel!
    
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet var imageLabel: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = ""
        
    }
    
    @IBAction func searchButtonAction(_ sender: Any) {
        guard let searchText = textField.text, !searchText.isEmpty else {
            let alert = UIAlertController(title: "Error", message: "El campo de búsqueda está vacío. Por favor, ingrese un nombre de coctel", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default)
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
            return
        }
        
        Networking.shared.searchCocktails(name: searchText, success: { drinks in
            if let firstDrink = drinks.first {
                DispatchQueue.main.async {
                    self.nameLabel.text = firstDrink.strDrink
                    self.textField.text = ""
                }
                
                if let imageURL = URL(string: firstDrink.strDrinkThumb) {
                    URLSession.shared.dataTask(with: imageURL) { data, response, error in
                        guard error == nil, let data = data, let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                            DispatchQueue.main.async {
                                self.imageLabel.isHidden = true
                                let alert = UIAlertController(title: "Error", message: "No se pudo descargar la imagen", preferredStyle: .alert)
                                let okAction = UIAlertAction(title: "OK", style: .default)
                                alert.addAction(okAction)
                                self.present(alert, animated: true, completion: nil)
                            }
                            return
                        }
                       DispatchQueue.main.async {
                            self.imageLabel?.image = UIImage(data: data)
                            self.imageLabel?.isHidden = false
                        }
                    }.resume()
                } else {
                    DispatchQueue.main.async {
                        self.imageLabel.isHidden = true
                    }
                }
            } else {
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Error", message: "No se encontraron cocteles con ese nombre", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default)
                    alert.addAction(okAction)
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }, failure: { error in
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "Error", message: "Hubo un error de red. Por favor, intenta de nuevo más tarde.", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default)
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            }
        })
    }
}
