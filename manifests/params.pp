# Small set of parameters that are needed by the others classes
class serial_console::params {

  $no_rhgb_quiet           = true
  $root_login_console      = true
  $regular_console_enabled = true
  $serial_primary_console  = true

  # By default, Virtual Machines output at ttyS0 , Oracle Physical at ttyS0
  # And the others at ttyS1 and baud_rate 115200
  if $::is_virtual {
    $serial_port       = 'ttyS0'
    $baud_rate         = '115200'
  } elsif ($::dmi != undef) and ($::dmi['manufacturer'] =~ /Oracle|SUN/) {
    $serial_port       = 'ttyS0'
    $baud_rate         = '9600'
  } else {
    $serial_port       = 'ttyS1'
    $baud_rate         = '115200'
  }


}
