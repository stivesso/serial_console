# Setting Kernel-related Configuration
class serial_console::kernel_config inherits serial_console
{

  # Whether we need to keep tty0 or not
  if $serial_console::regular_console_enabled {
    $kernel_param_console = $serial_console::serial_primary_console ? {
      true                => ['tty0', "${serial_console::serial_port},${serial_console::baud_rate}"],
      default             => ["${serial_console::serial_port},${serial_console::baud_rate}", 'tty0'],
    }
  } else {
    $kernel_param_console = "${serial_console::serial_port},${serial_console::baud_rate}"
  }


  kernel_parameter { 'console':
    ensure => present,
    value  => $kernel_param_console,
  }

  if $serial_console::no_rhgb_quiet == true {
    kernel_parameter { 'quiet':
      ensure => absent,
    }
    kernel_parameter { 'rhgb':
      ensure => absent,
    }
  } else {

    kernel_parameter { 'quiet':
      ensure => present,
    }
    kernel_parameter { 'rhgb':
      ensure => present,
    }

  }


}
