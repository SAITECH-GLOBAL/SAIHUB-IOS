# Uncomment the next line to define a global platform for your project
source 'https://github.com/CocoaPods/Specs.git'
# 处理oclint
post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['COMPILER_INDEX_STORE_ENABLE'] = "NO"
        end
    end
end
platform :ios, '12.0'
inhibit_all_warnings!

def commonPod


  pod 'SafeObject'
  pod 'SDWebImage'
  pod 'AFNetworking', '~> 4.0.1'
  pod 'SDAutoLayout'
  pod 'IQKeyboardManager','~> 6.5.6'
  pod 'YYKit'
  pod 'Masonry'
  pod 'ReactiveObjC'
  pod 'SocketRocket'
  pod 'Realm', '~> 10.11.0'
  pod 'JCore', '2.1.4-noidfa'
  pod 'JPush', '3.2.4-noidfa'
  pod 'Reachability','~> 3.1.1'
  pod 'OpenSSL', :git => 'https://github.com/bither/OpenSSL.git'
  pod 'Bitheri', :git => 'https://github.com/bither/bitheri.git', :branch => 'develop'
  pod 'web3swift', :git => 'https://github.com/skywinder/web3swift.git', :branch => 'pull/libscrypt'
  pod 'CoreBitcoin','~> 0.6.8.1'
  pod 'lottie-ios' ,'~> 2.5.0'
  pod 'HWPanModal', '~> 0.8.9'
  pod 'AAChartKit', :git => 'https://github.com/AAChartModel/AAChartKit.git'
  pod 'CWLateralSlide'
  
  
end
target 'Saihub' do
  # Uncomment the next line if you're using Swift or would like to use dynamic frameworks
#   use_frameworks!
  use_modular_headers!
  commonPod
end
