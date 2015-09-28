class people::xcompass{
 # install mac apps
  package {
    'DiskWave':
      source => "http://diskwave.barthe.ph/download/DiskWave_0.4.dmg",
      provider => appdmg;
    'XMind':
      source => "http://www.xmind.net/xmind/downloads/xmind-macosx-3.4.1.201401221918.dmg",
      provider => appdmg;
    'Haroopad':
      source => "https://dl.dropbox.com/s/yvjb90ywib551ex/haroopad-v0.12.0.dmg",
      provider => appdmg;
    'GanttProject':
      source => "http://dl.ganttproject.biz/ganttproject-2.6.6/ganttproject-2.6.6-r1715.dmg",
      provider => appdmg;
#    'Paintbrush':
#      source => "http://downloads.sourceforge.net/paintbrush/Paintbrush-2.1.1.zip",
#      provider => compressed_app;
#   'Genymotion':
#     source => "https://ssl-files.genymotion.com/genymotion/genymotion-2.0.3/genymotion-2.0.3.dmg",
#     provider => appdmg;
    'AndroidFileTransfer':
      source => "https://dl.google.com/dl/androidjumper/mtp/current/androidfiletransfer.dmg",
      provider => appdmg;
    'SQLiteBrowser':
      source   => 'https://github.com/sqlitebrowser/sqlitebrowser/releases/download/v3.5.1/sqlitebrowser-with_sqlcipher_support-3.5.1.dmg',
      provider => appdmg;
    'FileZilla':
      source   => 'http://downloads.sourceforge.net/project/filezilla/FileZilla_Client/3.10.3/FileZilla_3.10.3_macosx-x86.app.tar.bz2?r=http%3A%2F%2Fsourceforge.net%2Fprojects%2Ffilezilla%2Ffiles%2FFileZilla_Client%2F3.10.3%2F&ts=1428013991&use_mirror=iweb',
      flavor => 'tar.bz2',
      provider => compressed_app;
    'ffmpeg':
      ensure => present;
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
      source => 'http://downloads.sourceforge.net/project/osxfuse/osxfuse-2.7.5/osxfuse-2.7.5.dmg',
      provider => pkgdmg;
    'Firefox':
      source => 'http://ftp.mozilla.org/pub/mozilla.org/firefox/releases/latest/mac/en-US/Firefox%2039.0.3.dmg',
      provider => 'appdmg';
    'Gnucash':
      source => 'http://downloads.sourceforge.net/project/gnucash/gnucash%20%28stable%29/2.6.6/Gnucash-Intel-2.6.6-5.dmg',
      provider => 'appdmg';
    'GIMP':
      source => 'http://download.gimp.org/pub/gimp/v2.8/osx/gimp-2.8.14.dmg',
      provider => 'appdmg';
  }

  package { ['tmux', 'autoenv', 'bash', 'wrk']: }
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
    require => Python::Package['powerline for 2.7'],
  }
  exec { 'setup iterm2 non ascii font':
    command => "/usr/libexec/PlistBuddy -c \"Set :'New Bookmarks':0:'Non Ascii Font' '${powerline_font}'\" ~/Library/Preferences/com.googlecode.iterm2.plist",
    unless  => "/usr/libexec/PlistBuddy -c \"print :'New Bookmarks':0:'Non Ascii Font'\" ~/Library/Preferences/com.googlecode.iterm2.plist | /usr/bin/grep '${powerline_font}'",
    require => Python::Package['powerline for 2.7'],
  }

  include projects::all

  # setup /etc/profile to clear PATH before run path_helper
  # otherwise tmux will source path_helper twice and mess up pyenv path
  file {'/etc/profile':
    ensure => present,
    source => 'puppet:///modules/people/profile'
  }
}
