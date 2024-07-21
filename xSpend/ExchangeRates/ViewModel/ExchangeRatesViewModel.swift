//
//  ExchangeRatesViewModel.swift
//  xSpend
//
//  Created by Mike Paraskevopoulos on 30/12/23.
//

import SwiftUI

class ExchangeRatesViewModel:ObservableObject {
    @AppStorage(Constants.appStorage.currencySelection) private var currencySelection: String = ""
    
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
            return .failure(.decodingError(error))
        }
    }
    
    private var savedRates = [String:Double]()

    func getExchangeRate(baseCurrencyAmount:Double,from:String,to:String) async -> Result<Double, FetchError>{
        
        
        var res = Double()
        if let savedRate = savedRates[from]{
            res = baseCurrencyAmount * savedRate
            return .success(res)
        }else{
            let result = await getConversion(from,to)
            
            switch result {
            case .success(let conversion):
                if let rate = conversion.data[to]{
                    res = baseCurrencyAmount * rate
                    savedRates[from] = rate
                }
                return .success(res)
            case .failure(let err):
                return .failure(err)
                
            }
        }
        
    }
}
