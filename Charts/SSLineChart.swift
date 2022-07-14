//
//  SSLineChart.swift
//
//  Created by Hitarth on 17/02/22.
//  Copyright © 2022 Simform. All rights reserved.
//

#if os(iOS)
import UIKit
#else
import WatchKit
#endif

import CoreGraphics

public class SSLineChart: NSObject {
    
    private var frame = CGRect.zero
    private var chartPath: [UIBezierPath]?
    private var pointPath: [UIBezierPath]?
    private var endPointsOfPath: [CGPoint]?
    private var pathPoints: [CGPoint]?
    private var chartCavanHeight: CGFloat = 0.0
    private var chartCavanWidth: CGFloat = 0.0
    private var newPositionY: CGFloat = 0
    private var lastPostionY: CGFloat = 0
    private var yValueMax: CGFloat = 0.0
    private var yValueMin: CGFloat = 0.0
    private var yLabelNum = 0
    private var yLabelBlockFormatter: ((CGFloat) -> String)?
    
    // Gradient Color Variables
    private var startPoint: CGPoint = CGPoint()
    private var endPoint: CGPoint = CGPoint()
    private var gradientColor: CFArray = [] as CFArray

    // MARK: - Public accesible variales.
    
    /// Set whole chart background color.
    public var chartBackgroundColor: UIColor?
    /// Set chart data and its properties.
    public var chartData: [SSLineChartData]?
    /// Set margin from x and y axis, Default is 15.
    public var chartMargin: CGFloat = 0.0
    /// Set x-axis labels.
    public var xLabels: [String]?
    /// Set y-axis labels.
    public var yLabels: [String]?
    /// Set width of x-axis labels (Space required by axis labels).
    public var xLabelWidth: CGFloat = 0.0
    /// Set x-axis labels font.
    public var xLabelFont: UIFont?
    /// Set x-axis labels color.
    public var xLabelColor: UIColor?
    /// Add additional spacing to bottom and top of the charts for line.
    public var yPadding: CGFloat = 0.0
    /// Set y-axis labels Font.
    public var yLabelFont: UIFont?
    /// Set y-axis labels color.
    public var yLabelColor: UIColor?
    /// Set width of x-axis labels (Space required by axis labels).
    public var yLabelHeight: CGFloat = 0.0
    /// Set maximum range of y-axis data points to draw line.
    public var yFixedValueMax: CGFloat = 0.0
    /// Set minimum range of y-axis data points to draw line.
    public var yFixedValueMin: CGFloat = 0.0
    /// Set string formate of y-axis labels.
    public var yLabelFormat: String = "%1f"
    /// Show y-axis labels (Default true).
    public var showYLabels: Bool = true
    /// Show x-axis labels (Default true).
    public var showXLabels: Bool = true
    
    public init(x: CGFloat = 0, y: CGFloat = 0, width: CGFloat = 300, height: CGFloat = 100) {
        super.init()
        self.frame = CGRect(x: x, y: y, width: width, height: height)
        setupDefaultValues()
    }

    private func setupDefaultValues() {
        // Initialization code
        pathPoints = []
        endPointsOfPath = []

        yFixedValueMin = -Double.greatestFiniteMagnitude
        yFixedValueMax = -Double.greatestFiniteMagnitude
        yLabelNum = Int(5.0)
        yLabelHeight = 8

        chartMargin = 15
        chartCavanWidth = frame.size.width - chartMargin * 2
        chartCavanHeight = frame.size.height - chartMargin * 2
    }

    // MARK: - Set Gradient Color.
    /// Used to fill gradient color to the path area.
    /// - Parameters:
    ///   - colors: Requies array of colors.
    ///   - position: Set direction of gredient color for start and end point.
    public func setGradientColor(colors: [UIColor], position: GradientPosition = .topDown) {
        (self.startPoint, self.endPoint) = position.getPosition(frame: frame)
        
        guard let cgColors = (colors.cgColors() as CFArray?) else { return }
        self.gradientColor = cgColors
    }
    
    // MARK: - Draw Graph Image.
    
    /// Used to draw chart image for provided data.
    /// - Returns: `UIImage` of chart.
    public func drawImage() -> UIImage? {
        var scale: CGFloat = 0.0
        #if os(iOS)
        scale = UIScreen.main.scale
        #else
        scale = WKInterfaceDevice.current().screenScale
        #endif

        UIGraphicsBeginImageContextWithOptions(frame.size, false, scale)
        if (chartBackgroundColor != nil) {
            let chartRect = UIBezierPath(rect: frame)
            chartBackgroundColor?.setFill()
            chartRect.fill()
        }
        drawYLabels()
        drawXLabels()
        drawLines()

        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }

