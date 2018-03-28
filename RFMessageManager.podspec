Pod::Spec.new do |s|
  s.name             = 'RFMessageManager'
  s.version          = '0.1.0'
  s.summary          = 'An Abstract Message Manager.'

  s.homepage         = 'https://github.com/RFUI/RFMessageManager'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'BB9z' => 'bb9z@me.com' }
  s.source           = { :git => 'https://github.com/RFUI/RFMessageManager.git', :tag => s.version.to_s }

  s.ios.deployment_target = '6.0'
  s.tvos.deployment_target = '9.0'

  s.requires_arc = true
  s.source_files = ['*.{h,m}']
  s.public_header_files = ['*.h']
  s.frameworks = 'UIKit'

  s.dependency 'RFKit/Runtime'
  s.dependency 'RFInitializing'

  s.subspec 'SVProgressHUD' do |ss|
    ss.dependency 'SVProgressHUD'
    ss.source_files = 'Implementation/RFSVProgressMessageManager.{h,m}'
  end

    s.subspec 'UIAlertView' do |ss|
    ss.source_files = 'Implementation/RFAlertViewMessageManager.{h,m}'
  end
end
