# Setting Grub Static Configuration
class serial_console::static_config (
  $serial_port         = $serial_console::params::serial_port,
  $baud_rate           = $serial_console::params::baud_rate,
  $no_rhgb_quiet       = $serial_console::params::no_rhgb_quiet,
)
{

  $kernel_param_console = $::initsystem ? {
    'systemd'          => $serial_port,
    default            => "${serial_port},${baud_rate}",
  }

  kernel_parameter { 'console':
    ensure => present,
    value  => $kernel_param_console,
  }

  if rhgb_quiet == true {
    kernel_parameter { 'quiet':
      ensure => absent,
    }
    kernel_parameter { 'rhgb':
      ensure => absent,
    }
  }


}
