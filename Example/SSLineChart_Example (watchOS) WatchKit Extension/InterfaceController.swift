//
//  InterfaceController.swift
//  SSLineChart_Example (watchOS) WatchKit Extension
//
//  Created by Hitarth on 21/06/22.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import WatchKit
import SSLineChart

class InterfaceController: WKInterfaceController {

    @IBOutlet weak var graphImage: WKInterfaceImage!
    var lineChart: SSLineChart?
    
    override func awake(withContext context: Any?) {
        // Configure interface objects here.
        generateGraphImage()
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
    }
    
    func generateGraphImage() {
        lineChart = SSLineChart()
        lineChart?.chartMargin = 14
        lineChart?.yLabelFormat = "%1.0f"
        lineChart?.xLabels = (1...5).map{ $0.description }
        lineChart?.yFixedValueMax = 100
        lineChart?.yFixedValueMin = 20
        lineChart?.yLabels = ["20", "60", "100"]
        lineChart?.xLabelWidth = 15.0
        lineChart?.yLabelHeight = 0
        lineChart?.yLabelColor =  UIColor.white
        lineChart?.xLabelColor =  UIColor.white

        lineChart?.setGradientColor(colors: [.red, .orange], position: .topDown)
        
        let activityData = [45, 65, 30, 85, 40, 70, 83, 50]
        
        let data = SSLineChartData()
        data.lineColor = .white
        data.lineAlpha = 1
        data.lineWidth = 0.6
        data.itemCount = activityData.count
        data.getData = { index in
            let yValue = activityData[index]
            return CGFloat(yValue)
        }

        lineChart?.chartData = [data]
        let img = lineChart?.drawImage()
        graphImage.setImage(img)
    }

}
