//
//  ExchangeRatesViewModel.swift
//  xSpend
//
//  Created by Mike Paraskevopoulos on 30/12/23.
//

import SwiftUI

class ExchangeRatesViewModel:ObservableObject {
    @AppStorage("currencySelection") private var currencySelection: String = ""
    @Published var exchangeRates = ExchangeRate()
    
    func fetchExchangeRates() async{
        do{
            let url = URL(string: "https://api.freecurrencyapi.com/v1/latest?apikey=fca_live_kBOUEH953DGP0oGcrAE3MObeATpJT9BSA1k2VIV1&currency&baseCurrency="+CountryCurrencyCode().countryCurrency[currencySelection]!)
            let (data, _) = try await URLSession.shared.data(from: url!)
            let decodedData = try JSONDecoder().decode(ExchangeRate.self, from: data)
            DispatchQueue.main.async {
                self.exchangeRates = decodedData
            }
        }catch{
            print("Error\(error)")
        }
    }
    
    func getExchangeRate(baseCurrencyAmount:Double,currency:String) -> Double{
        var res = Double()
        if let rate = self.exchangeRates.data[currency]{
            res = baseCurrencyAmount * rate
        }
        return res
    }
}
