//
//  MainCollectionViewController.swift
//  theMars
//
//  Created by Cayenne on 14.11.2020.
//

import UIKit

protocol ResultsDidLoadDelegate {
    func updateList(photos: [RoverPhoto], filter: RoverFilter)
    func startAnimateLoadingProcess()
    func stopAnimateLoadingProcess()
}


class MainCollectionViewController: UICollectionViewController {

    
    var photos: [RoverPhoto] = []
    let activityView = UIActivityIndicatorView(style: .large)
    
    var filter = RoverFilter.getDefault()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        activityView.startAnimating()
        activityView.hidesWhenStopped = true
        view.addSubview(activityView)
        activityView.center = view.center
        
        NetworkManager.loadData(filter: filter, delegate: self)
    }
    
    
    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MainCollectionViewCell
        let photo = photos[indexPath.item]
       
        cell.setData(photo: photo)
    
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "photo", sender: photos[indexPath.item]) //как картинку отправить?
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let photoVC = segue.destination as? PhotoViewController {
            guard let photo = sender as? RoverPhoto else { return }
            photoVC.photo = photo
        } else if let filterVC = segue.destination as? FilterViewController {
            filterVC.filter = filter
            filterVC.delegate = self
        }
    
    }
}


extension MainCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: UIScreen.main.bounds.width - 10, height: 250)
    }
}

extension MainCollectionViewController: ResultsDidLoadDelegate {
    func startAnimateLoadingProcess() {
        activityView.startAnimating()
    }
    
    func stopAnimateLoadingProcess() {
        activityView.stopAnimating()
    }
    
    
    func updateList(photos: [RoverPhoto], filter: RoverFilter) {
        DispatchQueue.main.async {
            
            self.title = filter.description
            
            if photos.count == 0 {
                self.alert(title: "Нет фото",
                        message: "\(filter.roverType) на дату \(filter.date) не содержит данных!"
                )
            }
            self.photos = photos
            self.filter = filter
            
            self.activityView.stopAnimating()
            self.collectionView.reloadData()
        }
    }
    
    
}


extension MainCollectionViewController {
    func alert(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))

        self.present(alert, animated: true)
        
    }
}
