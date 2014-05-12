Pod::Spec.new do |spec|

  spec.name             = 'CCMP'
  spec.version          = '1.1'
  spec.license          = { :type => 'Commercial', :text => 'See http://www.websms.at' }
  spec.homepage         = 'http://www.websms.at'
  spec.authors          = { 'Christoph Lückler' => 'christoph.lueckler@ut11.net' }
  spec.summary          = 'Generic CCMP library which handles notifications, data storage and api calls'
  spec.source           = { :git => 'http://git.sms.co.at/repo/app-library-ios.git', :tag => spec.version.to_s }
  
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