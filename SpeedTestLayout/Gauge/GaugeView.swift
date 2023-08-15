//
//  GaugeView.swift
//  SpeedTestLayout
//
//  Created by Лидия Ладанюк on 15.08.2023.
//

import UIKit

public final class GaugeView: UIView {
    // MARK: - Private properties
    private var containerShape: CAShapeLayer!
    private var handleShape: CAShapeLayer!
    
    // MARK: - Container properties
    private var containerBorderWidth: CGFloat!
    private var showContainerBorder = true
    private var containerColor: UIColor!
    private var handleColor: UIColor!
    private var indicatorsFont: UIFont!
    private var indicatorsValuesColor: UIColor!
    private var options: [GaugeOptions]!

    // MARK: - Unit properties
    private var unitTitle: String?
    private var unitTitleFont: UIFont!
    
    // MARK: - Other properties
    private var startDegree: CGFloat!
    private var endDegree: CGFloat!
    private var sectionsGapValue: CGFloat!
    private var minValue: CGFloat!
    private var maxValue: CGFloat!
    private var currentValue: CGFloat!

    // MARK: Dependencies
    private var calculations: Calculations!

    override public init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    // MARK: - Setup and build Gauge View
    
    ///Устанавливаем SpeedTest
    public func setupGuage(
        startDegree: CGFloat,
        endDegree: CGFloat,
        sectionGap: CGFloat,
        minValue: CGFloat,
        maxValue: CGFloat,
        currentValue: CGFloat = 0.0
    ) -> Self {
        self.startDegree = startDegree
        self.endDegree = endDegree
        self.sectionsGapValue = sectionGap
        self.minValue = minValue
        self.maxValue = maxValue
        self.currentValue = currentValue

        self.calculations = .init(
            minValue: minValue,
            maxValue: maxValue,
            sectionsGapValue: sectionGap,
            startDegree: startDegree,
            endDegree: endDegree
        )

        return self
    }

    //Устанавливаем SpeedTest
    public func setupContainer(
        width: CGFloat = 40,
        color: UIColor = DefaultUI.Container.color,
        handleColor: UIColor = DefaultUI.Container.secondaryColor,
        options: [GaugeOptions] = [.showContainerBorder],
        indicatorsValuesColor: UIColor = DefaultUI.Container.indicatorValuesColor,
        indicatorsFont: UIFont = DefaultUI.Container.indicatorsFont
    ) -> Self {
        self.containerBorderWidth = width
        self.options = options
        self.indicatorsFont = indicatorsFont
        self.containerColor = color
        self.handleColor = handleColor
        self.indicatorsValuesColor = indicatorsValuesColor
        return self
    }

    ///Устанавливаем значения
    public func setupUnitTitle(
        title: String,
        font: UIFont = DefaultUI.Unit.font
    ) -> Self {
        self.unitTitle = title
        self.unitTitleFont = font
        return self
    }

    /// Конфигурируем SpeedTest
    public func buildGauge() {
        drawContainerShape()
        drawHandleShape()
        drawIndicators()
    }
    
    ///Настройка полукруг
    private func drawContainerShape() {
        let startDegree: CGFloat = 360.0 - calculations.calculatedEndDegree
        let endDegree: CGFloat = 360.0 - calculations.calculatedStartDegree

        containerShape = CAShapeLayer()
        containerShape.fillColor = nil
        containerShape.strokeColor = containerColor.cgColor
        containerShape.lineWidth = containerBorderWidth

        var containerPath: CGPath!
            containerPath = UIBezierPath(arcCenter: CGPoint(x: frame.width / 2, y: frame.height / 2),
                                         radius: (frame.width / 3.7),
                                         startAngle: startDegree.radian,
                                         endAngle: endDegree.radian, clockwise: false).cgPath

        containerShape?.path = containerPath
        layer.addSublayer(containerShape)
    }
    
