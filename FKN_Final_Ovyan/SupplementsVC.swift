//
//  SupplementsVC.swift
//  FKN_Final_Ovyan
//
//  Copyright © 2018 Mike Ovyan. All rights reserved.
//

import UIKit

protocol NewVCDelegate: class {
    func didCreateTask(with name: String, other: String)
}

final class SupplementsVC: UIViewController {
    @IBOutlet var supList: UITableView!

    @IBOutlet var menuButton: UIBarButtonItem!
    var data = [TextModel]()

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        supList.delegate = self
        supList.dataSource = self
    }

    private func setup() {
        if revealViewController() != nil {
            menuButton.target = revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            view.addGestureRecognizer(revealViewController().panGestureRecognizer())
        }
        for i in 1...5 {
            let newTextModel = TextModel(title: "Supplement \(i)", Description: "Hello world!")
            data.append(newTextModel)
        }
        supList.reloadData()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showSup" {
            guard
                let dst = segue.destination as? SupplementShowVC,
                let model = sender as? TextModel else { fatalError() }

            dst.model = model
        } else {
            guard let dst = segue.destination as? EnterVC else { fatalError() }
            dst.d = self
        }
    }
}

struct TextModel {
    var title: String
    var Description: String
}

extension SupplementsVC: NewVCDelegate {
    func didCreateTask(with name: String, other: String) {
        let newTextModel = TextModel(title: name, Description: other)
        data.append(newTextModel)
        supList.reloadData()
    }
}

extension SupplementsVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = data[indexPath.row]

        performSegue(withIdentifier: "showSup", sender: model)
    }
}

extension SupplementsVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SupplementsCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SupplementsCell

        let model = data[indexPath.row]
        cell.supName.text = model.title
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        cell.date.text = formatter.string(from: date)
        cell.selectionStyle = .none
        return cell
    }
}
