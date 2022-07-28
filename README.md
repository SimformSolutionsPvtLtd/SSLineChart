<a href="https://www.simform.com/"><img src="https://github.com/SimformSolutionsPvtLtd/SSToastMessage/blob/master/simformBanner.png"></a>

SSLineChart
=============
[![CocoaPods Version](https://img.shields.io/cocoapods/v/SSLineChart)](https://cocoapods.org/pods/SSLineChart)
[![Platform](https://img.shields.io/cocoapods/p/SSLineChart)](https://cocoapods.org/pods/SSLineChart)
[![License](https://img.shields.io/github/license/SimformSolutionsPvtLtd/SSLineChart)](https://cocoapods.org/pods/SSLineChart)
[![Swift Version][swift-image]][swift-url]
[![PRs Welcome][PR-image]][PR-url]
[![Twitter](https://img.shields.io/badge/Twitter-@simform-blue.svg?style=flat)](https://twitter.com/simform)

SSLineChart draws a `UIImage` of a chart with given values and provide additional functionality of gradient color fill.

Setup Instructions
------------------
[CocoaPods](http://cocoapods.org)
------------------
To integrate SSLineChart into your Xcode project using CocoaPods, specify it in your `Podfile`:
```ruby
pod 'SSLineChart', '~> 1.0.0'
```
and in your code add `import SSLineChart`.

[Swift Package Manager](https://swift.org/package-manager/)
------------------
When using Xcode 11 or later, you can install `SSLineChart` by going to your Project settings > `Swift Packages` and add the repository by providing the GitHub URL. Alternatively, you can go to `File` > `Swift Packages` > `Add Package Dependencies...`

## Manually

1. Add `SSLineChart.swift` and `SSLineChartData.swift` to your project.
2. Grab yourself a cold 🍺.

## Requirements
* Xcode 11+

# Usage

Initial Setup
---------
```swift
  let lineChart = SSLineChart()
  lineChart.chartMargin = 14
  lineChart.yLabelFormat = "%1.0f"
  lineChart.xLabels = (1...5).map{ $0.description }
  lineChart.yFixedValueMax = 100
  lineChart.yFixedValueMin = 20
  lineChart.yLabels = ["20", "60", "100"]
  lineChart.xLabelWidth = 15.0
  lineChart.yLabelHeight = 0
  lineChart.yLabelColor =  UIColor.white
  lineChart.xLabelColor =  UIColor.white
        
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

  lineChart.chartData = [data]
  let chartImage = lineChart.drawImage()
```

Apply gradient
---------
```swift
  lineChart.setGradientColor(colors: [.red, .orange], position: .topDown)
```
Chart Examples
----------------
<p align="center">
<img src="gradientGraph.png" width="400"  title="Gradient">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<img src="lineGraph.png" width="400"  title="Line">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
</p>

# Check out our other Libraries

<h3><a href="https://github.com/SimformSolutionsPvtLtd/Awesome-Mobile-Libraries"><u>🗂 Simform Solutions Libraries→</u></a></h3>


## MIT License

Copyright (c) 2022 Simform Solutions

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

[PR-image]:https://img.shields.io/badge/PRs-welcome-brightgreen.svg?style=flat
[PR-url]:http://makeapullrequest.com
[swift-image]:https://img.shields.io/badge/swift-5.0-orange.svg
[swift-url]: https://swift.org/
