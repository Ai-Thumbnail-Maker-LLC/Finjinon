//
//  Copyright (c) 2019 FINN.no AS. All rights reserved.
//

import UIKit

final class LowLightView: UIView {
    lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(
            named: "LowLightIcon",
            in: Bundle(for: LowLightView.self),
            compatibleWith: nil
        )
        return imageView
    }()

    lazy var textLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()

    var text: String? {
        get { return textLabel.text }
        set { textLabel.text = newValue }
    }

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    // MARK: - Setup

    private func setup() {
        backgroundColor = UIColor(red: 0.165, green: 0.251, blue: 0.329, alpha: 1.0).withAlphaComponent(0.8)
        layer.cornerRadius = 8

        addSubview(iconImageView)
        addSubview(textLabel)

        let spacing: CGFloat = 8

        NSLayoutConstraint.activate([
            iconImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: spacing),
            iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor),

            textLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: spacing),
            textLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -spacing),
            textLabel.topAnchor.constraint(equalTo: topAnchor, constant: spacing),
            textLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -spacing)
        ])
    }
}
