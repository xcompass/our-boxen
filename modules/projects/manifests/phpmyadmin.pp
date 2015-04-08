class projects::phpmyadmin {
  boxen::project { 'phpmyadmin':
    dir           => '/Users/compass/projects/phpMyAdmin',
    source        => 'phpmyadmin/phpmyadmin',
    mysql         => false,
    #nginx         => 'projects/shared/root.nginx.conf.erb',
    #php           => '5.5.13',
  }
}
