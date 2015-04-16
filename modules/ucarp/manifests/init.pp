
class ucarp {
  package { "ucarp":
    ensure => installed,
  }
}

define ucarp::instance ($vip, $vip_ip, $interface, $master, $password,
                        $application, $advbase=1) {
  require ucarp
  file { "ucarp-${vip}":
    path    => "/etc/init.d/ucarp-${vip}",
    content => template('ucarp/ucarp.erb'),
    mode    => 755,
    notify  => Service["ucarp-${vip}"],
  }
  file { "${vip}-up":
    path    => "/usr/share/ucarp/uc${vip}-up",
    content => template('ucarp/vip-up.erb'),
    mode    => 755,
    notify  => Service["ucarp-${vip}"],
  }
  file { "${vip}-down":
    path    => "/usr/share/ucarp/uc${vip}-down",
    content => template('ucarp/vip-down.erb'),
    mode    => 755,
    notify  => Service["ucarp-${vip}"],
  }
  service { "ucarp-${vip}":
    ensure     => running,
    enable     => true,
    hasrestart => true,
    hasstatus  => true,
    require    => [File["ucarp-${vip}"],File["${vip}-up"],File["${vip}-down"]]
  }
}
