abstract_target 'common' do
  
  use_frameworks!
  inhibit_all_warnings!
  
  pod 'Redux-ReactiveSwift',
    :git => 'git@github.com:xxKRASHxx/Redux-ReactiveSwift.git',
    :branch => 'master'
  pod 'ReactiveCocoa', '~> 10.0'
  pod 'ReactiveSwift', '~> 6.0'
  pod 'Result'
  pod 'Overture', '~> 0.5'
  
  pod 'CocoaMQTT', '~> 1.1'
  pod 'Moya',
    :git => 'git@github.com:Moya/Moya.git',
    :tag => '14.0.0-beta.2'
  pod 'Moya/ReactiveSwift',
    :git => 'git@github.com:Moya/Moya.git',
    :tag => '14.0.0-beta.2'
  pod 'Kingfisher', '~> 5.8'
  
  pod 'Swinject'
  pod 'SwinjectAutoregistration'
  
  pod 'Sourcery', '~> 0.17'
  
  target 'WeatherApp' do
    platform :ios, '13.0'
    
    pod 'Hero'
    pod 'CollectionKit'
    pod 'TableKit', '~> 2.8'
    pod 'SnapKit', '~> 4.0.0'
  end
  
  target 'WeatherAppSwiftUI' do
    platform :ios, '13.0'
  end
  
  target 'WeatherAppCore' do
    pod 'Alamofire'
  end
  
  target 'WeatherAppShared' do
  end
end
