//
//  InternetServis.swift
//  VIPER
//
//  Created by Admin on 17.11.2021.
//

import Foundation
import UIKit

protocol InternetService {
    var results: [UserResults]? { get set }
    var imagesArray: [UIImage]? { get set }
    var connectionStatus: String? { get set }
    var connectionColor: UIColor? { get set }
    var interactor: GetData? { get set }
    func updateData()
    func getAllCharacters()
    func getCharacterImage()
    func checkConnectionEvery10Seconds()
}

final class UserInternetService: InternetService {
    
    private var timer = Timer()
    internal var results: [UserResults]? = []
    internal var imagesArray: [UIImage]? = []
    internal var connectionStatus: String? = "Error"
    internal var connectionColor: UIColor? = .systemRed
    internal var interactor: GetData?
    
    internal func updateData() {
        interactor?.results = self.results
        interactor?.imagesArray = self.imagesArray
        interactor?.connectionStatus = self.connectionStatus
        interactor?.connectionColor = self.connectionColor
    }
    
    internal func getAllCharacters() {
        if let url = URL(string: "https://rickandmortyapi.com/api/character") {
            URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
                if let data = data {
                    do {
                        let parsedJson = try JSONDecoder().decode(AllCharacters.self, from: data)
                        guard let unwrappedResults = self?.results else { return }
                        if unwrappedResults.isEmpty {
                            self?.results = parsedJson.results
                            print("Getting data...")
                        }
                    }
                    catch let error {
                        print(error)
                    }
                }
            }.resume()
        }
    }
    
    internal func getCharacterImage() {
        do {
            guard let unwrappedArr = self.results else { return }
            if !unwrappedArr.isEmpty {
                for model in unwrappedArr {
                    if let url = URL(string: model.image) {
                        URLSession.shared.dataTask(with: url)
                        if let data = try? Data(contentsOf: url) {
                            guard let tempImage = UIImage(data: data) else { return }
                            if self.imagesArray?.count != self.results?.count {
                                self.imagesArray?.append(tempImage)
                                print("getting characters images...")
                            }
                        }
                    }
                }
            }
        }
    }
    
    internal func checkConnectionEvery10Seconds() {
        var count: Int = 0 {
            didSet { if count != 1 { loadDataFromInternet() }
            }
        }
        self.timer = Timer.scheduledTimer(withTimeInterval: 10.0, repeats: true, block: { [self] _ in
            if isConnectedToNetwork() {
                count = 0
                connectionStatus = "Good internet connection"
                print(connectionStatus ?? "Error")
                connectionColor = .systemGreen
            } else {
                count = 1
                connectionStatus = "No internet connection"
                print(connectionStatus ?? "Error")
                connectionColor = .systemRed
            }
        })
    }
    internal func loadDataFromInternet() {
        DispatchQueue.global(qos: .userInteractive).async { [self] in
            getAllCharacters()
            sleep(1)
            getCharacterImage()
        }
    }
    internal func isConnectedToNetwork() -> Bool {
        var status:Bool = false
        
        DispatchQueue.global(qos: .userInteractive).sync {
            let url = URL(string: "https://google.com/")
            let request = NSMutableURLRequest(url: url! as URL)
            request.httpMethod = "HEAD"
            request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData
            request.timeoutInterval = 10.0
            var response: URLResponse?
            _ = try? NSURLConnection.sendSynchronousRequest(request as URLRequest, returning: &response) as NSData?
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    status = true
                } else {
                    status = false
                }
            }
        }
        return status
    }
}
