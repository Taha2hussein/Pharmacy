//
//  ProgressBar.swift
//  Pharmacy
//
//  Created by taha hussein on 27/03/2022.
//

import UIKit
class MultiProgressView: UIStackView {

    struct ProgressInfo {
        let progressView: UIProgressView
        let totalToken: NSKeyValueObservation
        let progressToken: NSKeyValueObservation
    }
    var progressInfo = [ProgressInfo]()
    var progressHandler: ((Double) -> Void)?

    var widthConstraints: [NSLayoutConstraint]?

    func add(_ progress: Progress, progressTintColor: UIColor = .blue, trackTintColor: UIColor? = nil) {
        let progressView = UIProgressView(progressViewStyle: .bar)
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.progressTintColor = progressTintColor
        progressView.trackTintColor = trackTintColor ?? progressTintColor.withAlphaComponent(0.5)
        addArrangedSubview(progressView)
        progressView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 1)
        progressView.observedProgress = progress
        let totalToken = progress.observe(\.totalUnitCount) { [weak self] (_, _) in
            self?.updateWidths()
        }
        let progressToken = progress.observe(\.completedUnitCount) { [weak self] (_, _) in
            if let percent = self?.percent {
                self?.progressHandler?(percent)
            }
        }
        progressInfo.append(ProgressInfo(progressView: progressView, totalToken: totalToken, progressToken: progressToken))
        updateWidths()
    }

    private func updateWidths() {
        if let widthConstraints = self.widthConstraints {
            removeConstraints(widthConstraints)
        }

        let totalUnitCount = self.totalUnitCount
        guard totalUnitCount > 0 else { return }

        widthConstraints = progressInfo.map { progressInfo in
            let unitCount = progressInfo.progressView.observedProgress?.totalUnitCount ?? 0
            return NSLayoutConstraint(item: progressInfo.progressView, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: CGFloat(unitCount) / CGFloat(totalUnitCount), constant: 0)
        }

        DispatchQueue.main.async {
            self.addConstraints(self.widthConstraints!)
        }
    }

    var totalUnitCount: Int64 {
        return progressInfo.reduce(Int64(0)) { $0 + ($1.progressView.observedProgress?.totalUnitCount ?? 0) }
    }

    var completedUnitCount: Int64 {
        return progressInfo.reduce(Int64(0)) { $0 + ($1.progressView.observedProgress?.completedUnitCount ?? 0) }
    }

    var percent: Double {
        return Double(completedUnitCount) / Double(totalUnitCount)
    }
}
