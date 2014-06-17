class projects::acj {
  python::version { '2.7.6': }
  python::version { '3.3.5': }

  # Set the global version of Python
  class { 'python::global':
    version => '2.7.6'
  }

  python::plugin { 'pyenv-virtualenv':
    ensure => 'v20140421',
    source => 'yyuu/pyenv-virtualenv'
  }

  boxen::project {'acj':
    mysql  => true,
    source => 'ubc/acj-versus'
  }
}
