//
//  CustomProgressBar.swift
//  PitchGraphOpenSource
//
//  Created by James Ryu on 2024-01-15.
//

import UIKit

final class CustomProgressBar: UIView {
    private var minProgressView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBlue
        return view
    }()
    private var maxProgressView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemPink
        return view
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    private func setupViews() {
        self.backgroundColor = .lightGray
        self.addSubview(minProgressView)
        self.addSubview(maxProgressView)
        minProgressView.translatesAutoresizingMaskIntoConstraints = false
        maxProgressView.translatesAutoresizingMaskIntoConstraints = false
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
    }
    func setProgress(minValue: CGFloat, maxValue: CGFloat) {
        let totalWidth = UIScreen.main.bounds.width - 40
        var minProgressWidth = 0.0
        var maxProgressWidth = 0.0
        self.minProgressView.frame = CGRect(x: 0, y: 0, width: minProgressWidth, height: 20)
        self.maxProgressView.frame = CGRect(x: 0, y: 0, width: maxProgressWidth, height: 20)
        UIView.animate(withDuration: 1.0) {
            maxProgressWidth = (totalWidth * maxValue) / 200
            self.maxProgressView.frame = CGRect(x: 0, y: 0, width: maxProgressWidth, height: 20)
        } completion: { _ in
            UIView.animate(withDuration: 1.0) {
                minProgressWidth = (totalWidth * minValue) / 200
                self.minProgressView.frame = CGRect(x: 0, y: 0, width: minProgressWidth, height: 20)
            }
        }
        minProgressView.layer.cornerRadius = 10
        minProgressView.clipsToBounds = true
        maxProgressView.layer.cornerRadius = 10
        maxProgressView.clipsToBounds = true
        self.bringSubviewToFront(minProgressView)
    }
}
