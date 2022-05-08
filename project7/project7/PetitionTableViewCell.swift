//
//  Created by Qing Li on 08/05/2022.
//

import UIKit

class PetitionTableViewCell: UITableViewCell {

    static let reuseIdentifier = "petitionCellReuse"
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 18)
        return label
    }()
    
    private let bodyLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16)
        return label
        
    }()
    
    private let countLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16)
        label.textColor = .systemPink
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(bodyLabel)
        contentView.addSubview(countLabel)
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) { nil }
    
    private func setupLayout() {
        let widthPadding: CGFloat = 20
        let heightPadding: CGFloat = 12
        let labelHeight: CGFloat = 20
        let margin: CGFloat = 8
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: widthPadding),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -widthPadding * 3.5),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: heightPadding),
            titleLabel.heightAnchor.constraint(equalToConstant: labelHeight)
        ])
        
        NSLayoutConstraint.activate([
            bodyLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: widthPadding),
            bodyLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -widthPadding * 3.5),
            bodyLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: heightPadding),
            bodyLabel.heightAnchor.constraint(equalToConstant: labelHeight)
        ])
        
        NSLayoutConstraint.activate([
            countLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            countLabel.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -margin)
        ])
    }
    
    func configure(petition: Petition) {
        titleLabel.text = petition.title
        bodyLabel.text = petition.body
        countLabel.text = String(petition.signatureCount)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        bodyLabel.text = nil
        countLabel.text = nil
    }
}
