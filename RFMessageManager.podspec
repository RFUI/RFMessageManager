Pod::Spec.new do |s|
  s.name             = 'RFMessageManager'
  s.version          = '0.6.0'
  s.summary          = 'An Abstract Message Manager.'

  s.homepage         = 'https://github.com/RFUI/RFMessageManager'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'BB9z' => 'bb9z@me.com' }
  s.source           = {
    :git => 'https://github.com/RFUI/RFMessageManager.git',
    :branch => 'develop'
  }

  s.requires_arc = true
  s.osx.deployment_target = '10.8'
  s.ios.deployment_target = '8.0'
  s.tvos.deployment_target = '9.0'
  s.default_subspec = 'Manager'

  s.subspec 'Manager' do |ss|
    ss.dependency 'RFInitializing', '>= 1.1'
    ss.dependency 'RFKit/Runtime', '>= 1.7'
    ss.dependency 'RFKit/Category/NSArray'
    ss.source_files = [
      'Sources/RFMessageManager/RFMessageManager.{h,m}',
      'Sources/RFMessageManager/RFMessage.{h,m}',
    ]
    ss.public_header_files = [
      'Sources/RFMessageManager/RFMessageManager.h',
      'Sources/RFMessageManager/RFMessage.h',
    ]
  end

  s.subspec 'RFNetworkActivityMessage' do |ss|
    ss.dependency 'RFMessageManager/Manager'
    ss.source_files = [
      'Sources/RFMessageManager/RFNetworkActivityMessage.{h,m}',
      'Sources/RFMessageManager/RFMessageManager+RFDisplay.{h,m}'
    ]
    ss.public_header_files = [
      'Sources/RFMessageManager/RFNetworkActivityMessage.h',
      'Sources/RFMessageManager/RFMessageManager+RFDisplay.h'
    ]
  end

  s.subspec 'SVProgressHUD' do |ss|
    ss.ios.deployment_target = '8.0'
    ss.tvos.deployment_target = '9.0'
    ss.dependency 'RFMessageManager/Manager'
    ss.dependency 'RFMessageManager/RFNetworkActivityMessage'
    ss.dependency 'SVProgressHUD'
    ss.source_files = 'Sources/RFSVProgressMessageManager/*.{h,m}'
    ss.public_header_files = ['Sources/RFSVProgressMessageManager/*.h']
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
      '-Wno-double-promotion',
      '-Wno-objc-missing-property-synthesis'
    ].join(' ')
  }
end
