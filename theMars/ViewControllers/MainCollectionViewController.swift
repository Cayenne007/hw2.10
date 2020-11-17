//
//  MainCollectionViewController.swift
//  theMars
//
//  Created by Cayenne on 14.11.2020.
//

import UIKit


class MainCollectionViewController: UICollectionViewController {

    var activityView = UIActivityIndicatorView(style: .large)
    var filterButton = FilterButton(systemName: "magnifyingglass")
    
    var filter = RoverFilter.getDefault()
    var photos: [RoverPhoto] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViewController()
        
        NetworkManager.loadData(filter: filter) { (photos) in
            self.updateList(photos)
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        filterButtonSetConstraint()
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
        
        cell.setData(photo: photo, item: indexPath.item)
    
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "photo", sender: photos[indexPath.item]) 
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
    
    private func setupViewController() {
        activityView.startAnimating()
        activityView.hidesWhenStopped = true
        view.addSubview(activityView)
        activityView.center = view.center
        
        filterButton.addTarget(self, action: #selector(filterButtonClick(_:)), for: UIControl.Event.touchUpInside)
        view.addSubview(filterButton)
    }
    
    private func filterButtonSetConstraint() {

        NSLayoutConstraint.activate([filterButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
                                     filterButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -53),
                                     filterButton.widthAnchor.constraint(equalToConstant: 50),
                                     filterButton.heightAnchor.constraint(equalToConstant: 50)])

        
    }
    
    @IBAction func filterButtonClick(_ sender: UIButton){

        performSegue(withIdentifier: "filter", sender: nil)

    }
    
}


extension MainCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenSize: CGRect = UIScreen.main.bounds
        let screenWidth = screenSize.width
        return CGSize(width: (screenWidth/4)-6, height: (screenWidth/4)-6)
            
    }
}


protocol UpdateListDelegate{
    var filter: RoverFilter { get set }
    var activityView: UIActivityIndicatorView {get set}
    func updateList(_ newPhotos: [RoverPhoto])
}

extension MainCollectionViewController: UpdateListDelegate {
    func updateList(_ newPhotos: [RoverPhoto]) {
    
        photos = newPhotos
        
        title = filter.description
        collectionView.reloadData()
        
        activityView.stopAnimating()
        filterButton.pulsate()
    }
}

