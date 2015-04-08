class projects::ipeer {
  boxen::project { 'ipeer':
    dir           => '/Users/compass/projects/ipeer/src',
    source        => 'ubc/ipeer',
    mysql         => true,
    #nginx         => 'projects/shared/ipeer.nginx.conf.erb',
    #php           => '5.5.13',
  }

  mysql::user { 'ipeer':
    password => 'ipeer',
  }

  mysql::user::grant { 'ipeer':
    database => 'ipeer',
    username => 'ipeer',
  }

  mysql::user::grant { 'ipeer_development':
    database => 'ipeer_development',
    username => 'ipeer',
  }

  mysql::user::grant { 'ipeer_test':
    database => 'ipeer_test',
    username => 'ipeer',
  }
}

