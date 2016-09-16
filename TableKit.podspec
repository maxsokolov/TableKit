Pod::Spec.new do |s|
    s.name                  = 'TableKit'
    s.module_name           = 'TableKit'

    s.version               = '2.0.0'

    s.homepage              = 'https://github.com/noxt/TableKit'
    s.summary               = 'Type-safe declarative table views. Swift 3 is required.'

    s.author                = { 'Max Sokolov' => 'id.noxt@gmail.com' }
    s.license               = { :type => 'MIT', :file => 'LICENSE' }
    s.platforms             = { :ios => '8.0' }
    s.ios.deployment_target = '8.0'

    s.source_files          = 'Sources/*.swift'
    s.source                = { :git => 'https://github.com/noxt/TableKit.git', :tag => s.version }
end