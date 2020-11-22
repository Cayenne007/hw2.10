//
//  FilterViewController.swift
//  theMars
//
//  Created by Cayenne on 14.11.2020.
// 

import UIKit

class FilterViewController: UIViewController {

    
    @IBOutlet var roverTypeSegmentControl: UISegmentedControl!
    @IBOutlet var photoDatePicker: UIDatePicker!
    @IBOutlet var roverInfoLabel: UILabel!
    @IBOutlet var cacheInfoLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    
    
    var delegate: UpdateListDelegate!
    var filter: RoverFilter!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViewController()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setRoverInfo(setDate: false)
    }
    
    
    @IBAction func confirmNewFilter() {
        
        filter.roverType = RoverType.allCases[roverTypeSegmentControl.selectedSegmentIndex]
        filter.date = photoDatePicker.date.toString
        
        AppSettingsManager.standart.saveRoverFilter(filter: filter)
        
        delegate.activityView.startAnimating()
        NetworkManager.shared.loadData(filter: filter) { (photos) in
            
            if photos.count == 0 {
                self.showAlert(title: "Нет данных", message: "В этот день не было данных от ровера. Попробуйте выбрать другой день...")
                self.delegate.activityView.stopAnimating()
                return
            }
            
            self.dismiss(animated: true, completion: nil)
            
            UINotificationFeedbackGenerator().notificationOccurred(.success)
            
            self.delegate.filter = self.filter
            self.delegate.updateList(photos)
            
        }
        
    }
    
    @IBAction func roverChanged() {
        
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        filter.roverType = RoverType.allCases[roverTypeSegmentControl.selectedSegmentIndex]
        setRoverInfo()
        
    }
    
    @IBAction func dateStepperChanged(_ sender: UIStepper) {
        
        if sender.value == 1 {
            photoDatePicker.date = photoDatePicker.date.plus()
        } else {
            photoDatePicker.date = photoDatePicker.date.plus(-1)
        }
        sender.value = 0
    }
    
    @IBAction func openCacheSettings(sender: UITapGestureRecognizer) {
        DataCache.shared.removeAll()
        cacheInfoLabel.text = DataCache.shared.cacheInfo
        showAlert(title: "Кэш изображений", message: "Успешно очищен")
    }
    
    @IBAction func setDefaultSettings(sender: UITapGestureRecognizer) {
        let yesNoAlert = UIAlertController(title: "Настройки", message: "Сбросить настройки?", preferredStyle: UIAlertController.Style.alert)

        yesNoAlert.addAction(UIAlertAction(title: "Да", style: .default) { _ in
            self.filter = AppSettingsManager.standart.defaultFilter()
            self.setupViewController()
        })

        yesNoAlert.addAction(UIAlertAction(title: "Нет", style: .cancel, handler: nil))

        present(yesNoAlert, animated: true, completion: nil)
    }
    
   
    private func setupViewController() {
        
        roverTypeSegmentControl.removeAllSegments()
        for index in 0 ... RoverType.allCases.count-1 {
            roverTypeSegmentControl.insertSegment(withTitle: "\(RoverType.allCases[index])", at: index, animated: false)
        }
        roverTypeSegmentControl.selectedSegmentIndex = filter.roverType.rawValue
        photoDatePicker.date = filter.date.toDate ?? Date()
        
        let cacheTap = UITapGestureRecognizer(target: self, action: #selector(openCacheSettings(sender:)))
        cacheInfoLabel.addGestureRecognizer(cacheTap)
        
        let titleTab = UITapGestureRecognizer(target: self, action: #selector(setDefaultSettings(sender:)))
        titleLabel.addGestureRecognizer(titleTab)
        
        cacheInfoLabel.text = DataCache.shared.cacheInfo
    
    }
    
    private func setRoverInfo(setDate: Bool = true) {
        
        NetworkManager.shared.getRoverInfo(filter: self.filter) { (roverInfo) in
            self.roverInfoLabel.text = roverInfo.info
            
            if setDate, let date = roverInfo.maxDate.toDate {
                self.photoDatePicker.date = date
            }
        }
        
    }

}





