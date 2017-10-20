# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'RxZhiHuDaily' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!
  post_install do |installer|
  installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
          config.build_settings['SWIFT_VERSION'] = '3.2'
      end
  end
  en

pod 'Moya','8.0.5'
pod 'Moya/RxSwift', '8.0.5'
pod 'Kingfisher', '3.11.0'
pod 'HandyJSON',  '1.7.2'
pod 'RxSwift',    '3.0'
pod 'RxCocoa',    '3.0'
pod 'RxDataSources', '1.0'
pod 'SwiftDate', '4.1.7'
pod 'SnapKit',  '3.0.0'
pod 'SlideMenuControllerSwift', '3.0.2'
end
