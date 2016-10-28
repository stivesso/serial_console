# Settings Terminal-Related Configuration
class serial_console::terminal_config (
  $serial_port         = $serial_console::params::serial_port,
  $baud_rate           = $serial_console::params::baud_rate,
)
{

  case $::initsystem {
    'systemd': {
      service { "serial-getty@${serial_port}.service":
        ensure => 'running',
      }
    }
    'upstart': {
      file { "/etc/init/${serial_port}.conf":
        ensure  => present,
        content => template('serial_console/upstart_ttyS.erb'),
        mode    => '0644',
      }
      service { $serial_port:
        ensure  => 'running',
        require => File["/etc/init/${serial_port}.conf"],
        start   => "/sbin/initctl start ${serial_port}",
        stop    => "/sbin/initctl stop ${serial_port}",
        status  => "/sbin/initctl status ${serial_port} | grep running",
      }
    }
    'sysvinit': {
      file_line { "inittab_${serial_port}":
        ensure => present,
        path   => '/etc/inittab',
        line   => "S1:2345:respawn:/sbin/agetty ${baud_rate} ${serial_port} vt100",
        match  => "^[^#].*agetty.*${serial_port}",
        notify => Exec['re_examine_inittab'],
      }
      exec { 're_examine_inittab':
        command     => 'init q',
        path        => ['/sbin', '/usr/sbin', '/bin', '/usr/bin'],
        refreshonly => true,
      }
    }
    default: {notify {"${::initsystem} is not yet supported by serial_console, Only Upstart and Systemd are supported for now":}}
  }

}
