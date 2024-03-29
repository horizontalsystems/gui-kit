Pod::Spec.new do |s|
  s.name             = 'ActionSheet.swift'
  s.module_name      = 'ActionSheet'
  s.version          = '1.2'
  s.summary          = 'Customisable replacement for UIAlertController.'

  s.homepage         = 'https://github.com/horizontalsystems/gui-kit'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Horizontal Systems' => 'hsdao@protonmail.ch' }
  s.source           = { git: 'https://github.com/horizontalsystems/gui-kit.git', tag: "action-sheet-#{s.version}" }
  s.social_media_url = 'http://horizontalsystems.io/'

  s.ios.deployment_target = '13.0'
  s.swift_version = '5'

  s.source_files = 'ActionSheet/Classes/**/*'

  s.dependency 'UIExtensions.swift', '~> 1.1.1'
  s.dependency 'SnapKit', '~> 5.0'
  s.dependency 'RxSwift', '~> 5.0'
  s.dependency 'RxCocoa', '~> 5.0'
end
