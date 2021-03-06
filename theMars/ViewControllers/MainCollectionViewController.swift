//
//  MainCollectionViewController.swift
//  theMars
//
//  Created by Cayenne on 14.11.2020.
//

import UIKit
import ImageSlideshow


class MainCollectionViewController: UICollectionViewController {

    var activityView = UIActivityIndicatorView(style: .large)
    var refreshControl: UIRefreshControl!
    
    let dayBackwardButton = FilterButton(systemName: "arrowtriangle.left")
    let filterButton = FilterButton(systemName: "magnifyingglass")
    let dayForwardButton = FilterButton(systemName: "arrowtriangle.right")
    
    var filter = AppSettingsManager.shared.loadRoverFilter()
    var photos: [RoverPhoto] = []
    
    var previousContentOffset: CGFloat = 0
    
    var imageSlideshow: ImageSlideshow!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViewController()
        
        NetworkManager.shared.loadData(filter: filter) { (photos) in
            self.updateList(photos)
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        filterButtonSetConstraint()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        AppSettingsManager.shared.saveRoverFilter(filter: filter)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let filterVC = segue.destination as? FilterViewController {
            filterVC.filter = filter
            filterVC.delegate = self
        } else if let favoriteVC = segue.destination as? FavoriteListViewController {
            favoriteVC.delegate = self
        }
    
    }
    
    private func setupViewController() {
        activityView.startAnimating()
        activityView.hidesWhenStopped = true
        view.addSubview(activityView)
        activityView.center = view.center
        setFilterButtons()
        
        imageSlideshow = ImageSlideshow(frame: CGRect(x: UIScreen.main.bounds.midX,
                                                      y: UIScreen.main.bounds.midY,
                                                      width: 10,
                                                      height: 10))
    }
    
    
}

// MARK: UICollectionViewDataSource
extension MainCollectionViewController {
    
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
        
        let interaction = UIContextMenuInteraction(delegate: self)
        cell.addInteraction(interaction)
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        var collection: [ImageSource] = []
        for element in StorageManager.shared.fetchCollection(photos: photos) {
            collection.append(ImageSource(image: element))
        }
        imageSlideshow.setImageInputs(collection)
        imageSlideshow.setCurrentPage(indexPath.row, animated: false)
        
        imageSlideshow.presentFullScreenController(from: self)
        
    }
    
}



//MARK: Buttons setup
extension MainCollectionViewController {
    private func setFilterButtons() {
        
        view.addSubview(dayBackwardButton)
        dayBackwardButton.addTarget(self, action: #selector(dayChangingButtonsClick(_:)), for: UIControl.Event.touchUpInside)
        
        view.addSubview(filterButton)
        filterButton.addTarget(self, action: #selector(filterButtonClick(_:)), for: UIControl.Event.touchUpInside)
        let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(openFavoriteList(_:)))
        filterButton.addGestureRecognizer(longGesture)
        
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
        
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        filter.date = (sender.tag == 0) ? filter.date.plus(-1) : filter.date.plus()
        sender.pulsate()
        activityView.startAnimating()
        
        NetworkManager.shared.loadData(filter: filter) { (photos) in
            self.updateList(photos)
        }

    }
    
    @IBAction func filterButtonClick(_ sender: UIButton){

        performSegue(withIdentifier: "filter", sender: nil)

    }

    @IBAction func openFavoriteList(_ gesture: UILongPressGestureRecognizer) {
        
        if gesture.state == .began {
            UINotificationFeedbackGenerator().notificationOccurred(.success)
            performSegue(withIdentifier: "toFavoriteList", sender: nil)
        }
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


extension MainCollectionViewController: UpdateFavoriteListDelegate {
    func updateListFavorite() {
        collectionView.reloadData()
    }
}

extension MainCollectionViewController: UIContextMenuInteractionDelegate {
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        nil
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let configuration = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { suggestedActions in
            
            let photo = self.photos[indexPath.item]
            
            var actions = [UIAction]()
            
            let favoriteTitle = photo.isFavorite ? "Убрать из избранного" : "Добавить в избранное"
            let favoriteImage = photo.isFavorite ? UIImage(systemName: "star.slash") : UIImage(systemName: "star")
            let action = UIAction(title: favoriteTitle,
                                  image: favoriteImage) { _ in
                if photo.isFavorite {
                    RoverFavorite.shared.del(photo)
                } else {
                    RoverFavorite.shared.add(photo)
                }
                self.collectionView.reloadItems(at: [indexPath])
            }
            
            let saveAction = UIAction(title: "Сохранить",
                                      image: UIImage(systemName: "folder")) { (action) in
                NetworkManager.shared.fetchImage(photo.imageUrl) { (image) in
                    if let image = image {
                        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                        self.showAlert(title: "Сохранено", message: "")
                    }
                    
                }
            }
            
            actions.append(action)
            actions.append(saveAction)
            return UIMenu(title: "", children: actions)
        }
        return configuration
        
    }
        
}
