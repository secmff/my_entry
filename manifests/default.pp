

file {'mmrc':
      path    => '/root/.mmrc',
      ensure  => present,
      mode    => 0444,
      content => "http://www.mmrc.nl\n",
}

class {'redis':
}