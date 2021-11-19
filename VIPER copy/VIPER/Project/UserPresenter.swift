import Foundation
import UIKit
import CoreData

// Object
// protocol
// ref to interactor
// ref to router
// ref to view

protocol Presenter {
    var router: Router? { get set }
    var interactor: GetData? { get set }
    var view: View? { get set }
    var view1: View1? { get set }
    var results: [UserResults]? { get set }
    var imagesArray: [UIImage]? { get set }
    var connectionStatus: String? { get set }
    var connectionColor: UIColor? { get set }
    func animateTableView()
    func checkConnection()
    func getData()
    func saveData()
    func updateData()
    func animateConnection(status: String, color: UIColor)
    func saveImage(image: UIImage, name: String)
    func getImage(name:String) -> UIImage?
    func deleteImage(name:String)
}

final class UserPresenter: Presenter {
    
    internal var imagesArray: [UIImage]?
    internal var results: [UserResults]?
    internal var view: View?
    internal var view1: View1?
    internal var router: Router?
    internal var interactor: GetData?
    internal var connectionStatus: String?
    internal var connectionColor: UIColor?
    
    internal func getData() {
        self.interactor?.getData()
    }
    internal func saveData() {
        // MARK: Saving to CoreData
        interactor?.saveTobd()
    }
    private var timer = Timer()
    
    internal func checkConnection() {
        interactor?.checkConnectionEvery10Seconds()
        results = interactor?.results
        imagesArray = interactor?.imagesArray
        
        timer = Timer.scheduledTimer(withTimeInterval: 10.0, repeats: true, block: { [self] _ in
            updateData() // тут данные подтягиваются с нижнего слоя раз в 10 сек
            animateConnection(status: connectionStatus!, color: connectionColor!)
            // достаем картинки из жесткого диска:
            if imagesArray?.count == 0 {
                var names: [String] = []
                for number in 0..<(results?.count ?? 0) {
                    names.append(String(number))
                }
                for name in names {
                    guard let image = getImage(name: name) else { return }
                    imagesArray?.append(image)
                }
            }
        })
        timer = Timer.scheduledTimer(withTimeInterval: 30.0, repeats: false, block: { [self] _ in // через 30 сек после запуска картинки сохраняются на жесткий диск если массив с картинками не пустой / если на жестком диске данные картинки в данной директории уже есть - они просто перезаписываются 
            guard let unwrappedImagesArray = imagesArray else { return }
            if !unwrappedImagesArray.isEmpty {
                for (index,value) in unwrappedImagesArray.enumerated() {
                    saveImage(image: value, name: String(index))
                }
            }
        })
    }
    
    internal func updateData() { // тут данные подтягиваются с нижнего слоя
        DispatchQueue.main.async {
            self.view?.myTableView.reloadData()
        }
        interactor?.updateData()
        results = interactor?.results
        imagesArray = interactor?.imagesArray
        connectionStatus = interactor?.connectionStatus
        connectionColor = interactor?.connectionColor
    }
    
    internal func animateTableView() {
        DispatchQueue.main.async { [self] in
            view?.myTableView.reloadData()
            let cells = view?.myTableView.visibleCells
            let height = view?.myTableView.bounds.height
            var delay: Double = 0
            guard let unwrappedCells = cells else { return }
            for cell in unwrappedCells {
                cell.transform = CGAffineTransform(translationX: 0, y: height ?? 0)
                UIView.animate(withDuration: 1.0, delay: delay * 0.05, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                    cell.transform = CGAffineTransform.identity
                })
                delay += 1
            }
        }
    }
    internal func animateConnection(status: String, color: UIColor) {
        view?.internetStatusLabel.text = status
        view?.internetStatusLabel.backgroundColor = color
        DispatchQueue.main.async {
            UIView.animate(withDuration: 1.5, animations: {
                self.view?.internetStatusLabel.alpha = 1
            }) { finished in
                UIView.animate(withDuration: 1.5) {
                    self.view?.internetStatusLabel.alpha = 0
                }
            }
        }
    }
    internal func saveImage(image: UIImage, name: String) {
        interactor?.saveImage(image: image, name: name)
    }
    internal func getImage(name:String) -> UIImage? {
        interactor?.getImage(name: name)
    }
    internal func deleteImage(name:String) { // метод пока не применен
        interactor?.deleteImage(name: name)
    }
}

