//
//  imagesVC.swift
//  FKN_Final_Ovyan
//
//  Copyright © 2018 Mike Ovyan. All rights reserved.
//

import UIKit

final class ImageCell: UICollectionViewCell {
    @IBOutlet var imageView: UIImageView!
}

final class imagesVC: UIViewController {
    // MARK: - Outlets

    @IBOutlet var imageCollection: UICollectionView!

    // MARK: - Overrides

    override func viewDidLoad() {
        super.viewDidLoad()

        title = model.element.name
    }

    // MARK: - Members

    var model: Box<ImageModel>!

    // MARK: - Actions

    @IBAction
    private func addPic(_ sender: Any) {
        print("Выбери изображение профиля")
        let alertController = UIAlertController(title: "Выбери изображение профиля",
                                                message: nil,
                                                preferredStyle: .actionSheet)

        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let chooseFromGallery = UIAlertAction(title: "Выбрать из библиотеки", style: .default) { [weak self] _ in
                self?.presentImagePicker(with: .photoLibrary)
            }
            alertController.addAction(chooseFromGallery)
        }

        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let takePhoto = UIAlertAction(title: "Сделать фото", style: .default) { [weak self] _ in
                self?.presentImagePicker(with: .camera)
            }
            alertController.addAction(takePhoto)
        }

        let cancel = UIAlertAction(title: "Отмена", style: .cancel) { [weak self] _ in
            self?.dismiss(animated: true)
        }
        alertController.addAction(cancel)

        if let ipadPopover = alertController.popoverPresentationController {
            let btn = navigationController?.navigationItem.rightBarButtonItem?.customView ?? UIView()
            ipadPopover.sourceView = btn
        }

        present(alertController, animated: true)
    }

    @IBAction func dismiss() {
        dismiss(animated: true)
    }

    // MARK: - Helpers

    private func presentImagePicker(with type: UIImagePickerController.SourceType) {
        let picker = UIImagePickerController()
        picker.sourceType = type
        picker.delegate = self
        picker.allowsEditing = true

        present(picker, animated: true)
    }
}

extension imagesVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
}

extension imagesVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model.element.images.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ImageCell
        let image = model.element.images[indexPath.row]
        cell.imageView.image = image

        return cell
    }
}

extension imagesVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        var pickedImage: Any?
        pickedImage = info[.editedImage] ?? info[.originalImage]

        if let pickedImage = pickedImage as? UIImage {
            model.element.images.append(pickedImage)
            imageCollection.reloadData()
        }
        dismiss(animated: true, completion: nil)
    }
}
