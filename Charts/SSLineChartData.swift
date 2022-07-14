//
//  SSLineChartData.swift
//
//  Created by Hitarth on 09/03/22.
//  Copyright © 2022 Simform. All rights reserved.
//

#if os(iOS)
import UIKit
#else
import WatchKit
#endif

public class SSLineChartData {
    public init() {}
    
    /// Set color of the line.
    public var lineColor: UIColor?
    /// Requires total data points.
    public var itemCount: Int?
    /// Set alpha value of line from 0 to 1.
    public var lineAlpha: Double?
    /// Set width of the line.
    public var lineWidth: Double?
    /// Set data to chart by index.
    public var getData: ((Int) -> CGFloat)?
}
