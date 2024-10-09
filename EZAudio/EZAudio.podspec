Pod::Spec.new do |s|
    s.name         = "EZAudio"
    s.version          = '2.0.5'
    s.summary      = "音乐灯音频解析库"
    s.license      = { :type => 'MIT', :file => 'LICENSE' }
    s.ios.deployment_target = '8.0'
    s.osx.deployment_target = '10.8'
    s.exclude_files = [ 'EZAudio/TPCircularBuffer.{h,c}', 'EZAudio/EZAudioiOS.h', 'EZAudio/EZAudioOSX.h' ]
    s.ios.frameworks = 'AudioToolbox','AVFoundation','GLKit', 'Accelerate'
    s.osx.frameworks = 'AudioToolbox','AudioUnit','CoreAudio','QuartzCore','OpenGL','GLKit', 'Accelerate'
    s.requires_arc = true;
    s.default_subspec = 'Full'
    s.subspec 'Core' do |core|
        core.source_files  = 'EZAudio/**/*.{h,m,c}'
    end

    s.subspec 'Full' do |full|
        full.dependency 'TPCircularBuffer', '1.1'
        full.dependency 'EZAudio/Core'
    end
# ----- [CI] Auto generate -----
  s.define_singleton_method :support_xcode12_config do
    pod_xcconfig = attributes_hash.fetch('pod_target_xcconfig', {})

    all_archs = %w[arm64 armv7 x86_64 i386]
    exclude_archs = all_archs - pod_xcconfig.fetch('VALID_ARCHS', all_archs.join(' ')).split(' ')

    pod_xcconfig['EXCLUDED_ARCHS[sdk=iphonesimulator*]'] = 'arm64'
    pod_xcconfig['EXCLUDED_ARCHS[sdk=watchsimulator*]'] = 'x86_64 arm64'
    unless exclude_archs.empty?
      pod_xcconfig['EXCLUDED_ARCHS[sdk=iphonesimulator*]'] += ' ' + exclude_archs.join(' ')
    end

    pod_xcconfig.delete('VALID_ARCHS')
    attributes_hash['pod_target_xcconfig'] = pod_xcconfig

    user_xcconfig = attributes_hash.fetch('user_target_xcconfig', {})
    user_xcconfig['EXCLUDED_ARCHS[sdk=iphonesimulator*]'] = 'arm64'
    user_xcconfig['EXCLUDED_ARCHS[sdk=watchsimulator*]'] = 'x86_64 arm64'
    attributes_hash['user_target_xcconfig'] = user_xcconfig
  end


s.support_xcode12_config

# ----- [CI] end -----
end
