Pod::Spec.new do |s|
    s.name                  = 'Tablet'
    s.version               = '0.3.0'

    s.homepage              = 'https://github.com/maxsokolov/tablet'
    s.summary               = 'Powerful type-safe tool for UITableView. Swift 2.0 is required.'

    s.author                = { 'Max Sokolov' => 'i@maxsokolov.net' }
    s.license               = { :type => 'MIT', :file => 'LICENSE' }
    s.platforms             = { :ios => '8.0' }
    s.ios.deployment_target = '8.0'

    s.source_files          = 'Tablet/*.swift'
    s.module_name           = 'Tablet'
    s.source                = { :git => 'https://github.com/maxsokolov/tablet.git', :tag => s.version }
end