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
  class { 'nodejs::global':
    version => '0.12'
  }
  npm_module { 'bower for all nodes':
    module       => 'bower',
    version      => '~> 1.4.1',
    node_version => '*',
  }

  # default ruby versions
  ruby::version { '1.9.3': }
#  ruby::version { '2.0.0': }
#  ruby::version { '2.1.7': }
  ruby::version { '2.2.3': }

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

  # some common packages
  include virtualbox
  include chrome
  include vagrant
  include phantomjs
  include mysql
  include msoffice
  include computrace

  dockutil::item {'Add Chrome':
    item     => '/Applications/Google Chrome.app',
    label    => 'Google Chrome',
    action   => 'add',
    position => 3,
  }

  # install printer driver
  package {'xerox_driver':
    source   => 'http://download.support.xerox.com/pub/drivers/CQ8570/drivers/macosx1010/ar/XeroxPrintDriver.3.64.0_1572.dmg',
    provider => 'pkgdmg'
  }

  $printers = hiera('printers', {})
  create_resources(printer, $printers)

  vagrant::plugin {[
  'vagrant-hostmanager',
  'vagrant-vbox-snapshot',
  'vagrant-vbguest'
  ]:}
}
