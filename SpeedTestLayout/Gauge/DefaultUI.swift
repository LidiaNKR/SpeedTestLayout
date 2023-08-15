//
//  DefaultUI.swift
//  SpeedTestLayout
//
//  Created by Лидия Ладанюк on 15.08.2023.
//

import UIKit

public enum DefaultUI {
    
    public enum Container {
        
        // MARK: - Public properties
        //Цвет полукруга
        public static let color = UIColor(
            red: 0.285,
            green: 0.403,
            blue: 0.688,
            alpha: 0.6
        )
        
        //Цвет Стрелки
        public static let handleColor = UIColor(
            red: 0.984,
            green: 0.839,
            blue: 0.50,
            alpha: 1
        )
        
        //Цвет лейблов
        public static let indicatorValuesColor = UIColor(
            red: 1,
            green: 1,
            blue: 1,
            alpha: 0.8
        )
        
        //Градиент стрелки
        public static let primaryColor = UIColor(
            red: 1,
            green: 1,
            blue: 1,
            alpha: 1
        )
        
        //Градиент стрелки
        public static let secondaryColor = UIColor(
            red: 0.984,
            green: 0.839,
            blue: 0.506,
            alpha: 1
        )

        public static let indicatorsFont = UIFont.preferredFont(forTextStyle: .caption1)
    }

    public enum Unit {
        public static let font = UIFont.preferredFont(forTextStyle: .caption2)
    }
}
