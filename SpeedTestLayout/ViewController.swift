//
//  ViewController.swift
//  SpeedTestLayout
//
//  Created by Лидия Ладанюк on 15.08.2023.
//

import UIKit

final class ViewController: UIViewController {
    
    // MARK: - Private properties
    private var gaugeView: GaugeView!
    
    private var backgroundImageView: UIImageView = {
        let image = UIImageView(frame: .zero)
        image.image = #imageLiteral(resourceName: "BackGround")
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private var sheetImageView: UIImageView = {
        let image = UIImageView(frame: .zero)
        image.backgroundColor = UIColor(red: 50/255, green: 11/255, blue: 79/255, alpha: 0.8)
        image.layer.cornerRadius = 20
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    // MARK: - LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        gaugeView = GaugeView(frame: CGRect(
            x: 20,
            y: 600,
            width: 344,
            height: 180)
        )

        view.addSubview(backgroundImageView)
        view.addSubview(gaugeView)
        backgroundImageView.addSubview(sheetImageView)
        setUpConstraint()
        
        gaugeView
            .setupGuage(
                startDegree: 90,
                endDegree: 270,
                sectionGap: 20,
                minValue: 0,
                maxValue: 200
            )
            .setupContainer(options: [
                .showContainerBorder,
            ])
            .setupUnitTitle(title: "")
            .buildGauge()
    }
    
    // MARK: - Private Methods
    private func setUpConstraint() {
        NSLayoutConstraint.activate([
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            sheetImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            sheetImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            sheetImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            sheetImageView.heightAnchor.constraint(equalToConstant: view.frame.size.height / 2),
        ])
    }
    
}
