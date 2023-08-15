//
//  Calculations.swift
//  SpeedTestLayout
//
//  Created by Лидия Ладанюк on 15.08.2023.
//

import Foundation

extension CGFloat {
    var radian: CGFloat {
        CGFloat(self * CGFloat(.pi / 180.0))
    }
}

struct Calculations {
    
    // MARK: - Public properties
    let minValue: CGFloat
    let maxValue: CGFloat
    let sectionsGapValue: CGFloat
    let startDegree: CGFloat
    let endDegree: CGFloat

    var totalSeparationPoints: Int {
        Int((maxValue - minValue) / sectionsGapValue)
    }
    
    ///Начальная точка полукруга
    var calculatedStartDegree: CGFloat {
        270.0 - startDegree
    }

    ///Конечная точка полукруга
    var calculatedEndDegree: CGFloat {
        return 270.0 - endDegree + 360
    }
    
    // MARK: - Puplic methods
    ///Получение новой позиции
    func getNewPosition(_ currentValue: CGFloat, diff: CGFloat = 0) -> CGFloat {
        var filteredCurrentValue = currentValue
        if currentValue > maxValue {
            filteredCurrentValue = maxValue
        }
        if currentValue < minValue {
            filteredCurrentValue = minValue
        }
        let convertedDegree = filteredCurrentValue * (360.0 - (calculatedEndDegree - calculatedStartDegree))
        return (calculatedStartDegree - (convertedDegree / maxValue)) + diff
    }
    
    ///Расчет градуса
    func calculateDegree(for point: CGFloat) -> CGFloat {
        guard point != 0 else {
            return calculatedStartDegree
        }
        return point == CGFloat(totalSeparationPoints)
        ? calculatedEndDegree
        : calculatedStartDegree - ((360.0 - (calculatedEndDegree - calculatedStartDegree)) / CGFloat(totalSeparationPoints)) * point
    }
}
