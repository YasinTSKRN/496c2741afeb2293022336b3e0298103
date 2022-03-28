//
//  StationsViewController.swift
//  496c2741afeb2293022336b3e0298103
//
//  Created by yasintaskiran on 27.03.2022.
//

import UIKit

class StationsViewController: UIViewController {

    private var viewModel = StationsViewModel()

    @IBOutlet weak var ugsValue: UILabel!
    @IBOutlet weak var eusValue: UILabel!
    @IBOutlet weak var dsValue: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var integrityValue: UILabel!
    @IBOutlet weak var remainingTime: UILabel!
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var stationContainer: UIView!
    @IBOutlet weak var currentStationName: UILabel!
    @IBOutlet weak var destinationName: UILabel!
    @IBOutlet weak var destinationStock: UILabel!
    @IBOutlet weak var destinationCost: UILabel!
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var travelButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    
    var spaceShip: SpaceShip = SpaceShip(name: "", speed: 0, capacity: 0, endurance: 0)
    private var shownStationIndex: Int = 1

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.showStation(at: self.shownStationIndex)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        integrityValue.layer.borderColor = UIColor.black.cgColor
        integrityValue.layer.borderWidth = 3.0
        remainingTime.layer.borderColor = UIColor.black.cgColor
        remainingTime.layer.borderWidth = 3.0
        searchField.layer.borderColor = UIColor.black.cgColor
        searchField.layer.borderWidth = 3.0
        stationContainer.layer.borderColor = UIColor.black.cgColor
        stationContainer.layer.borderWidth = 2.0
        stationContainer.layer.cornerRadius = 15.0
        viewModel.setInitialValues(ship: spaceShip)
        self.fillInfo()
        self.fetchStations()
    }

    private func fillInfo() {
        ugsValue.text = "\(viewModel.leftCapacity)"
        eusValue.text = "\(spaceShip.speed * 20)"
        dsValue.text = "\(spaceShip.endurance * 10000)"
        name.text = spaceShip.name
        integrityValue.text = "\(viewModel.leftIntegrity)%"
        remainingTime.text = "\(viewModel.leftFuel)s"
        if self.viewModel.availableStations.count > self.viewModel.currentStationIndex {
            self.currentStationName.text = self.viewModel.availableStations[self.viewModel.currentStationIndex].name
        }
    }

    private func fetchStations() {
        self.viewModel.fetchStations { [weak self] in
            guard let strongSelf = self else { return }
            if strongSelf.viewModel.availableStations.count > strongSelf.viewModel.currentStationIndex {
                strongSelf.currentStationName.text = strongSelf.viewModel.availableStations[strongSelf.viewModel.currentStationIndex].name
            }
            strongSelf.showStation(at: strongSelf.shownStationIndex)
        }
    }

    private func showStation(at index: Int) {
        guard index < viewModel.availableStations.count else { return }
        let station = viewModel.availableStations[index]
        destinationName.text = station.name
        destinationStock.text = "\(station.capacity)/\(station.stock)"
        destinationCost.text = "\(viewModel.calculateDistance(destination: station)) EUS"
        previousButton.isEnabled = self.shownStationIndex != 1
        nextButton.isEnabled = self.shownStationIndex != viewModel.availableStations.count - 1
        travelButton.isEnabled = viewModel.canTravel(to: index)
        favoriteButton.setImage(FavoriteManager.shared.isFavorited(station: station) ? UIImage.init(systemName: "star.fill") : UIImage.init(systemName: "star"), for: .normal)
    }
    @IBAction func previousStationAction(_ sender: Any) {
        self.shownStationIndex -= 1
        self.showStation(at: self.shownStationIndex)
    }
    @IBAction func nextStationAction(_ sender: Any) {
        self.shownStationIndex += 1
        self.showStation(at: self.shownStationIndex)
    }
    @IBAction func travelAction(_ sender: Any) {
        viewModel.travel(to: self.shownStationIndex)
        self.showStation(at: self.shownStationIndex)
        fillInfo()
        self.finishGame()
    }
    @IBAction func favoriteAction(_ sender: Any) {
        guard shownStationIndex < viewModel.availableStations.count else { return }
        let station = viewModel.availableStations[shownStationIndex]
        let isFavorited = FavoriteManager.shared.isFavorited(station: station)
        if isFavorited {
            FavoriteManager.shared.removeFavorite(station: station)
        } else {
            FavoriteManager.shared.addFavorite(station: station)
        }
        self.showStation(at: self.shownStationIndex)
    }
    
    func finishGame() {
        if !viewModel.isFinished() {
            return
        }
        travelButton.setTitle("Oyunu Bitirdiniz!", for: .normal)
        self.currentStationName.text = "Dünya"
    }
}
