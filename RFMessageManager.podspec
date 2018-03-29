Pod::Spec.new do |s|
  s.name             = 'RFMessageManager'
  s.version          = '0.2.0'
  s.summary          = 'An Abstract Message Manager.'

  s.homepage         = 'https://github.com/RFUI/RFMessageManager'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'BB9z' => 'bb9z@me.com' }
  s.source           = { :git => 'https://github.com/RFUI/RFMessageManager.git', :tag => s.version.to_s }

  s.osx.deployment_target = '10.8'
  s.ios.deployment_target = '6.0'
  s.tvos.deployment_target = '9.0'

  s.requires_arc = true
  s.source_files = ['RFMessageManager.{h,m}']
  s.public_header_files = ['RFMessageManager.h']

  s.dependency 'RFKit/Runtime'
  s.dependency 'RFKit/Category/NSArray'
  s.dependency 'RFInitializing'

  s.subspec 'RFNetworkActivityIndicatorMessage' do |ss|
    ss.source_files = ['RFNetworkActivityIndicatorMessage.{h,m}', 'RFMessageManager+RFDisplay.{h,m}']
  end

  s.subspec 'SVProgressHUD' do |ss|
    ss.ios.deployment_target = '6.0'
    ss.tvos.deployment_target = '9.0'
    ss.dependency 'RFMessageManager/RFNetworkActivityIndicatorMessage'
    ss.dependency 'SVProgressHUD'
    ss.source_files = 'Implementation/RFSVProgressMessageManager.{h,m}'
  end

  s.subspec 'UIAlertView' do |ss|
    ss.ios.deployment_target = '6.0'
    ss.dependency 'RFMessageManager/RFNetworkActivityIndicatorMessage'
    ss.source_files = 'Implementation/RFAlertViewMessageManager.{h,m}'
  end

  s.pod_target_xcconfig = {
    # These config should only exsists in develop branch.
    'WARNING_CFLAGS'=> [
      '-Weverything',                   # Enable all possiable as we are developing a library.
      '-Wno-gnu-statement-expression',  # Allow ?: expression.
      '-Wno-gnu-conditional-omitted-operand',
      '-Wno-auto-import',               # Still needs old #import for backward compatibility. 
      '-Wno-sign-conversion',
      '-Wno-sign-compare',
      '-Wno-objc-missing-property-synthesis'
    ].join(' ')
  }
end
