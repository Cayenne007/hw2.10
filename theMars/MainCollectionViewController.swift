//
//  MainCollectionViewController.swift
//  theMars
//
//  Created by Cayenne on 14.11.2020.
//

import UIKit

protocol ResultsDidLoadDelegate {
    func updateList(photos: [RoverPhoto], date: String)
}


class MainCollectionViewController: UICollectionViewController {

    @IBOutlet var chagneSolButton: UIBarButtonItem!
    
    var photos: [RoverPhoto] = []
    let activityView = UIActivityIndicatorView(style: .large)
    
    var sol = "1000"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NetworkManager.loadData(sol: sol, delegate: self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        activityView.startAnimating()
        activityView.hidesWhenStopped = true
        view.addSubview(activityView)
        activityView.center = view.center
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
        //guard let cell = sender as? MainCollectionViewCell else { return }
        guard let photo = sender as? RoverPhoto else { return }
        let photoVC = segue.destination as! PhotoViewController
        photoVC.photo = photo
        
    }
    
    
    @IBAction func changeSol(_ sender: Any) {
        
        let alert = UIAlertController(title: "", message: "Введите номер марсианских суток", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.text = "1000"
            textField.keyboardType = .decimalPad
        }

        let action = UIAlertAction(title: "ok", style: .default) { (alertAction) in
            let newSol = alert.textFields![0].text ?? self.sol
            self.setNewSol(newSol)
        }

        alert.addAction(action)
        
        present(alert, animated: true)
        
    }
    
    func setNewSol(_ newSol: String) {
        NetworkManager.loadData(sol: newSol, delegate: self)
    }
    
    
    

}


extension MainCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: UIScreen.main.bounds.width - 10, height: 250)
    }
}

extension MainCollectionViewController: ResultsDidLoadDelegate {
    func updateList(photos: [RoverPhoto], date: String) {
        DispatchQueue.main.async {
            
            if photos.count == 0 {
                self.alert(title: "Нет фото", message: "В указаном дне нет фотографий! Попробуйте выбрать другой день")
                return
            }
            self.photos = photos
            
            self.activityView.stopAnimating()
            self.chagneSolButton.title = "Изменить \(date)"
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
