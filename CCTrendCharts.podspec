#
# Be sure to run `pod lib lint CCTrendCharts.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'CCTrendCharts'
  s.version          = '0.9.2'
  s.summary          = '趋势图表库'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  趋势图表库, 支持股票K线图, 折线图, 柱型图; 
  支持分页加载数据, 支持定制指标信息(MD等);
  支持长按指示器, 双指平滑缩放;
  另外提供了基础绘制框架, 方便用户自行添加各种风格的渲染器;

  Trend chart library, support stock K-line chart (candle chart), line chart, bar chart;
  Support pagination loading data, support custom indicator information (MD, etc.);
  Support long press indicator, smooth zoom with two fingers;
  In addition, a basic drawing framework is provided to facilitate users to add various styles of renderers by themselves;
                       DESC

  s.homepage         = 'https://github.com/cocos543/CCTrendCharts'
  s.screenshots     = 'https://raw.githubusercontent.com/cocos543/CCTrendCharts/dev/Screenshot/screenshot002.jpg', 'https://raw.githubusercontent.com/cocos543/CCTrendCharts/dev/Screenshot/screenshot006.jpg', 'https://raw.githubusercontent.com/cocos543/CCTrendCharts/dev/Screenshot/screenshot007.jpg'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Cocos543' => '543314602@qq.com' }
  s.source           = { :git => 'https://github.com/cocos543/CCTrendCharts.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'

  s.source_files = 'CCTrendCharts/CCTrendCharts/**/*'

  s.prefix_header_file = 'CCTrendCharts/CCTrendCharts/PrefixHeader.pch'
  
  # s.resource_bundles = {
  #   'CCTrendCharts' => ['CCTrendCharts/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
  s.dependency 'CCEasyKVO'
end
