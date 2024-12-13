//
//  SavedTranslationsViewController.swift
//  translator
//
//  Created by Чингис Богдатов on 14.12.2024.
//

import Foundation
import UIKit


class SavedTranslationsViewController: UIViewController{
    
    private let translationsTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        tableView.register(TranslationTableViewCell.self, forCellReuseIdentifier: TranslationTableViewCell.identifier)
        return tableView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "SAVED"
        self.navigationItem.backBarButtonItem?.tintColor = .white
        self.navigationItem.backButtonTitle = "Home"
        setupConstraints()
        translationsTableView.delegate = self
        translationsTableView.dataSource = self
    
    }
    
    
    private func setupConstraints(){
        view.addSubview(translationsTableView)
        translationsTableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            translationsTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            translationsTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            translationsTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            translationsTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
}


extension SavedTranslationsViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TranslationTableViewCell.identifier, for: indexPath) as? TranslationTableViewCell else { fatalError("No default cell provided") }
        cell.configure(item: TranslationItem(firstLanguageText: "Компот", secondLanguageText: "Compot", isSaved: false))
        return cell
    }
}
