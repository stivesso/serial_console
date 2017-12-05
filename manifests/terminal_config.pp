# Settings Terminal-Related Configuration
class serial_console::terminal_config inherits serial_console
{

  case $::initsystem {
    'systemd': {
      service { "serial-getty@${serial_console::serial_port}.service":
        ensure => 'running',
      }
    }
    'upstart': {
      file { "/etc/init/${serial_console::serial_port}.conf":
        ensure  => present,
        content => template('serial_console/upstart_ttyS.erb'),
        mode    => '0644',
      }
      service { $serial_console::serial_port:
        ensure  => 'running',
        require => File["/etc/init/${serial_console::serial_port}.conf"],
        start   => "/sbin/initctl start ${serial_console::serial_port}",
        stop    => "/sbin/initctl stop ${serial_console::serial_port}",
        status  => "/sbin/initctl status ${serial_console::serial_port} | grep running",
      }
    }
    'sysvinit': {
      file_line { "inittab_${serial_console::serial_port}":
        ensure => present,
        path   => '/etc/inittab',
        line   => "S1:2345:respawn:/sbin/agetty ${serial_console::baud_rate} ${serial_console::serial_port} vt100",
        match  => "^[^#].*agetty.*${serial_console::serial_port}",
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
