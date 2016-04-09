# Setting Kernel-related Configuration
class serial_console::kernel_config (
  $serial_port             = $serial_console::params::serial_port,
  $baud_rate               = $serial_console::params::baud_rate,
  $no_rhgb_quiet           = $serial_console::params::no_rhgb_quiet,
  $regular_console_enabled = $serial_console::params::regular_console_enabled,
  $serial_primary_console  = $serial_console::params::serial_primary_console,
)
{

  # Whether we need to keep tty0 or not
  if $regular_console_enabled {
    $kernel_param_console = $serial_primary_console ? {
      true                => ['tty0', "${serial_port},${baud_rate}"],
      default             => ["${serial_port},${baud_rate}", 'tty0'],
    }
  } else {
    $kernel_param_console = "${serial_port},${baud_rate}"
  }


  kernel_parameter { 'console':
    ensure => present,
    value  => $kernel_param_console,
  }

  if $no_rhgb_quiet == true {
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
