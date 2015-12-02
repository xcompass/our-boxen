class people::xcompass{
 # install mac apps
  package {
    #'DiskWave':
    #  source => "http://diskwave.barthe.ph/download/DiskWave_0.4.dmg",
    #  provider => appdmg;
    'XMind':
      source => "http://www.xmind.net/xmind/downloads/xmind-macosx-3.4.1.201401221918.dmg",
      provider => appdmg;
#    'Haroopad':
#      source => "https://dl.dropbox.com/s/yvjb90ywib551ex/haroopad-v0.12.0.dmg",
#      provider => appdmg;
#    'GanttProject':
#      source => "http://dl.ganttproject.biz/ganttproject-2.6.6/ganttproject-2.6.6-r1715.dmg",
#      provider => appdmg;
#    'Paintbrush':
#      source => "http://downloads.sourceforge.net/paintbrush/Paintbrush-2.1.1.zip",
#      provider => compressed_app;
#   'Genymotion':
#     source => "https://ssl-files.genymotion.com/genymotion/genymotion-2.0.3/genymotion-2.0.3.dmg",
#     provider => appdmg;
    'AndroidFileTransfer':
      source => "https://dl.google.com/dl/androidjumper/mtp/current/androidfiletransfer.dmg",
      provider => appdmg;
    #'SQLiteBrowser':
    #  source   => 'https://github.com/sqlitebrowser/sqlitebrowser/releases/download/v3.5.1/sqlitebrowser-with_sqlcipher_support-3.5.1.dmg',
    #  provider => appdmg;
    'FileZilla':
      source   => 'http://downloads.sourceforge.net/project/filezilla/FileZilla_Client/3.11.0.2/FileZilla_3.11.0.2_macosx-x86.app.tar.bz2',
      flavor => 'tar.bz2',
      provider => compressed_app;
    'KeepPassX':
      source => 'https://www.keepassx.org/dev/attachments/download/72/KeePassX-2.0-alpha6.dmg',
      provider => appdmg;
    'GoogleDrive':
      source => 'http://dl.google.com/drive/installgoogledrive.dmg',
      provider => appdmg;
    'Chicken_of_the_vnc':
      source => 'http://downloads.sourceforge.net/chicken/Chicken-2.2b2.dmg',
      provider => appdmg;
    'OSXFuse':
      source => 'http://downloads.sourceforge.net/project/osxfuse/osxfuse-2.8.2/osxfuse-2.8.2.dmg',
      provider => pkgdmg;
    'Firefox':
      source => 'https://download-installer.cdn.mozilla.net/pub/firefox/releases/42.0/mac/en-US/Firefox%2042.0.dmg',
      provider => 'appdmg';
    'Gnucash':
      source => 'http://downloads.sourceforge.net/project/gnucash/gnucash%20%28stable%29/2.6.9/Gnucash-Intel-2.6.9-1.dmg',
      provider => 'appdmg';
    'GIMP':
      source => 'http://download.gimp.org/pub/gimp/v2.8/osx/gimp-2.9.2.dmg',
      provider => 'appdmg';
  }

  include vlc
  include wget
  include gpgtools
  include adobe_reader
  include evernote
  include skype
  include adium
  include dropbox
  include picasa
  include dockutil
  #include php::composer
  include autoconf
  include libtool
  include pcre
  include libpng
  include spf13vim3
  include vim
  include iterm2:dev

  package { [
      'tmux', 
      'autoenv', 
      'bash', 
      'wrk', 
      'gradle', 
      'openconnect', 
      'reattach-to-user-namespace',
      'ncdu',
      'ffmpeg',
    ]: }

#  include go
#  go::version { '1.4': }

  osx::recovery_message { 'If this Mac is found, please call 604-617-1834': }
  include osx::global::enable_standard_function_keys
  include osx::global::expand_print_dialog
  include osx::global::expand_save_dialog
  include osx::global::disable_remote_control_ir_receiver
  include osx::global::tap_to_click
  include osx::dock::autohide
  include osx::dock::dim_hidden_apps
  include osx::finder::show_external_hard_drives_on_desktop
  include osx::finder::show_mounted_servers_on_desktop
  include osx::finder::show_removable_media_on_desktop
  include osx::finder::unhide_library
  include osx::finder::show_hidden_files
  include osx::finder::show_all_filename_extensions
  include osx::safari::enable_developer_mode
  include osx::no_network_dsstores
  include osx::disable_app_quarantine
  include osx::finder::show_all_on_desktop
  include osx::finder::enable_quicklook_text_selection
  include osx::software_update

  $python_global = 2.7
  class { 'python::global':
    version => $python_global
  }

  python::package { "powerline for 2.7":
    package => 'powerline-status',
    python  => $python_global,
  }

  # need by tmux powerline
  python::package { "psutil":
    package => 'psutil',
    python  => $python_global,
  }

  $ruby_global = '2.1.2'
  class { 'ruby::global':
    version => $ruby_global
  }
  ruby_gem { "tmuxinator":
    gem          => 'tmuxinator',
    ruby_version => $ruby_global,
  }

  $powerline_font = 'DejaVuSansMonoForPowerline 12'
  exec { 'setup iterm2 normal font':
    command => "/usr/libexec/PlistBuddy -c \"Set :'New Bookmarks':0:'Normal Font' '${powerline_font}'\" ~/Library/Preferences/com.googlecode.iterm2.plist",
    unless  => "/usr/libexec/PlistBuddy -c \"print :'New Bookmarks':0:'Normal Font'\" ~/Library/Preferences/com.googlecode.iterm2.plist | /usr/bin/grep '${powerline_font}'",
    require => Python::Package['iTerm', 'powerline for 2.7'],
  }
  exec { 'setup iterm2 non ascii font':
    command => "/usr/libexec/PlistBuddy -c \"Set :'New Bookmarks':0:'Non Ascii Font' '${powerline_font}'\" ~/Library/Preferences/com.googlecode.iterm2.plist",
    unless  => "/usr/libexec/PlistBuddy -c \"print :'New Bookmarks':0:'Non Ascii Font'\" ~/Library/Preferences/com.googlecode.iterm2.plist | /usr/bin/grep '${powerline_font}'",
    require => Python::Package['iTerm', 'powerline for 2.7'],
  }

  include projects::all

  # setup /etc/profile to clear PATH before run path_helper
  # otherwise tmux will source path_helper twice and mess up pyenv path
  file {'/etc/profile':
    ensure => present,
    source => 'puppet:///modules/people/profile'
  }

  dockutil::item {'Add iTerm':
    item     => '/Applications/iTerm.app',
    label    => 'iTerm',
    action   => 'add',
    position => 2,
    require  => Package['iTerm']
  }

  # doesn't work
  #php::extension::apc { "apc for 5.4.17":
  #  php => '5.4.17',
  #}

  homebrew::tap { ['homebrew/dupes']: }

  package { 'php54':}
  package { ['php54-apc', 'php54-redis']: }
  package {'redis': }

  file { '/usr/bin/vi':
    ensure => link,
    target => '/opt/boxen/homebrew/bin/vim',
    require => Package['vim']
  }
}
