//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

protocol CoinManagerDelegate {
    func didExitWithError(_ error : Error)
    func didUpdateUI(_ rate : String)
}

struct CoinManager {
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "45ADB154-A352-4AB5-A31A-7D3A668D75A4"
    
    var delegate : CoinManagerDelegate?
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    func getData(of currency: String){
        let url = "\(baseURL)/\(currency)?apikey=\(apiKey)"
        print(url)
        performRequest(with: url)
    }
    
    func performRequest(with urlString:String){
        if let url = URL(string: urlString){
            let session = URLSession(configuration: .default)
            let sessionTask = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate!.didExitWithError(error!)
                }
                if let retrievedData = data {
                    if let currencyRate = self.parseData(retrievedData){
                        self.delegate!.didUpdateUI(currencyRate)
                    }
                }
            }
            sessionTask.resume()
        }
    }
    
    func parseData(_ data : Data) -> String?{
        let decoder = JSONDecoder()
        do{
            let coin = try decoder.decode( Coin.self, from: data)
            let rate = coin.rate
            let rateString = String(format: "%.2f", rate)
            return rateString
        }catch{
            return nil
        }
    }
}
