import Foundation
import UIKit
import CoreData

// object
// protocol
// ref to presenter
// https

protocol GetData {
    var store: UserStore? { get set }
    var presenter: Presenter? { get set }
    func saveTobd(this: String)
    func getAllCharacters()
    func getCharacterImage()
    func checkConnectionEvery10Seconds()
    func isConnectedToNetwork() -> Bool
}

final class UserInteractor: GetData {
    
    var store: UserStore?
    var presenter: Presenter?
    var timer = Timer()
    
    internal func getCharacterImage() {
        do {
            guard let unwrappedArr = self.presenter?.results else { return }
            if !unwrappedArr.isEmpty {
                for model in unwrappedArr {
                    if let url = URL(string: model.image) {
                        URLSession.shared.dataTask(with: url)
                        if let data = try? Data(contentsOf: url) {
                            guard let tempImage = UIImage(data: data) else { return }
                            self.presenter?.imagesArray?.append(tempImage)
                        }
                    }
                }
            }
        }
    }
    internal func saveTobd(this: String) {
        do {
            store?.saveAllCharacters(what: this)
            print("Succesfully saved \(this) to BD")
        }
    }
    
    internal func getAllCharacters() {
        print("getting data...")
        if let url = URL(string: "https://rickandmortyapi.com/api/character") {
            URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
                if let data = data {
                    do {
                        let parsedJson = try JSONDecoder().decode(AllCharacters.self, from: data)
                        self?.presenter?.results = parsedJson.results
                        
                        // MARK: Saving to CoreData
                        self?.saveTobd(this: "AllCharactersProxy")
                        
                        DispatchQueue.main.async {
                            self?.presenter?.view?.updateTableView()
                            print("reloading tableView...")
                        }
                    }
                    catch let error {
                        print(error)
                    }
                }
            }.resume()
        }
    }
    internal func checkConnectionEvery10Seconds() {
        var count: Int = 0 {
            didSet { count == 1 ? loadDataFromBD() : loadDataFromInternet() }
        }
        self.timer = Timer.scheduledTimer(withTimeInterval: 10.0, repeats: true, block: { _ in
            self.isConnectedToNetwork() ? goodConnect() : badConnect()
        })
        func goodConnect() {
            print("Good internet connection")
            count = 0
        }
        func badConnect() {
            print("No internet connection")
            count = 1
        }
        func loadDataFromInternet() {
            DispatchQueue.global(qos: .background).async {
                self.getAllCharacters()
                sleep(1)
                self.getCharacterImage()
                DispatchQueue.main.async {
                    self.presenter?.view?.animateConnection(text: "Good internet connection", color: .systemGreen)
                }
            }
        }
        func loadDataFromBD() {
            DispatchQueue.global(qos: .background).async {
                DispatchQueue.main.async { self.presenter?.view?.animateConnection(text: "No internet connection", color: .systemRed)}
            }
        }
    }
    internal func isConnectedToNetwork() -> Bool {
        var status:Bool = false
        
        DispatchQueue.global(qos: .background).sync {
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







