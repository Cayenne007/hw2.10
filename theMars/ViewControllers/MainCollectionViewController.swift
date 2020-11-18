//
//  MainCollectionViewController.swift
//  theMars
//
//  Created by Cayenne on 14.11.2020.
//

import UIKit


class MainCollectionViewController: UICollectionViewController {

    var activityView = UIActivityIndicatorView(style: .large)
    
    let dayBackwardButton = FilterButton(systemName: "arrowtriangle.left")
    let filterButton = FilterButton(systemName: "magnifyingglass")
    let dayForwardButton = FilterButton(systemName: "arrowtriangle.right")
    
    var filter = RoverFilter.getDefault()
    var photos: [RoverPhoto] = []
    
    var previousContentOffset: CGFloat = 0
    
    
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
        
        view.addSubview(dayBackwardButton)
        dayBackwardButton.addTarget(self, action: #selector(dayChangingButtonsClick(_:)), for: UIControl.Event.touchUpInside)
        view.addSubview(filterButton)
        filterButton.addTarget(self, action: #selector(filterButtonClick(_:)), for: UIControl.Event.touchUpInside)
        view.addSubview(dayForwardButton)
        dayForwardButton.addTarget(self, action: #selector(dayChangingButtonsClick(_:)), for: UIControl.Event.touchUpInside)
        dayForwardButton.tag = 1
    }
    
    private func filterButtonSetConstraint() {

        let center = -view.frame.size.width / 2 + 25
        
        NSLayoutConstraint.activate([dayBackwardButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: center-60),
                                     dayBackwardButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -53),
                                     dayBackwardButton.widthAnchor.constraint(equalToConstant: 50),
                                     dayBackwardButton.heightAnchor.constraint(equalToConstant: 50)])
        
        NSLayoutConstraint.activate([filterButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: center),
                                     filterButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -53),
                                     filterButton.widthAnchor.constraint(equalToConstant: 50),
                                     filterButton.heightAnchor.constraint(equalToConstant: 50)])
        
        
        NSLayoutConstraint.activate([dayForwardButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: center+60),
                                     dayForwardButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -53),
                                     dayForwardButton.widthAnchor.constraint(equalToConstant: 50),
                                     dayForwardButton.heightAnchor.constraint(equalToConstant: 50)])

        
    }
    
    
    //MARK: Navigation backward-search-forward actions
    @IBAction func dayChangingButtonsClick(_ sender: FilterButton){
        
        filter.date = (sender.tag == 0) ? filter.date.plus(-1) : filter.date.plus()
        sender.pulsate()
        activityView.startAnimating()
        
        NetworkManager.loadData(filter: filter) { (photos) in
            self.updateList(photos)
        }

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
        
    }
}



//MARK: UIScrollViewDelegate
extension MainCollectionViewController {
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentContentOffset = scrollView.contentOffset.y
        
        if currentContentOffset < -100 {
            dayBackwardButton.isHidden = false
            filterButton.isHidden = false
            dayForwardButton.isHidden = false
            return
        } 
        
        if currentContentOffset > previousContentOffset {
            dayBackwardButton.isHidden = true
            filterButton.isHidden = true
            dayForwardButton.isHidden = true
        } else if currentContentOffset < previousContentOffset {
            dayBackwardButton.isHidden = false
            filterButton.isHidden = false
            dayForwardButton.isHidden = false
        }
        
        previousContentOffset = currentContentOffset
        
    }
    
}
