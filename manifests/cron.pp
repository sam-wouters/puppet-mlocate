class mlocate::cron inherits mlocate {

  assert_private("Use of private class ${name} by ${caller_module_name}")

  if $mlocate::cron_schedule {
    $cron_args = {
      cron_schedule  => $mlocate::cron_schedule,
      update_command => $mlocate::update_command,
    }
  } else {
    $cron_args = {
      cron_schedule  => "${mlocate::cron_minute} ${mlocate::cron_hour} * * ${mlocate::cron_day}",
      update_command => $mlocate::update_command,
    }
  }

  $_real_ensure = $mlocate::cron_ensure ? {
    'present' => 'file',
    default   => 'absent',
  }

  # This template uses $update_command and $cron_schedule
  file { $mlocate::cron_d_path:
    ensure  => $_real_ensure,
    owner   => 'root',
    group   => 'root',
    mode    => '0444',
    content => epp("${module_name}/cron.d.epp", $cron_args),
  }
}
