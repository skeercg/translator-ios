import UIKit

class LanguageSelectorView: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var onLanguageSelected: ((String) -> Void)?
    var selectorTitle: String?
    
    init(selectorTitle: String?, onLanguageSelected: ((String) -> Void)?) {
        self.onLanguageSelected = onLanguageSelected
        self.selectorTitle = selectorTitle
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let groupedLanguages = [
        "A": ["Abkhaz", "Achinese", "Acholi", "Afar", "Afrikaans", "Albanian", "Amharic", "Arabic", "Armenian", "Assamese", "Avar", "Awadhi", "Aymara", "Azerbaijani"],
        "B": ["Bengali", "Bosnian", "Bulgarian"],
        "C": ["Chinese", "Croatian", "Czech"],
        "D": ["Danish", "Dutch", "Dari"],
        "E": ["English", "Estonian", "Esperanto"],
        "F": ["Finnish", "French", "Farsi"],
        "G": ["German", "Greek", "Georgian"],
        "H": ["Hindi", "Hungarian"],
        "I": ["Italian", "Icelandic"],
        "J": ["Japanese", "Javanese"],
        "K": ["Korean", "Kazakh", "Kurdish"],
        "L": ["Latvian", "Lithuanian", "Luxembourgish"],
        "M": ["Mandarin", "Malay", "Marathi", "Macedonian"],
        "N": ["Nepali", "Norwegian"],
        "P": ["Polish", "Portuguese", "Pashto"],
        "R": ["Russian", "Romanian"],
        "S": ["Spanish", "Swedish", "Slovak", "Slovene"],
        "T": ["Turkish", "Tamil"],
        "U": ["Ukrainian", "Urdu"]
    ]
    
    // Sort the section keys alphabetically
    var sortedSectionKeys: [String] {
        return groupedLanguages.keys.sorted()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    func setupView() {
        view.backgroundColor = UIColor(hex: 0x2e2f31)
        
        // Initialize the UI components
        let titleLabel = UILabel()
        titleLabel.text = selectorTitle!
        titleLabel.font = UIFont.systemFont(ofSize: 18)
        titleLabel.textColor = UIColor(hex: 0xfefbfa)
        titleLabel.textAlignment = .center
        
        // Set up the table view
        let tableView = UITableView()
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .clear
        tableView.separatorColor = UIColor(hex: 0x444646)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.showsVerticalScrollIndicator = false
        
        // Create the stack view to arrange the components vertically
        let stackView = UIStackView(arrangedSubviews: [titleLabel, tableView])
        stackView.axis = .vertical
        stackView.spacing = 32
        stackView.alignment = .fill
        stackView.distribution = .fill
        
        // Add the stack view to the main view
        view.addSubview(stackView)
        
        // Set the stack view constraints to fill the parent view
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    // MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sortedSectionKeys.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionKey = sortedSectionKeys[section]
        return groupedLanguages[sectionKey]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let sectionKey = sortedSectionKeys[indexPath.section]
        cell.textLabel?.text = groupedLanguages[sectionKey]?[indexPath.row]
        cell.textLabel?.textColor = UIColor(hex: 0xe3e3e3)
        cell.backgroundColor = UIColor(hex: 0x141414)
        
        // Reset corner radius for every cell
        cell.layer.cornerRadius = 0
        cell.layer.masksToBounds = false
        
        // Apply corner radius to the first and last elements
        if indexPath.row == 0 {
            // First element, round top corners
            cell.layer.cornerRadius = 12
            cell.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            cell.layer.masksToBounds = true
        } else if indexPath.row == groupedLanguages[sectionKey]!.count - 1 {
            // Last element, round bottom corners
            cell.layer.cornerRadius = 12
            cell.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            cell.layer.masksToBounds = true
        }
        
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sortedSectionKeys[section]
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        // Change the background color of the header
        view.tintColor = UIColor(hex: 0x2e2f31)
        
        if let header = view as? UITableViewHeaderFooterView {
            header.textLabel?.textColor = UIColor(hex: 0xa09ea7)
            header.textLabel?.font = UIFont.systemFont(ofSize: 18)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sectionKey = sortedSectionKeys[indexPath.section]
        let selectedLanguage = groupedLanguages[sectionKey]?[indexPath.row]
        onLanguageSelected?(selectedLanguage!)
        
        dismiss(animated: true, completion: nil)
    }
}
