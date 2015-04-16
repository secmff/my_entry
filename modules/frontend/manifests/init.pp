class frontend {
  package { ['build-essential','git','ruby-bundler','postfix']:
    ensure => 'installed',
  }

  group { 'sinatra':
    ensure  => 'present',
  }
  user { 'sinatra':
    ensure     => 'present',
    gid        => 'sinatra',
    home       => '/home/sinatra',
    managehome => yes,
    require    => Group['sinatra'],
  }

  exec { 'get lamernews':
    command => '/usr/bin/git clone https://github.com/secmff/lamernews.git',
    creates => '/home/sinatra/lamernews',
    cwd     => '/home/sinatra',
    user    => 'sinatra',
    require => [User['sinatra'],Package['git']],
  }
  exec { 'run bundle':
    command => '/usr/bin/bundle install --path /home/sinatra/vendor/bundle',
    creates => '/home/sinatra/.bundler',
    cwd     => '/home/sinatra/lamernews',
    user    => 'sinatra',
    require => [Exec['get lamernews'],Package['ruby-bundler']],
  }
  exec { 'get redis-rb-cluster':
    command => '/usr/bin/git clone https://github.com/secmff/redis-rb-cluster.git',
    creates => '/home/sinatra/redis-rb-cluster',
    cwd     => '/home/sinatra',
    user    => 'sinatra',
    require => [User['sinatra'],Package['git']],
  }

  file { ['/home/sinatra/lamernews/config','/home/sinatra/lamernews/log']:
    ensure  => directory,
    owner   => 'sinatra',
    group   => 'sinatra',
    require => Exec['get lamernews'],
  }

  file { '/home/sinatra/lamernews/app_config.rb':
    content => template('frontend/app_config.rb.erb'),
    owner   => 'sinatra',
    group   => 'sinatra',
    require => Exec['get lamernews'],
    notify  => Unicorn::App['lamernews'],
  }
  file { '/var/log/lamernews':
    ensure      => directory,
    owner       => 'sinatra',
    group       => 'sinatra',
  }
  unicorn::app { 'lamernews':
    approot     => '/home/sinatra/lamernews',
    pidfile     => '/home/sinatra/unicorn.pid',
    socket      => '/home/sinatra/unicorn.sock',
    logdir      => '/var/log/lamernews',
    user        => 'sinatra',
    group       => 'sinatra',
    preload_app => true,
    workers     => 8,
    rack_env    => 'production',
    source      => 'system',
    require     => [Exec['get lamernews'],Exec['get redis-rb-cluster'],
                    File['/var/log/lamernews']],
  }

  class { 'nginx': }
  nginx::resource::upstream { 'sinatra_app':
    members => [ "unix:/home/sinatra/unicorn.sock" ],
  }
  nginx::resource::vhost { 'news.blendle.com':
    proxy => 'http://sinatra_app',
  }

  include ucarp
  ucarp::instance { 'ucarp200':
    vip         => 200,
    vip_ip      => "192.168.33.200",
    interface   => "eth1",
    master      => "front01",
    password    => "FradJegAuks5",
    application => "unicorn_lamernews",
  }
  ucarp::instance { 'ucarp201':
    vip         => 201,
    vip_ip      => "192.168.33.201",
    interface   => "eth1",
    master      => "front02",
    password    => "Olkavfaps9",
    application => "unicorn_lamernews",
  }
  ucarp::instance { 'ucarp202':
    vip         => 202,
    vip_ip      => "192.168.33.202",
    interface   => "eth1",
    master      => "front03",
    password    => "kafAbVon4",
    application => "unicorn_lamernews",
  }
}
