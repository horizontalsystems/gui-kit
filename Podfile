platform :ios, '11.0'
use_frameworks!

inhibit_all_warnings!

workspace 'HSUIKit'

project 'HSUIExtensions/HSUIExtensions'
project 'HSActionSheet/HSActionSheet'
project 'HSHUD/HSHUD'
project 'HSSectionsTableView/HSSectionsTableView'

target :HSUIExtensions do
  project 'HSUIExtensions/HSUIExtensions'
end

target :HSActionSheet do
  project 'HSActionSheet/HSActionSheet'

  pod 'SnapKit', '~> 4.0'
end

target :HSHUD do
  project 'HSHUD/HSHUD'

  pod 'SnapKit', '~> 4.0'
end

target :HSSectionsTableView do
  project 'HSSectionsTableView/HSSectionsTableView'

  pod 'SnapKit', '~> 4.0'
end
