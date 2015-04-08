class projects::acj {
  python::version { '3.4': }

  boxen::project {'acj':
    mysql  => true,
    source => 'ubc/acj-versus'
  }
}
