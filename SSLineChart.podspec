#
# Be sure to run `pod lib lint SSLineChart.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SSLineChart'
  s.version          = '1.0.0'
  s.summary          = 'Gradient Chart framework for watchOS'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  'Gradient Chart framework for watchOS'
   'SSLineChart draws a `UIImage` of a chart with given values and provide additional functionality of gradient color fill'
   DESC

  s.homepage         = 'https://github.com/mobile-simformsolutions/SSLineChart'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { "HitarthBhatt12" => "hitarth.b@simformsolutions.com" }
  s.source           = { :git => 'https://github.com/mobile-simformsolutions/SSLineChart', :tag => s.version.to_s }

  s.ios.deployment_target = '13.0'
  s.watchos.deployment_target = '8.0'

  s.source_files = 'Charts/**/*.swift'

end
