Pod::Spec.new do |spec|

  spec.name             = 'ccmp-lib-ios'
  spec.version          = '1.1.0'
  spec.license          = { :type => 'Commercial', :text => 'See https://websms.com' }
  spec.homepage         = 'https://websms.com'
  spec.authors          = { 'websms.com' => 'sms2app@websms.com' }
  spec.summary          = 'Generic CCMP library which handles websms SMS2App notifications, data storage and api calls'
  spec.source           = { :git => 'https://github.com/websms-com/ccmp-lib-ios.git', :tag => spec.version.to_s }
  
  spec.platform    		= :ios, '5.0'
  spec.requires_arc     = true
  
  spec.source_files     	= 'CCMP'
  spec.resource 			= 'CCMP/CCMPDatabaseModel.xcdatamodeld'
  spec.prefix_header_file	= 'CCMP/CCMP-Prefix.pch'
  spec.framework       		= 'SystemConfiguration'
  
  spec.dependency 'AFNetworking', '1.3.3'
  spec.dependency 'Reachability'
  spec.dependency 'MagicalRecord'
  spec.dependency 'UIDevice+HardwareModel', '~> 1.2'
  
end