    // MARK: - Line Drawing Method.
    private func drawLines() {
        chartPath = []
        pointPath = []

        calculateChartPath(&chartPath!, andPointsPath: &pointPath!, andPathKeyPoints: &pathPoints!, andPathStartEndPoints: &endPointsOfPath!)

        for lineIndex in 0..<(self.chartData?.count ?? 0) {
            let chartData = self.chartData?[lineIndex]

            let chartLinePath = chartPath?[lineIndex]
            let pointPath = self.pointPath?[lineIndex]

            if ((chartData?.lineColor) != nil) {
                chartData?.lineColor?.withAlphaComponent(chartData?.lineAlpha ?? 0.0).setStroke()
            } else {
                UIColor.green.setStroke()
            }
            chartLinePath?.lineWidth = CGFloat(chartData?.lineWidth ?? 0.6)
            chartLinePath?.stroke()
            pointPath?.stroke()
        }
    }
   
    // MARK: - Calculate chart path method.
    private func calculateChartPath(_ chartPath: inout [UIBezierPath], andPointsPath pointsPath: inout [UIBezierPath], andPathKeyPoints pathPoints: inout [CGPoint], andPathStartEndPoints pointsOfPath: inout [CGPoint]) {

        for lineIndex in 0..<(self.chartData?.count ?? 0) {
            let chartData = self.chartData?[lineIndex]
            var yValue: CGFloat = 0.0
            var innerGrade: CGFloat = 0.0

            let progressline = UIBezierPath()
            let pointPath = UIBezierPath()
            let fillGradientFive = UIBezierPath()

            if newPositionY != 0 && newPositionY > lastPostionY {
                lastPostionY = newPositionY
                fillGradientFive.move(to: CGPoint(x: frame.size.width, y: lastPostionY + 14))
            }

            chartPath.insert(progressline, at: lineIndex)
            pointsPath.insert(pointPath, at: lineIndex)

            if !showXLabels && !showYLabels {
                chartCavanHeight = frame.size.height - 2 * yLabelHeight
                chartCavanWidth = frame.size.width
                xLabelWidth = (chartCavanWidth / CGFloat((xLabels?.count ?? 0) - 1))
            }
            
            var linePointsArray: [CGPoint] = []
            var lineStartEndPointsArray: [CGPoint] = []
            var lastX = 0
            var lastY = 0
            var lastYValue = 0
            let midYValue = Int(yFixedValueMax + yFixedValueMin) / 2
            let midMaxValue = (midYValue + Int(yFixedValueMax)) / 2
            let midMinValue = (midYValue + Int(yFixedValueMin)) / 2

            for i in 0..<(chartData?.itemCount ?? 0) {
                yValue = chartData?.getData?(i) ?? 0
                
                if i != 0 || i != ((chartData?.itemCount ?? 0) - 1) {
                    if yValue > CGFloat(lastYValue) {
                        if yValue > CGFloat(midYValue) {
                            if yValue >= CGFloat(midMaxValue) {

                                //yValue = yValue
                            } else {
                                yValue = yValue + yPadding
                            }
                        } else {
                            yValue = yValue + yPadding
                        }
                    } else {
                        if yValue < CGFloat(midYValue) {
                            if yValue <= CGFloat(midMinValue) {

                                //yValue = yValue
                            } else {
                                yValue = yValue - yPadding
                            }
                        } else {
                            yValue = yValue - yPadding
                        }
                    }
                }
                lastYValue = Int(yValue)
                if (yValueMax - yValueMin) == 0 {
                    innerGrade = 0.5
                } else {
                    innerGrade = (yValue - yValueMin) / (yValueMax - yValueMin)
                }

                let offSetX = chartCavanWidth / CGFloat(chartData?.itemCount ?? 0)

                var x = Int(2 * chartMargin + (CGFloat(i) * offSetX))
                
                if i == (chartData?.itemCount ?? 0) - 1 {
                    x = Int(frame.size.width)
                }
                
                let y = Int(chartCavanHeight - (innerGrade * chartCavanHeight) + (yLabelHeight / 2))

                if i != 0 {
                    let deltaX: CGFloat = CGFloat(x - lastX)
                    let controlPointX = lastX + (Int(deltaX) / 2)
                    let controlPoint1 = CGPoint(x: controlPointX, y: lastY)
                    let controlPoint2 = CGPoint(x: controlPointX, y: y)

                    progressline.addCurve(to: CGPoint(x: x , y: y), controlPoint1: controlPoint1, controlPoint2: controlPoint2)
                    lineStartEndPointsArray.append(CGPoint(x: x , y: y))
                }

                progressline.move(to: CGPoint(x: x , y: y))
                newPositionY = CGFloat(y )

                if i == 0 {
                    if lastPostionY < CGFloat(y) {
                        lastPostionY = CGFloat(y)
                    }
                    fillGradientFive.move(to: CGPoint(x: frame.size.width, y: frame.height - (chartMargin * 1.2)))
                    fillGradientFive.addLine(to: CGPoint(x: x, y: Int(frame.height - (chartMargin * 1.2))))
                }

                if i != 0 {
                    let deltaX: CGFloat = CGFloat(x - lastX)
                    let controlPointX = lastX + (Int(deltaX) / 2)
                    let controlPoint1 = CGPoint(x: controlPointX, y: lastY)
                    let controlPoint2 = CGPoint(x: controlPointX, y: y)

                    fillGradientFive.addCurve(to: CGPoint(x: x, y: y), controlPoint1: controlPoint1, controlPoint2: controlPoint2)
                }

                lastX = x
                lastY = y

                fillGradientFive.addLine(to: CGPoint(x: x, y: y))

                if i != (chartData?.itemCount ?? 0) - 1 {
                    lineStartEndPointsArray.append(CGPoint(x: x, y: y))
                }

                linePointsArray.append(CGPoint(x: x, y: y))

            } // For Loop

            let context = UIGraphicsGetCurrentContext()
            context?.saveGState()
            let colorSpace = CGColorSpaceCreateDeviceRGB()
            let gradient: CGGradient? = CGGradient(colorsSpace: colorSpace, colors: gradientColor, locations: nil)
            fillGradientFive.addClip()
            if let gradient = gradient {
                context?.drawLinearGradient(gradient, start: startPoint, end: endPoint, options: [])
            }
            context?.restoreGState()

            pathPoints.append(contentsOf: linePointsArray)
            pointsOfPath.append(contentsOf: lineStartEndPointsArray)

        }
    }
    
