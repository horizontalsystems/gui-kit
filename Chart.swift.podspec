Pod::Spec.new do |s|
  s.name             = 'Chart.swift'
  s.module_name      = 'Chart'
  s.version          = '1.2'
  s.summary          = 'Chart'

  s.homepage         = 'https://github.com/horizontalsystems/gui-kit'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Horizontal Systems' => 'hsdao@protonmail.ch' }
  s.source           = { git: 'https://github.com/horizontalsystems/gui-kit.git', tag: "chart_#{s.version}" }
  s.social_media_url = 'http://horizontalsystems.io/'

  s.ios.deployment_target = '11.0'
  s.swift_version = '5'

  s.source_files = 'Chart/Classes/**/*'

  s.dependency 'SnapKit', '~> 5.0'
  s.dependency 'UIExtensions.swift', '~> 1.1'
end
