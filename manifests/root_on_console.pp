# This class configures system to allow or disallow root to login on that console
class serial_console::root_on_console (
  $serial_port         = $serial_console::params::serial_port,
  $root_login_console  = $serial_console::params::root_login_console,
) {

  if $root_login_console {
    file_line { 'root_allow_login_console':
      path  => '/etc/securetty',
      line  => $serial_port,
      match => $serial_port,
    }
  } else {
    file_line { 'root_allow_login_console':
      ensure => absent,
      path   => '/etc/securetty',
      line   => $serial_port,
      match  => $serial_port,
      #match_for_absence => true,
    }

  }

}
