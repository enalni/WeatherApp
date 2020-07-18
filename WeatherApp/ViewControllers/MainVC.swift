//
//  MainVC.swift
//  WeatherApp
//
//  Created by Александр Николаевич on 17.07.2020.
//  Copyright © 2020 Александр Николаевич. All rights reserved.
//

import UIKit

class MainVC: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var pleaseWriteTextLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        cityLabel.isHidden = true
        tempLabel.isHidden = true
    }
}
extension MainVC: UISearchBarDelegate {
 
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        let urlString = "http://api.weatherstack.com/current?access_key=40966989d5441f64c2fdc1fded99bb1c&query=\(searchBar.text!.replacingOccurrences(of: " ", with: "%20"))"
        
        guard let url = URL(string: urlString) else { return }
        
        var locationName: String?
        var temperature: Double?
        var errorHasOcured: Bool = false
        
        
        _ = URLSession.shared.dataTask(with: url) { (data, _, _) in

            guard let data = data else { return }

            do {
                
                guard let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                    as? [String : AnyObject] else {return}
                
                if let location = json["location"]{
                    locationName = location["name"] as? String
                }
                if let current = json["current"]{
                    temperature = current["temperature"] as? Double
                }
                
                if let _ = json["error"]{
                    errorHasOcured = true
                }
                
                DispatchQueue.main.async {
                    if errorHasOcured {
                        self.cityLabel.text = "Название города неверно. Повторите попытку 😔"
                        self.tempLabel.isHidden = true
                    } else {
                        self.pleaseWriteTextLabel.isHidden = true
                        self.cityLabel.isHidden = false
                        self.tempLabel.isHidden = false
                        let tempString = String(format: "%g", temperature!)
                        self.cityLabel.text = locationName
                        self.tempLabel.text = "\(tempString) градусов"
                    }
                }
            }
            catch let jsonError{
                print(jsonError)
            }
            
        }.resume()
    }
}