    // MARK: - Label drawing methods.
    private func drawXLabels() {
        if showXLabels {
            xLabelWidth = (chartCavanWidth / Double(xLabels?.count ?? 0))
        } else {
            xLabelWidth = ((frame.size.width) / Double(xLabels?.count ?? 0))
        }

        xLabelWidth = xLabelWidth + (xLabelWidth / Double(xLabels?.count ?? 0))

        var attributesDictionary: [NSAttributedString.Key : Any] = [:]
        xLabelFont = UIFont.systemFont(ofSize: chartMargin/1.5)
        attributesDictionary[.font] = xLabelFont
        if (xLabelColor != nil) {
            attributesDictionary[.foregroundColor] = xLabelColor
        }

        let priceParagraphStyle = NSMutableParagraphStyle()
        priceParagraphStyle.lineBreakMode = .byTruncatingTail
        priceParagraphStyle.alignment = .center
        attributesDictionary[.paragraphStyle] = priceParagraphStyle

        var labelText: String?
        if showXLabels {
            for index in 0..<(xLabels?.count ?? 0) {
                labelText = xLabels?[index]

                let x = 2 * chartMargin + (CGFloat(index) * xLabelWidth) - (xLabelWidth / 2)
                let y = chartMargin + chartCavanHeight

                let labelRect = CGRect(x: x, y: y, width: xLabelWidth, height: chartMargin)
                labelText?.draw(in: labelRect, withAttributes: attributesDictionary)
            }
        }
    }

    private func drawYLabels() {
        prepareYLabels(withData: chartData)
        yLabelNum = (yLabels?.count ?? 0) - 1

        if showYLabels {
            yLabelHeight = (chartCavanHeight / CGFloat(yLabels?.count ?? 0))
        } else {
            yLabelHeight = ((frame.size.height) / CGFloat(yLabels?.count ?? 0))
        }

        let yStep: CGFloat = (yValueMax - yValueMin) / CGFloat(yLabelNum)
        let yStepHeight: CGFloat = chartCavanHeight / CGFloat(yLabelNum)

        var attributesDictionary: [NSAttributedString.Key : Any] = [:]
        yLabelFont = UIFont.systemFont(ofSize: chartMargin/1.5)
        attributesDictionary[.font] = yLabelFont
        attributesDictionary[.foregroundColor] = yLabelColor

        let priceParagraphStyle = NSParagraphStyle.default as? NSMutableParagraphStyle
        priceParagraphStyle?.lineBreakMode = .byTruncatingTail
        priceParagraphStyle?.alignment = .center
        attributesDictionary[.paragraphStyle] = priceParagraphStyle
        
        if showYLabels {
            if yStep == 0.0 {
                let minLabelRect = CGRect(x: 0.0, y: CGFloat(Int(chartCavanHeight)), width: CGFloat(Int(chartMargin)), height: CGFloat(Int(yLabelHeight)))
                let minLabelText = formatYLabel(0.0)
                minLabelText?.draw(in: minLabelRect, withAttributes: attributesDictionary)
                
                let midLabelRect = CGRect(x: 0.0, y: CGFloat(Int(chartCavanHeight / 2)), width: CGFloat(Int(chartMargin)), height: CGFloat(Int(yLabelHeight)))
                let midLabelText = formatYLabel(yValueMax)
                midLabelText?.draw(in: midLabelRect, withAttributes: attributesDictionary)
                
                let maxLabelRect = CGRect(x: 0.0, y: 0.0, width: CGFloat(Int(chartMargin)), height: CGFloat(Int(yLabelHeight)))
                let maxLabelText = formatYLabel(yValueMax * 2)
                maxLabelText?.draw(in: maxLabelRect, withAttributes: attributesDictionary)
                
            } else {
                var index = 0
                var num = yLabelNum + 1
                
                while num > 0 {
                    let labelRect = CGRect(x: 0.0, y: (chartCavanHeight - CGFloat(index) * yStepHeight) + (yLabelHeight / 4), width: chartMargin * 2, height: yLabelHeight)
                    let text = yLabels?[index]
                    text?.draw(in: labelRect, withAttributes: attributesDictionary)
                    index += 1
                    num -= 1
                }
            }
        }
    }
    
