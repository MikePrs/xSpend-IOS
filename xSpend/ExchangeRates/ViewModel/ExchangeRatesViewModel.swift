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
    private let countryCurrencyCode = CountryCurrencyCode()
    
    func fetchExchangeRates() async{
        do{
            let url = URL(string: "https://api.freecurrencyapi.com/v1/latest?apikey=fca_live_kBOUEH953DGP0oGcrAE3MObeATpJT9BSA1k2VIV1&currency&base_currency="+countryCurrencyCode.countryCurrency[currencySelection]!)
            let (data, _) = try await URLSession.shared.data(from: url!)
            let decodedData = try JSONDecoder().decode(ExchangeRate.self, from: data)
            DispatchQueue.main.async {
                self.exchangeRates = decodedData
            }
        }catch{
            print("Error\(error)")
        }
    }
    

    
    func getConversion(_ from: String, _ to: String) async -> Result<ExchangeRate, FetchError> {
        do {
            guard let url = URL(string: "https://api.freecurrencyapi.com/v1/latest?apikey=fca_live_kBOUEH953DGP0oGcrAE3MObeATpJT9BSA1k2VIV1&currencies=\(to)&base_currency=\(from)") 
            else {
                return .failure(.badURL)
            }
            
            let (data, response) = try await URLSession.shared.data(from: url)
            if let httpResponse = response as? HTTPURLResponse {
                if (200..<300).contains(httpResponse.statusCode) {
                    let decodedData = try JSONDecoder().decode(ExchangeRate.self, from: data)
                    return .success(decodedData)
                }else{
                    let decodedError = try JSONDecoder().decode(APIError.self, from: data)
                    return .failure(.apiError(decodedError.message))
                }
            }else{
                return .failure(.unknown)
            }
        } catch {
            print("Error: \(error)")
            return .failure(.decodingError(error))
        }
    }
    
    func getAmountsExchageRate(currency:String,baseCurrencyAmount:Double)->Double{
        var res = 0.0
        if let rate = exchangeRates.data[currency]{
            res = baseCurrencyAmount * rate
        }
        return res
    }
    
    func getExchangeRate(baseCurrencyAmount:Double,from:String,to:String) async -> Result<Double, FetchError>{
        let result = await getConversion(from,to)
        
        switch result {
        case .success(let conversion):
            var res = Double()
            if let rate = conversion.data[to]{
                res = baseCurrencyAmount * rate
            }
            return .success(res)
        case .failure(let err):
            return .failure(err)
       
        }
        
    }
}
