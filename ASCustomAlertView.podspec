Pod::Spec.new do |s|
  s.name                        = "ASCustomAlertView"
  s.version                     = '1.0.3.2'
  s.summary                     = "This is custom alert notification accepts buttons array with own handlers"
  s.homepage                    = 'http://softermii.com'
  s.social_media_url            = 'http://twitter.com/anton__dev'
  s.documentation_url           = 'http://softermii.com'
  s.author                      = { 'Anton Stremovskiy'   => 'perlik@gmail.com',
                                    'Max Rachytskyy'     => 'maksym.rachytskyy@softermii.com' }
  s.license                     = { :type => "MIT", :file => "LICENSE" }
  s.source                      = { git: "https://github.com/softermii/ASCustomAlertView.git", tag: "v#{s.version}" }
  s.platform                    = :ios, '9.0'
  s.requires_arc                = true
  s.resources			= 'Source/**/*.{xib,xcassets}'
  s.ios.resource_bundle 	= { 'Resources' => ['Source/**/*.xib'] }  
  s.source_files                = 'Source/*.{swift, xib}', '*.xib'
  s.ios.frameworks              = %w{ UIKit }
  s.ios.deployment_target       = '9.0'
  s.dependency 'Cosmos'
end