    ///Настройка стрелки
    private func drawHandleShape() {
        handleShape = CAShapeLayer()
        handleShape.fillColor = handleColor.cgColor
        
        let baseDegree = calculations
            .getNewPosition(currentValue)
            .radian
        let leftAngle = calculations
            .getNewPosition(currentValue, diff: 170)
            .radian

        let rightAngle = calculations
            .getNewPosition(currentValue, diff: -150)
            .radian

        let startVal = frame.width / 3.5
        let length = CGFloat(7)
        let endVal = startVal + length
        let centerPoint = CGPoint(x: frame.width / 2, y: frame.height / 2)
        let endPoint = CGPoint(x: cos(-baseDegree) * endVal + centerPoint.x,
                               y: sin(-baseDegree) * endVal + centerPoint.y)
        let rightPoint = CGPoint(x: cos(-leftAngle) * CGFloat(15) + centerPoint.x,
                                 y: sin(-leftAngle) * CGFloat(15) + centerPoint.y)
        let leftPoint = CGPoint(x: cos(-rightAngle) * CGFloat(15) + centerPoint.x,
                                y: sin(-rightAngle) * CGFloat(15) + centerPoint.y)
        
        let handlePath = UIBezierPath()
        handlePath.move(to: rightPoint)
        
        let midx = rightPoint.x + ((leftPoint.x - rightPoint.x) / 2)
        let midy = rightPoint.y + ((leftPoint.y - rightPoint.y) / 2)
        let diffx = midx - rightPoint.x
        let diffy = midy - rightPoint.y
        let angle = (atan2(diffy, diffx) * CGFloat((180 / Double.pi))) - 90
        let targetRad = angle.radian
        let newX = midx - 10 * cos(targetRad)
        let newY = midy - 10 * sin(targetRad)
        
        handlePath.addQuadCurve(to: leftPoint, controlPoint: CGPoint(x: newX, y: newY))
        handlePath.addLine(to: endPoint)
        handlePath.addLine(to: rightPoint)
        
        handleShape.path = handlePath.cgPath
        handleShape.anchorPoint = centerPoint
        handleShape.path = handlePath.cgPath
        layer.addSublayer(handleShape)
    }

    ///Добавляем градиент на стрелку
    func addVerticalGradientLayer(topColor: UIColor, bottomColor: UIColor) {
        let gradient = CAGradientLayer()
        gradient.frame = handleShape.frame
        gradient.colors = [topColor.cgColor, bottomColor.cgColor]
        gradient.locations = [0.0, 1.0]
        gradient.startPoint = CGPoint(x: 0, y: 1)
        gradient.endPoint = CGPoint(x: 1, y: 0)
        gradient.mask = handleShape
    }
    
    ///Размеры значений
    private func drawIndicators() {
        let center = CGPoint(x: frame.width / 2, y: frame.height / 2)
        addTextLabels(centerPoint: center)
    }
    
    ///Устанавливаем значения
    private func addTextLabels(centerPoint: CGPoint) {
        for i in 0...calculations.totalSeparationPoints {
            let endValue = (frame.width / 3) * 1.03
            
            let baseRad = calculations
                .calculateDegree(for: CGFloat(i))
                .radian
            let endPoint = CGPoint(x: cos(-baseRad) * endValue + centerPoint.x,
                                   y: sin(-baseRad) * endValue + centerPoint.y)
            
            var indicatorValue: CGFloat = 0
            indicatorValue = sectionsGapValue * CGFloat(i) + minValue
            
            var indicatorStringValue : String = ""
            if indicatorValue.truncatingRemainder(dividingBy: 1) == 0{
                indicatorStringValue = String(Int(indicatorValue))
            } else {
                indicatorStringValue = String(Double(indicatorValue))
            }
            let size: CGSize = textSize(for: indicatorStringValue, font: indicatorsFont)
            
            let xOffset = abs(cos(baseRad)) * size.width * 0.5
            let yOffset = abs(sin(baseRad)) * size.height * 0.5
            let textPadding = CGFloat(5.0)
            let textOffset = sqrt(xOffset * xOffset + yOffset * yOffset) + textPadding
            let textCenter = CGPoint(x: cos(-baseRad) * textOffset + endPoint.x,
                                     y: sin(-baseRad) * textOffset + endPoint.y)
            let textRect = CGRect(x: textCenter.x - size.width * 0.5,
                                  y: textCenter.y - size.height * 1,
                                  width: size.width,
                                  height: size.height)
            
            let textLayer = CATextLayer()
            textLayer.contentsScale = UIScreen.main.scale
            textLayer.frame = textRect
            textLayer.string = indicatorStringValue
            textLayer.font = unitTitleFont
            textLayer.fontSize = unitTitleFont.pointSize
            textLayer.foregroundColor = indicatorsValuesColor.cgColor
            
            layer.addSublayer(textLayer)
        }
    }
    
    ///Устанавливаем внешний вид значений
    private func addTextUnitType(point: CGPoint) {
        let unitTextLayer = CATextLayer()
        unitTextLayer.font = unitTitleFont
        unitTextLayer.fontSize = unitTitleFont.pointSize
        let size = textSize(for: unitTitle, font: unitTitleFont)
        let unitStrRect = CGRect(
            x: point.x - (size.width / 2),
            y: point.y + 45,
            width: size.width,
            height: size.height
        )
        
        unitTextLayer.contentsScale = UIScreen.main.scale
        unitTextLayer.frame = unitStrRect
        unitTextLayer.string = unitTitle
        unitTextLayer.foregroundColor = indicatorsValuesColor.cgColor
        
        layer.addSublayer(unitTextLayer)
    }
}

    // MARK: - SetTextSize
extension GaugeView {
    private func textSize(for string: String?, font: UIFont) -> CGSize {
        let attribute = [NSAttributedString.Key.font: font]
        return string?.size(withAttributes: attribute) ?? .zero
    }
}
