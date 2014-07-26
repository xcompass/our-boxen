class projects::ipeer {
  php::project { 'ipeer':
    dir           => '/Users/compass/projects/ipeer/src',
    source        => 'ubc/ipeer',
    mysql         => true,
    nginx         => 'projects/shared/ipeer.nginx.conf.erb',
    php           => '5.4.17',
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

