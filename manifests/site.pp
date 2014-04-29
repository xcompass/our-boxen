require boxen::environment
require homebrew
require gcc

Exec {
  group       => 'staff',
  logoutput   => on_failure,
  user        => $boxen_user,

  path => [
    "${boxen::config::home}/rbenv/shims",
    "${boxen::config::home}/rbenv/bin",
    "${boxen::config::home}/rbenv/plugins/ruby-build/bin",
    "${boxen::config::home}/homebrew/bin",
    '/usr/bin',
    '/bin',
    '/usr/sbin',
    '/sbin'
  ],

  environment => [
    "HOMEBREW_CACHE=${homebrew::config::cachedir}",
    "HOME=/Users/${::boxen_user}"
  ]
}

File {
  group => 'staff',
  owner => $boxen_user
}

Package {
  provider => homebrew,
  require  => Class['homebrew']
}

Repository {
  provider => git,
  extra    => [
    '--recurse-submodules'
  ],
  require  => File["${boxen::config::bindir}/boxen-git-credential"],
  config   => {
    'credential.helper' => "${boxen::config::bindir}/boxen-git-credential"
  }
}

Service {
  provider => ghlaunchd
}

Homebrew::Formula <| |> -> Package <| |>

node default {
  # core modules, needed for most things
  include dnsmasq
  include git
  include hub
  include nginx

  # fail if FDE is not enabled
  if $::root_encrypted == 'no' {
    fail('Please enable full disk encryption and try again')
  }

  # node versions
  include nodejs::v0_6
  include nodejs::v0_8
  include nodejs::v0_10

  # default ruby versions
  ruby::version { '1.9.3': }
  ruby::version { '2.0.0': }
  ruby::version { '2.1.0': }
  ruby::version { '2.1.1': }
  ruby::version { '2.1.2': }

  # common, useful packages
  package {
    [
      'ack',
      'findutils',
      'gnu-tar'
    ]:
  }

  file { "${boxen::config::srcdir}/our-boxen":
    ensure => link,
    target => $boxen::config::repodir
  }

  include vlc
  include osx::dock::autohide
  include osx::finder::show_all_on_desktop
  include osx::finder::show_hidden_files
  include osx::finder::enable_quicklook_text_selection
  include osx::disable_app_quarantine
  include osx::no_network_dsstores 
  include osx::software_update
  include virtualbox
  include wget
  include osxfuse
  include chrome
  include firefox
  include tmux
  include vagrant
  include phantomjs
  include gpgtools
  include adobe_reader
  include quicksilver
  include evernote
  include chicken_of_the_vnc
  include skype 
  include adium
  include dropbox
  include picasa
  include dockutil
  include keepassx
  include googledrive
  #include php::5_4
  #include php::composer
  include autoconf
  include libtool
  include pcre
  include libpng
  #include mysql
  include spf13vim3
  include vim

  package {'openconnect':
    ensure => present,
  }

  dockutil::item {'Add iTerm':
    item  => "/Applications/iTerm.app",
    label => "iTerm",
    action => "add",
    position => 2,
  }

  dockutil::item {'Add Chrome':
    item  => "/Applications/Google Chrome.app",
    label => "Google Chrome",
    action => "add",
    position => 3,
  }

  package {'computracce':
    source => "http://artifactory.ctlt.ubc.ca/artifactory/ctlt-release-local/Computrace/RPClient.pkg.zip",
    provider => 'compressed_pkg',
  }
}
