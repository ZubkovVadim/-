//
//  ImageViewCell.swift
//  DataContentApp
//
//  Created by Sergey Balashov on 27.12.2021.
//

import Foundation
import UIKit

struct ImageViewCellViewModel {
    let imageUrl: URL
}

class ImageViewCell: UITableViewCell {
    private lazy var image: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(image)
        
        image.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        image.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        image.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        image.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        image.image = nil
    }
    
    func configure(viewModel: ImageViewCellViewModel) {
        guard let data = try? Data(contentsOf: viewModel.imageUrl) else {
            return
        }

        image.image =  UIImage(data: data)
    }
}
