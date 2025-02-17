# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'KimTrungApp' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for KimTrungApp

  
  pod 'SwiftHEXColors'
  
  pod 'Alamofire'
  
  pod 'MBProgressHUD', '~> 1.2.0'
  
  pod 'XLPagerTabStrip', '~> 9.0'
  
  pod 'GoogleSignIn'
  
  pod 'ObjectMapper', '~> 3.5'
  
  pod 'KeychainSwift', '~> 20.0'
  
  pod 'Socket.IO-Client-Swift', '~> 15.2.0'
  
  pod 'GoogleMaps'
  pod 'GooglePlaces'
  
  pod 'MessageKit'
  pod 'MotionToastView'
  
  pod 'FirebaseAnalytics'
  pod 'FirebaseAuth'
  pod 'FirebaseFirestore'
  pod 'FirebaseDatabase'
  pod 'FirebaseStorage'
  pod 'Cosmos', '~> 25.0'
  pod 'MGStarRatingView'
  pod 'SDWebImage'
  
  pod "ESTabBarController-swift"
  
end

post_install do |installer|
    installer.generated_projects.each do |project|
        project.targets.each do |target|
            target.build_configurations.each do |config|
                config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
                config.build_settings.delete('CODE_SIGNING_ALLOWED')
                config.build_settings.delete('CODE_SIGNING_REQUIRED')
            end
        end
    end
end
