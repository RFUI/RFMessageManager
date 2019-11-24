Pod::Spec.new do |s|
  s.name             = 'RFMessageManager'
  s.version          = '0.5.0'
  s.summary          = 'An Abstract Message Manager.'

  s.homepage         = 'https://github.com/RFUI/RFMessageManager'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'BB9z' => 'bb9z@me.com' }
  s.source           = { :git => 'https://github.com/RFUI/RFMessageManager.git', :tag => s.version.to_s }

  s.requires_arc = true
  s.osx.deployment_target = '10.8'
  s.ios.deployment_target = '8.0'
  s.tvos.deployment_target = '9.0'
  s.default_subspec = 'Manager'

  s.subspec 'Manager' do |ss|
    ss.dependency 'RFInitializing', '>= 1.1'
    ss.dependency 'RFKit/Runtime', '>= 1.7'
    ss.dependency 'RFKit/Category/NSArray'
    ss.source_files = ['RFMessageManager.{h,m}']
    ss.public_header_files = ['RFMessageManager.h']
  end

  s.subspec 'RFNetworkActivityMessage' do |ss|
    ss.dependency 'RFMessageManager/Manager'
    ss.source_files = ['RFNetworkActivityMessage.{h,m}', 'RFMessageManager+RFDisplay.{h,m}']
    ss.public_header_files = ['RFNetworkActivityMessage.h', 'RFMessageManager+RFDisplay.h']
  end

  s.subspec 'SVProgressHUD' do |ss|
    ss.ios.deployment_target = '8.0'
    ss.tvos.deployment_target = '9.0'
    ss.dependency 'RFMessageManager/Manager'
    ss.dependency 'RFMessageManager/RFNetworkActivityMessage'
    ss.dependency 'SVProgressHUD'
    ss.source_files = 'Implementation/RFSVProgressMessageManager.{h,m}'
    ss.public_header_files = ['Implementation/RFSVProgressMessageManager.h']
  end

  s.pod_target_xcconfig = {
  }
end
