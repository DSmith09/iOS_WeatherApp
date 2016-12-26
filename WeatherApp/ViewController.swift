//
//  ViewController.swift
//  WeatherApp
//
//  Created by David on 10/22/16.
//  Copyright © 2016 dmsmith. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    private let WEATHER_SITE_PREFIX = "http://www.weather-forecast.com/locations/"
    private let WEATHER_SITE_SUFFIX = "/forecasts/latest"
    private let NO_CITY_DATA_MESSAGE = "(╯°□°)╯︵ ┻━┻: Couldn't find city data; Please try again"
    
    private let SPACE:String = " "
    private let HYPHEN:String = "-"
    
    
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var resultLabel: UILabel!
    
    @IBAction func submitButton(_ sender: AnyObject) {
        var cityText = cityTextField.text
        if (cityText == "New York City") {
            cityText = "New York"
        }
        let url = URL(string: WEATHER_SITE_PREFIX + (cityText?.replacingOccurrences(of: SPACE, with: HYPHEN))! + WEATHER_SITE_SUFFIX)
        let request = NSMutableURLRequest(url: url!)
        
        // Creates Background Process to retrieve data off the main thread (for performance)
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            
            var message = ""
            if error != nil {
                print(error!)
            }
                
            else {
                if let unwrappedData = data {
                    let dataString = NSString(data: unwrappedData, encoding: String.Encoding.utf8.rawValue)
                    print(dataString!)
                    var stringIdentifier = "3 Day Weather Forecast Summary:</b><span class=\"read-more-small\"><span class=\"read-more-content\"> <span class=\"phrase\">"
                    if let contentArray = dataString?.components(separatedBy: stringIdentifier) {
                        if contentArray.count > 1 {
                            stringIdentifier = "</span>"
                            let newContentArray = contentArray[1].components(separatedBy: stringIdentifier)
                            if newContentArray.count > 1 {
                                message = newContentArray[0].replacingOccurrences(of: "&deg;", with: "°")
                                print(message)
                            }
                        }
                    }
                }
            }
            if (message == "") {
                message = self.NO_CITY_DATA_MESSAGE
            }
            DispatchQueue.main.sync(execute: {
                // Since Executing In Background (off Main Thread) need to reference data back to UI Thread using self
                self.resultLabel.text = message
            })
        }
        task.resume()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

