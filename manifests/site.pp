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
    "${boxen::config::homebrewdir}/bin",
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
  nodejs::version { 'v0.6': }
  nodejs::version { 'v0.8': }
  nodejs::version { 'v0.10': }

  # default ruby versions
  ruby::version { '1.8.7': }
  ruby::version { '1.9.3': }
#  ruby::version { '2.0.0': }
#  ruby::version { '2.1.0': }
#  ruby::version { '2.1.1': }
#  ruby::version { '2.1.2': }

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
  include chrome
  include vagrant
  include phantomjs
  include gpgtools
  include adobe_reader
  include quicksilver
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
  include mysql
  include spf13vim3
  include vim
  include msoffice
  include computrace

  package {'openconnect':
    ensure => present,
  }

  dockutil::item {'Add iTerm':
    item     => '/Applications/iTerm.app',
    label    => 'iTerm',
    action   => 'add',
    position => 2,
  }

  dockutil::item {'Add Chrome':
    item     => '/Applications/Google Chrome.app',
    label    => 'Google Chrome',
    action   => 'add',
    position => 3,
  }

  package {'xerox_driver':
    #source   => 'http://download.support.xerox.com/pub/drivers/WC780X/drivers/macosx106/pt_BR/XeroxPrintDriver3.11.0_1278.dmg',
    source   => 'http://download.support.xerox.com/pub/drivers/CQ8570/drivers/macosx107/pt_BR/XeroxPrintDriver.3.52.0_1481.dmg',
    provider => 'pkgdmg'
  }

  package {'reattach-to-user-namespace':
    ensure => present,
  }

  $printers = hiera('printers', {})
  create_resources(printer, $printers)

  #include php::fpm::5_4_17

  # doesn't work
  #php::extension::apc { "apc for 5.4.17":
  #  php => '5.4.17',
  #}

  homebrew::tap { ['homebrew/dupes']: }

  package { 'php54':}
  package { ['php54-apc', 'php54-redis']: }
  package {'redis': }

  vagrant::plugin {[
  'vagrant-hostmanager',
  'vagrant-vbox-snapshot',
  'vagrant-vbguest'
  ]:}

  file { '/usr/bin/vi':
    ensure => link,
    target => '/opt/boxen/homebrew/bin/vim',
    require => Package['vim']
  }
}
