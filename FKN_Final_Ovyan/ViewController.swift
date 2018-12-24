//
//  ViewController.swift
//  FKN_Final_Ovyan
//
//  Copyright © 2018 Mike Ovyan. All rights reserved.
//

import UIKit

protocol ImageControllerDelegate: class {
    func addedNewImage()
}

final class ViewController: UIViewController {
    // MARK: - Outlets
    
    @IBOutlet var listTable: UITableView!
    
    @IBOutlet var menuButton: UIBarButtonItem!
    
    // MARK: - Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupScreen()
    }
    
    // MARK: - Members
    
    typealias ModelType = Box<ImageModel>
    
    var models: [ModelType] = []
    
    // MARK: - Methods
    
    private func setupScreen() {
        setup()
    }
    
    private func setup() {
        if revealViewController() != nil {
            menuButton.target = revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            view.addGestureRecognizer(revealViewController().panGestureRecognizer())
        }
        let setup = [setColors]
        setup.forEach { $0() }
        generateModels()
    }
    
    private func setColors() {}
    
    private func generateModels() {
        for i in 1...5 {
            let newModel = ImageModel.new(with: "lecture \(i)")
            let newBox = Box(element: newModel)
            models.append(newBox)
        }
        listTable.reloadData()
    }
    
    @IBAction func addEntry() {
        let alert = UIAlertController(title: "Form", message: "Enter title", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "some name"
        }
        let confirm = UIAlertAction(title: "OK", style: .default) { _ in
            guard
                let textField = alert.textFields?.first,
                let text = textField.text else { return }
            
            self.saveNewEntry(text)
        }
        alert.addAction(confirm)
        
        present(alert, animated: true)
    }
    
    private func saveNewEntry(_ named: String) {
        let newModel = ImageModel.new(with: named)
        let newBox = Box(element: newModel)
        models.append(newBox)
        
        listTable.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard
            let dst = segue.destination as? imagesVC,
            let model = sender as? ModelType else { fatalError() }
        
        dst.model = model
    }
}

final class Box<Type> {
    // MARK: - Members
    
    var element: Type
    
    // MARK: - Init
    
    init(element: Type) {
        self.element = element
    }
}

struct ImageModel {
    let name: String
    var images: [UIImage]
}

extension ImageModel {
    static func new(with name: String) -> ImageModel {
        let defaultImage = UIImage(named: "test.jpg")!
        
        return ImageModel(name: name, images: [defaultImage, defaultImage, defaultImage, defaultImage, defaultImage])
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = models[indexPath.row]
        
        performSegue(withIdentifier: "showImage", sender: model)
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: LectureCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! LectureCell
        let model = models[indexPath.row].element
        
        cell.lectureName.text = model.name
        cell.selectionStyle = .none
        return cell
    }
}
