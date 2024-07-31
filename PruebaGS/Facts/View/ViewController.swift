//
//  ViewController.swift
//  PruebaGS
//
//  Created by PEDRO MENDEZ on 30/07/24.
//
import UIKit
import Combine

class ViewController: UIViewController {
    
    /// ViewModel to handle data fetching and business logic
    private var viewModel: ContentViewModel!
    
    /// Set to store Combine cancellables for memory management
    private var cancellables = Set<AnyCancellable>()
    
    /// Array to hold breed data for the table view
    private var breeds: [BreedViewData] = []
    
    /// UIImageView to display a profile picture
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 40
        imageView.clipsToBounds = true
        /// Setting a custom image from the asset catalog
        imageView.image = UIImage(named: "revan")
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    }()
    
    /// UILabel to display the name
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Pedro Mendez Tostado"
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textColor = .black
        
        return label
    }()
    
    /// UILabel to display additional information
    private let infoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Sistemas Computacionales\n30/Julio/2024"
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 2
        label.textColor = .black
        label.textAlignment = .right
        
        return label
    }()
    
    /// UITableView to display the list of breeds
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubviews(imageView, nameLabel, infoLabel, tableView)
        
        /// Initializing the ViewModel with the service
        let service = BreedService()
        viewModel = ContentViewModel(service: service)
        viewModel.fetchData()
        
        /// Setting up constraints for UI elements
        setupConstraints()
        
        /// Setting up table view data source and delegate
        setupTableView()
        
        /// Setting up bindings to handle data updates
        setupBindings()
    }
    
    /// Method to setup constraints for UI elements
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            imageView.widthAnchor.constraint(equalToConstant: 80),
            imageView.heightAnchor.constraint(equalToConstant: 80),
            
            nameLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 20),
            nameLabel.centerYAnchor.constraint(equalTo: imageView.centerYAnchor),
            
            infoLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            infoLabel.centerYAnchor.constraint(equalTo: imageView.centerYAnchor),
            
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            tableView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    /// Method to setup the table view
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "CustomCell")
    }
    
    /// Method to setup bindings between ViewModel subjects and UI
    private func setupBindings() {
        viewModel.breedsSubject.receive(on: DispatchQueue.main).sink { [weak self] breeds in
            self?.breeds = breeds
            self?.tableView.reloadData()
        }
        .store(in: &cancellables)
        
        viewModel.isLoadingSubject.receive(on: DispatchQueue.main).sink { [weak self] isLoading in
            // handle loading state, show/hide activity indicator
            print("Loading: \(isLoading)")
        }
        .store(in: &cancellables)
        
        viewModel.errorSubject.receive(on: DispatchQueue.main).sink { [weak self] error in
            self?.showError(error)
        }
        .store(in: &cancellables)
    }
    
    /// Method to handle errors and display appropriate messages
    private func showError(_ error: Error) {
        //TODO: Display error to user
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    /// Number of sections in the table view
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    /// Number of rows in each section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return breeds.count
    }
    
    /// Configure and return cell for each row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! CustomTableViewCell
        let breed = breeds[indexPath.row]
        cell.idLabel.text = "\(breed.id)"
        cell.nameLabel.text = breed.breed.breed
        cell.breedLabel.text = breed.breed.country
        cell.descriptionLabel.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore"
        return cell
    }
    
    /// Configure and return the header view for each section
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .green
        
        let idLabel = UILabel()
        idLabel.translatesAutoresizingMaskIntoConstraints = false
        idLabel.text = "ID"
        idLabel.font = UIFont.boldSystemFont(ofSize: 14)
        idLabel.textColor = .black
        idLabel.textAlignment = .center
        
        let nameLabel = UILabel()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.text = "Nombre"
        nameLabel.font = UIFont.boldSystemFont(ofSize: 14)
        nameLabel.textColor = .black
        nameLabel.textAlignment = .center
        
        let breedLabel = UILabel()
        breedLabel.translatesAutoresizingMaskIntoConstraints = false
        breedLabel.text = "Raza"
        breedLabel.font = UIFont.boldSystemFont(ofSize: 14)
        breedLabel.textColor = .black
        breedLabel.textAlignment = .center
        
        let descriptionLabel = UILabel()
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.text = "Descripción"
        descriptionLabel.font = UIFont.boldSystemFont(ofSize: 14)
        descriptionLabel.textColor = .black
        descriptionLabel.textAlignment = .center
        
        headerView.addSubviews(idLabel, nameLabel, breedLabel, descriptionLabel)
        
        NSLayoutConstraint.activate([
            idLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 8),
            idLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            idLabel.widthAnchor.constraint(equalToConstant: 30),
            
            nameLabel.leadingAnchor.constraint(equalTo: idLabel.trailingAnchor, constant: 8),
            nameLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            nameLabel.widthAnchor.constraint(equalToConstant: 100),
            
            breedLabel.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 8),
            breedLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            breedLabel.widthAnchor.constraint(equalToConstant: 100),
            
            descriptionLabel.leadingAnchor.constraint(equalTo: breedLabel.trailingAnchor, constant: 8),
            descriptionLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -8),
            descriptionLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor)
        ])
        
        return headerView
    }
    
    /// Height for the header in each section
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 44 : 0
    }
}
