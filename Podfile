
source 'https://github.com/CocoaPods/Specs.git' 

# Uncomment the next line to define a global platform for your project
 platform :ios, '10.0'

inhibit_all_warnings!

target 'QFProj' do
  # Uncomment the next line if you're using Swift or would like to use dynamic frameworks
  # use_frameworks!

  # Pods for QFProj

  pod "MJRefresh"
  #pod "YPTabBarController"
  pod "Masonry"
  pod "SDWebImage"
  pod 'AFNetworking',	'~> 3.0'
  pod 'Aspects'
  #pod 'HAccess'
  pod 'ReactiveCocoa',	'~> 2.1.8'
  pod 'FLEX'

end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '8.0'
        end
    end
end