Pod::Spec.new do |s|
    s.name                  = 'TableKit'
    s.module_name           = 'TableKit'

    s.version               = '2.11.0'

    s.homepage              = 'https://github.com/maxsokolov/TableKit'
    s.summary               = 'Type-safe declarative table views with Swift.'

    s.author                = { 'Max Sokolov' => 'i@maxsokolov.net' }
    s.license               = { :type => 'MIT', :file => 'LICENSE' }
    s.platforms             = { :ios => '8.0' }
    s.ios.deployment_target = '8.0'

    s.source_files          = 'Sources/*.swift'
    s.source                = { :git => 'https://github.com/maxsokolov/TableKit.git', :tag => s.version }
end
