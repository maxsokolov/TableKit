Pod::Spec.new do |s|
    s.name                  = 'Tablet'
    s.version               = '0.1.0'

    s.homepage              = 'https://github.com/maxsokolov/tablet'
    s.summary               = 'Tablet is a super lightweight yet powerful Swift library that handles a complexity of UITableView's datasource and delegate.'

    s.author                = { 'Max Sokolov' => 'i@maxsokolov.net' }
    s.license               = { :type => 'MIT', :file => 'LICENSE' }
    s.platforms             = { :ios => '8.0' }
    s.ios.deployment_target = '8.0'

    s.source_files          = 'Tablet/*.swift'
    s.module_name           = 'Tablet'
    s.source                = { :git => 'https://github.com/maxsokolov/tablet.git', :tag => s.version }
end