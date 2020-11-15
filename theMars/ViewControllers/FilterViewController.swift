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
        
        delegate.activityView.startAnimating()
        NetworkManager.loadData(filter: filter) { (photos) in
            self.delegate.filter = self.filter
            self.delegate.updateList(photos)
        }
        dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func roverChanged() {
        
        filter.roverType = RoverType.allCases[roverTypeSegmentControl.selectedSegmentIndex]
        setRoverInfo()
        
    }
    
    private func setupViewController() {
        
        roverTypeSegmentControl.removeAllSegments()
        for index in 0 ... RoverType.allCases.count-1 {
            roverTypeSegmentControl.insertSegment(withTitle: "\(RoverType.allCases[index])", at: index, animated: false)
        }
        roverTypeSegmentControl.selectedSegmentIndex = filter.roverType.rawValue
        photoDatePicker.date = filter.date.toDate ?? Date()
    }
    
    private func setRoverInfo(setDate: Bool = true) {
        DispatchQueue.global().async {
            NetworkManager.getRoverInfo(filter: self.filter) { (roverInfo) in
                DispatchQueue.main.async {
                    self.roverInfoLabel.text = roverInfo.info
                    
                    if setDate, let date = roverInfo.max_date.toDate {
                        self.photoDatePicker.date = date
                    }
                }
            }
        }
    }
    

}
