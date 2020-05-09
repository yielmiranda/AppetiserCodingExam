# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

post_install do |installer|
    installer.pods_project.targets.each do |target|
        if target.name == 'RxSwift'
            target.build_configurations.each do |config|
                if config.name == 'Debug'
                    config.build_settings['OTHER_SWIFT_FLAGS'] ||= ['-D', 'TRACE_RESOURCES']
                end
            end
        end
    end
end

target 'AppetiserCodingExam' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for AppetiserCodingExam
    
  pod 'Alamofire', '~> 4.7'
  pod 'AlamofireImage', '~> 3.4'
  pod 'SwiftyJSON'
  pod 'RxSwift'
  pod 'RxCocoa'
  pod 'JPush'

end
