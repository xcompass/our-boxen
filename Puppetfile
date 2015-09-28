# This file manages Puppet module dependencies.
#
# It works a lot like Bundler. We provide some core modules by
# default. This ensures at least the ability to construct a basic
# environment.

# Shortcut for a module from GitHub's boxen organization
def github(name, *args)
  options ||= if args.last.is_a? Hash
    args.last
  else
    {}
  end

  if path = options.delete(:path)
    mod name, :path => path
  else
    version = args.first
    options[:repo] ||= "boxen/puppet-#{name}"
    mod name, version, :github_tarball => options[:repo]
  end
end

# Shortcut for a module under development
def dev(name, *args)
  mod "puppet-#{name}", :path => "#{ENV['HOME']}/src/boxen/puppet-#{name}"
end

# Includes many of our custom types and providers, as well as global
# config. Required.

github "boxen", "3.11.0"

# Support for default hiera data in modules

github "module_data", "0.0.4", :repo => "ripienaar/puppet-module-data"

# Core modules for a basic development environment. You can replace
# some/most of these if you want, but it's not recommended.

github "brewcask",    "0.0.6"
github "dnsmasq",     "2.0.1"
github "foreman",     "1.2.0"
github "gcc",         "3.0.2"
github "git",         "2.7.92"
github "go",          "2.1.0"
github "homebrew",    "1.13.0"
github "hub",         "1.4.1"
github "inifile",     "1.4.1", :repo => "puppetlabs/puppetlabs-inifile"
github "nginx",       "1.4.6"
github "nodejs",      "5.0.0"
github "openssl",     "1.0.0"
github "phantomjs"
github "pkgconfig",   "1.0.0"
github "repository",  "2.4.1"
github "ruby",        "8.5.2"
github "stdlib",      "4.7.0", :repo => "puppetlabs/puppetlabs-stdlib"
github "sudo",        "1.0.0"
github "xquartz",     "1.2.1"

# Optional/custom modules. There are tons available at
# https://github.com/boxen.

github "vlc"
github "osx"
github "virtualbox"
github "wget"
mod    "xcompass/vim", :git => "https://github.com/xcompass/puppet-vim.git"
github "osxfuse"
github "chrome"
github "vagrant"
github "phantomjs"
github "gpgtools"
github "adobe_reader"
github "quicksilver"
github "evernote"
github "chicken_of_the_vnc"
github "skype"
github "adium"
github "dropbox"
github "picasa"
github "dockutil"
#github "php"
#mod    "boxen-php",         :git => "https://github.com/boxen/puppet-php.git"
github "autoconf",    "1.0.0"
github "libtool",     "1.0.0"
github "pcre",        "1.0.0"
github "libpng",      "1.0.0"
github "mysql"
github "spf13vim3",   "1.0.0", :repo => "samjsharpe/puppet-spf13vim3"
mod    "mosen/cups",        :git => "https://github.com/xcompass/puppet-cups.git"
github "msoffice",    "1.0.0", :repo => "xcompass/puppet-msoffice"
github "computrace",  "1.0.0", :repo => "xcompass/puppet-computrace"
github "python",      "3.0.0", :repo => "mloberg/puppet-python"
github "go"
# github "elasticsearch", "2.8.0"
# github "mysql",         "2.0.1"
# github "postgresql",  "4.0.1"
github "redis",       "3.1.0"
# github "sysctl",      "1.0.1"
