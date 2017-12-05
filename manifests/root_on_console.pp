# This class configures system to allow or disallow root to login on that console
class serial_console::root_on_console inherits serial_console
{

  if $serial_console::root_login_console {
    file_line { 'root_allow_login_console':
      path  => '/etc/securetty',
      line  => $serial_console::serial_port,
      match => $serial_console::serial_port,
    }
  } else {
    file_line { 'root_allow_login_console':
      ensure => absent,
      path   => '/etc/securetty',
      line   => $serial_console::serial_port,
      match  => $serial_console::serial_port,
      #match_for_absence => true,
    }

  }

}
