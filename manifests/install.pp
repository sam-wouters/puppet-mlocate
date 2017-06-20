class mlocate::install inherits mlocate {

  assert_private("Use of private class ${name} by ${caller_module_name}")

  package { 'mlocate':
    ensure => $mlocate::package_ensure,
    name   => $mlocate::package_name,
  }

  $updatedb_conf_args = {
    prunefs           => join(delete_undef_values([$mlocate::prunefs, $mlocate::extra_prunefs]), ' '),
    prunenames        => join(delete_undef_values([$mlocate::prunenames, $mlocate::extra_prunenames]), ' '),
    prunepaths        => join($mlocate::prunepaths, ' '),
    prune_bind_mounts => $mlocate::prune_bind_mounts,
  }

  file { 'updatedb.conf':
    ensure  => file,
    path    => $mlocate::conf_file,
    owner   => 'root',
    group   => 'root',
    mode    => '0444',
    content => epp("${module_name}/updatedb.conf.epp", $updatedb_conf_args),
    require => Package['mlocate'],
  }

  if $mlocate::deploy_update_command {
    file { 'update_command':
      ensure  => file,
      path    => $mlocate::update_command,
      owner   => 'root',
      group   => 'root',
      mode    => '0555',
      source  => "puppet:///modules/${module_name}/mlocate.cron",
      require => File['updatedb.conf'],
    }
  }

  file { $mlocate::cron_daily_path:
    ensure  => absent,
    require => Package['mlocate'],
  }

  if $mlocate::update_on_install == true {
    exec { $mlocate::update_command:
      refreshonly => true,
      creates     => '/var/lib/mlocate/mlocate.db',
      subscribe   => Package['mlocate'],
      require     => File['update_command'],
    }
  }
}
