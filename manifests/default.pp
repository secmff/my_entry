
stage { 'first':
  before => Stage['main'],
}
class { 'update':
  stage => first,
}

class update {
  exec { "apt-get update":
    command  => "/usr/bin/apt-get update",
  }
}

file {'mmrc':
  path    => '/root/.mmrc',
  ensure  => present,
  mode    => 0444,
  content => "http://www.mmrc.nl\n",
}

package { 'redis':
  ensure => 'installed',
  provider => 'gem',
}

node /^redis\d\d$/ {
  class {'redis':
    version => '3.0.0',
    redis_cluster_enabled => 'yes',
    redis_cluster_node_timeout => 5000,
    redis_appendonly => 'yes',
  }
  redis::instance { 'redis-6380':
    redis_port => '6380',
    redis_cluster_enabled => 'yes',
    redis_cluster_node_timeout => 5000,
    redis_appendonly => 'yes',
  }
}

node /^front\d\d$/ {
  include "frontend"
}
