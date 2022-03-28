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
    @IBOutlet weak var searchTable: UITableView!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    
    var spaceShip: SpaceShip = SpaceShip(name: "", speed: 0, capacity: 0, endurance: 0)
    private var shownStationIndex: Int = 1

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.showStation(at: self.shownStationIndex)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let color = self.traitCollection.userInterfaceStyle == .dark ? UIColor.white : UIColor.black
        nextButton.tintColor = color
        previousButton.tintColor = color
        favoriteButton.tintColor = color
        integrityValue.layer.borderColor = color.cgColor
        integrityValue.layer.borderWidth = 3.0
        remainingTime.layer.borderColor = color.cgColor
        remainingTime.layer.borderWidth = 3.0
        searchField.layer.borderColor = color.cgColor
        searchField.layer.borderWidth = 3.0
        stationContainer.layer.borderColor = color.cgColor
        stationContainer.layer.borderWidth = 2.0
        stationContainer.layer.cornerRadius = 15.0
        viewModel.setInitialValues(ship: spaceShip)
        self.fillInfo()
        self.fetchStations()
        searchTable.delegate = self
        searchTable.dataSource = self
        searchTable.isHidden = true
        searchField.addTarget(self, action: #selector(self.textFieldStartedChange(_:)), for: .editingChanged)
        searchField.addTarget(self, action: #selector(self.textFieldStartedChange(_:)), for: .editingDidBegin)
        searchField.addTarget(self, action: #selector(self.textFieldChangeEnded(_:)), for: .editingDidEnd)
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

    @objc func textFieldStartedChange(_ textField: UITextField) {
        searchTable.isHidden = false
        viewModel.filterList(text: textField.text ?? "")
        heightConstraint.constant = viewModel.filteredStations.count > 15 ? 250 : CGFloat(viewModel.filteredStations.count) * SearchCell.cellHeight
        searchTable.reloadData()
    }

    @objc func textFieldChangeEnded(_ textField: UITextField) {
        searchTable.isHidden = true
    }
    
    func finishGame() {
        if !viewModel.isFinished() {
            return
        }
        travelButton.setTitle("Oyunu Bitirdiniz!", for: .normal)
        self.currentStationName.text = "Dünya"
    }
}

extension StationsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.filteredStations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCell", for: indexPath) as? SearchCell {
            let station = self.viewModel.filteredStations[indexPath.row]
            cell.stationName.text = station.name
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return SearchCell.cellHeight
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let station = viewModel.filteredStations[indexPath.row]
        self.shownStationIndex = viewModel.getIndex(of: station)
        self.showStation(at: self.shownStationIndex)
        searchField.text = station.name
        searchField.endEditing(true)
    }
}

class SearchCell: UITableViewCell {
    static let cellHeight: CGFloat = 40
    @IBOutlet weak var stationName: UILabel!
}
