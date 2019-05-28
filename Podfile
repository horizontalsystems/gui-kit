platform :ios, '11.0'
use_frameworks!

inhibit_all_warnings!

workspace 'GuiKit'

project 'UIExtensions/UIExtensions'
project 'ActionSheet/ActionSheet'
project 'HUD/HUD'
project 'SectionsTableView/SectionsTableView'

target :UIExtensions do
  project 'UIExtensions/UIExtensions'
end

target :ActionSheet do
  project 'ActionSheet/ActionSheet'

  pod 'SnapKit', '~> 5.0'
end

target :HUD do
  project 'HUD/HUD'

  pod 'SnapKit', '~> 5.0'
end

target :SectionsTableView do
  project 'SectionsTableView/SectionsTableView'

  pod 'SnapKit', '~> 5.0'
end
