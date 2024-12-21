//
//  SavedTranslationsViewController.swift
//  translator
//
//  Created by Чингис Богдатов on 14.12.2024.
//

import Foundation
import UIKit
import Combine


class SavedTranslationsViewController: UIViewController{
    
    private let viewModel = SavedTranslationsViewModel()
    
    private let showFavourites: Bool
    
    private let translationsTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(TranslationTableViewCell.self, forCellReuseIdentifier: TranslationTableViewCell.identifier)
        tableView.backgroundColor = UIColor(hex: 0x202020)
        return tableView
    }()
    
    private var cancellables = Set<AnyCancellable>()
    private var items: [TranslationItem] = []
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(showFavourites: Bool) {
        self.showFavourites = showFavourites
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        extendedLayoutIncludesOpaqueBars = true
        
        setupView()
        viewModel.loadTranslations(showFavouritesOnly: showFavourites)
        setupConstraints()
        translationsTableView.delegate = self
        translationsTableView.dataSource = self
        setupObservers()
    }
    
    private func setupView() {
        view.backgroundColor = UIColor(hex: 0x202020)
        
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor(hex: 0xfefcfc)]
        navigationController?.navigationBar.tintColor = UIColor(hex: 0xfefcfc)
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        if (showFavourites) {
            title = "Saved"
        } else {
            title = "History"
        }
        
    }
    
    private func setupConstraints(){
        view.addSubview(translationsTableView)
        translationsTableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            translationsTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            translationsTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            translationsTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            translationsTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    private func setupObservers(){
        viewModel.$translations
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newList in
                self?.items = newList
                self?.translationsTableView.reloadData()
            }
            .store(in: &cancellables)
    }
}


extension SavedTranslationsViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TranslationTableViewCell.identifier, for: indexPath) as? TranslationTableViewCell else { fatalError("No default cell provided") }
        let item = items[indexPath.row]
        cell.configure(item: item) { self.viewModel.toggleFavouriteStatus(for: item) }
        
        cell.textLabel?.textColor = UIColor(hex: 0xe3e3e3)
        cell.backgroundColor = UIColor(hex: 0x202020)
        
        return cell
    }
}