    private func prepareYLabels(withData data: [SSLineChartData]?) {
        var yMax: CGFloat = 0.0
        var yMin = MAXFLOAT
        var yLabelsArray: [AnyHashable] = []

        for chartData in data ?? [] {
            // create as many chart line layers as there are data-lines
            for i in 0..<(chartData.itemCount ?? 0) {
                let yValue = chartData.getData?(i) ?? 0
                yLabelsArray.append(String(format: "%2f", yValue))
                yMax = max(yMax, yValue)
                yMin = min(yMin, Float(yValue))
            }
        }

        if yMax < 5 {
            yMax = 5.0
        }

        if yMin < 0 {
            yMin = 0.0
        }

        yValueMin = CGFloat((yFixedValueMin > -Double.greatestFiniteMagnitude) ? Float(yFixedValueMin) : yMin)
        yValueMax = (yFixedValueMax > -Double.greatestFiniteMagnitude) ? yFixedValueMax : (yMax + yMax / 10.0)
    }

    private func drawText(in ctx: CGContext?, text: String?, in rect: CGRect, font: UIFont?) {
        let priceParagraphStyle = NSParagraphStyle.default as? NSMutableParagraphStyle
        priceParagraphStyle?.lineBreakMode = .byTruncatingTail
        priceParagraphStyle?.alignment = .left

        if let priceParagraphStyle = priceParagraphStyle, let font = font {
            text?.draw(
                in: rect,
                withAttributes: [
                    NSAttributedString.Key.paragraphStyle: priceParagraphStyle,
                    NSAttributedString.Key.font: font,
                    NSAttributedString.Key.foregroundColor: UIColor.white
                ])
        }
    }

    private func formatYLabel(_ value: Double) -> String? {
        let format = yLabelFormat
        return String(format: format, value)
    }
    
    private func sizeOf(_ text: String?, withWidth width: Float, font: UIFont?) -> CGSize {
        var size = CGSize(width: CGFloat(width), height: CGFloat(MAXFLOAT))

        var tdic: [AnyHashable : Any]? = nil
        if let font = font {
            tdic = [NSAttributedString.Key.font : font]
        }
        size = text?.boundingRect(
            with: size,
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            attributes: tdic as? [NSAttributedString.Key : Any],
            context: nil).size ?? CGSize.zero

        return size
    }
}

// MARK: - Gradient fill position enum.
public enum GradientPosition {
    case topDown, bottomUp, leftToRight, rightToLeft
    
    func getPosition(frame: CGRect) -> (CGPoint, CGPoint) {
        let top = CGPoint(x: frame.midX, y: frame.minY)
        let bottom = CGPoint(x: frame.midX, y: frame.maxY)
        let leading = CGPoint(x: frame.minX, y: frame.midY)
        let trailing = CGPoint(x: frame.maxX, y: frame.midY)
        switch self {
            case .topDown:
                return (top, bottom)
            case .bottomUp:
                return (bottom, top)
            case .leftToRight:
                return (leading, trailing)
            case .rightToLeft:
                return (trailing, leading)
        }
    }
}

// MARK: - Array extension.
extension Array where Iterator.Element == UIColor {
    func cgColors() -> [CGColor] {
        var cgColorArray: [CGColor] = []

        for color in self {
            cgColorArray.append(color.cgColor)
        }

        return cgColorArray
    }
}
