//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

//By convention, Swift protocols are usually written in the file that has the class/struct which will call the
//delegate methods, i.e. the CoinManager.
protocol CoinManagerDelegate {
  
  //Create the method stubs wihtout implementation in the protocol.
  //It's usually a good idea to also pass along a reference to the current class.
  //e.g. func didUpdatePrice(_ coinManager: CoinManager, price: String, currency: String)
  //Check the Clima module for more info on this.
  
  func didUpdatePrice(price: String, currency: String)
  func didFailWithError(error: Error)
}

struct CoinManager {
  
  //Create an optional delegate that will have to implement the delegate methods.
  //Which we can notify when we have updated the price.
  
  var delegate: CoinManagerDelegate?
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "YOUR_API_KEY_HERE"
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]

  func getCoinPrice(for currency: String) {
    
    //Use String concatenation to add the selected currency at the end of the baseURL along with the API key.
    
    let urlString = "\(baseURL)/\(currency)?apikey=\(apiKey)"
    
    //Use optional binding to unwrap the URL that's created from the urlString
    //1. Create a URL
    if let url = URL(string: urlString) {
    
    //Create a new URLSession object with default configuration.
    //2. Create a URLSession
    let session = URLSession(configuration: .default)
    
    //3. Give the session a task
    let task = session.dataTask(with: url) { (data, response, error) in
      if error != nil {
        print(error!)
        return
      }
      
      //Format the data we got back as a string to be able to print it.
      
      let dataAsString = String(data: data!, encoding: .utf8)
      print(dataAsString)
    }
      //Start task to fetch data from bitcoin average's servers.
      task.resume()
    }
  }
  
  func parseJSON(_ data: Data) -> Double? {
    
    // Create a JSONDecoder
    let decoder = JSONDecoder()
    do {
      let decodedData = try decoder.decode(CoinData.self, from: data)
      
      //Get the last property from the decoded data.
      let lastPrice = decodedData.rate
      
      print(lastPrice)
      return lastPrice
      
      // catch and print any errors
    } catch {
      print(error)
      return nil
    }
  }
}
