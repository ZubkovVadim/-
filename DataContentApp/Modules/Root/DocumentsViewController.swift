//
//  DocumentsViewController.swift
//  DataContentApp
//
//  Created by Sergey Balashov on 27.12.2021.
//

import Foundation
import UIKit
import Photos

class DocumentsViewController: UIViewController {
    private lazy var tableView: UITableView = {
        let view = UITableView()
        view.register(cell: ImageViewCell.self)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.dataSource = self
        view.delegate = self
        return view
    }()
    
    private var dataSource: [URL] = []
    private lazy var documentDirectory: URL? = {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    }()
    
    override func loadView() {
        super.loadView()
        view.addSubview(tableView)
        
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        navigationItem.title = "Documents"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewAction))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reloadData()
    }
    
    @objc func addNewAction() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self

        present(imagePicker, animated: true)
    }
    
    func reloadData() {
        prepareData()
        tableView.reloadData()
    }
    
    private func prepareData() {
        let fileManager = FileManager.default
        guard let documents = documentDirectory else {
            return
        }
        
        do {
            let list = try fileManager.contentsOfDirectory(at: documents, includingPropertiesForKeys: nil)
            
            dataSource = list.filter { $0.pathExtension == "jpeg" }
        } catch {
            print("error get documents", error.localizedDescription)
        }
    }
    
    private func saveImage(image: UIImage) {
        guard let documents = documentDirectory,
              let dataImage = image.jpegData(compressionQuality: 0.5) else {
            return
        }
        
        let name = UUID().uuidString
        // Application/Documents/{name}
        let url = documents
            .appendingPathComponent(name)
            .appendingPathExtension("jpeg")
        
        do {
            try dataImage.write(to: url)
        } catch {
            print("error save image", error.localizedDescription)
        }
    }
    
    private func deleteImage(by url: URL) {
        do {
            try FileManager.default.removeItem(at: url)
        } catch {
            print("error removeItem", error.localizedDescription)
        }
    }
}

extension DocumentsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else {
            return
        }
        
        saveImage(image: image)
        reloadData()

        picker.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}

extension DocumentsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ImageViewCell", for: indexPath) as! ImageViewCell
        
        let url = dataSource[indexPath.row]
        let viewModel = ImageViewCellViewModel(imageUrl: url)
        
        cell.configure(viewModel: viewModel)
        
        return cell
    }
    
    // For delete
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let url = dataSource[indexPath.row]
            
            deleteImage(by: url)
            
            prepareData()
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}
