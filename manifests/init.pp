# == Class: mlocate
#
# Install and manage the mlocate package.
#
# === Parameters
#
# [*package_name*]
#   The name of the package to install. Default: mlocate
#
# [*package_ensure*]
#   Ensure the package is present, latest, or absent. Default: present
#
# [*update_command*]
#   The name of the updatedb wrapper script. Default: /usr/local/bin/mlocate.cron
#
# [*deploy_update_command*]
#   If true the puppet module will deploy update_command script. Default: true
#
# [*update_on_install*]
#   Run an initial update when the package is installed. Default: true
#
# [*conf_file*]
#   The configuration file for updatedb. Default: /etc/updatedb.conf
#
# [*cron_ensure*]
#   Ensure the cron jobs is present or absent. Default: present
#
# [*cron_schedule*]
#   The standard cron time schedule. Default: once a week based on fqdn_rand
#
# [*cron_daily_path*]
#   The path to cron.daily file installed by mlocate and that is removed.
#
# [*prune_bind_mounts*]
#   Prune out bind mounts or not. Default: yes
#   Refer to the updatedb.conf man page for more detail.
#
# [*prunenames*]
#   Prune out directories matching this pattern. Default: .git .hg .svn
#   Refer to the updatedb.conf man page for more detail.
#
# [*extra_prunenames*]
#   Prune out additional directories matching this pattern. Default: none
#
# [*prunefs*]
#   Prune out these FS types. Default: refer to the params.pp
#   Refer to the updatedb.conf man page for more detail.
#
# [*extra_prunefs*]
#   Prune out additional directories matching this pattern. Default: none
#
# [*prunepaths*]
#   Prune out paths matching this pattern. Default: refer to params.pp
#   Refer to the updatedb.conf man page for more detail.
#
# [*extra_prunepaths*]
#   Prune out additional directories matching this pattern. Default: none
#
# === Examples
#
#  # Install a config that matches a modern RH system
#  include ::mlocate
#
#  # Prune some extra paths
#  class { '::mlocate':
#    extra_prunepaths = [ '/nas', '/exports' ],
#  }
#
# === Authors
#
# Adam Crews <Adam.Crews@gmail.com>
#
# === Copyright
#
# Copyright 2017 Adam Crews, unless otherwise noted.
#
class mlocate (
  String $package_name,
  Enum['present', 'installed', 'latest', 'absent'] $package_ensure,
  Stdlib::Absolutepath $update_command,
  Boolean $deploy_update_command,
  Boolean $update_on_install,
  Stdlib::Absolutepath $conf_file,
  Enum['present', 'absent'] $cron_ensure,
  Stdlib::Absolutepath $cron_daily_path,
  Stdlib::Absolutepath $cron_d_path,
  Array[String] $prunefs,
  Optional[Array[String]] $extra_prunefs,
  Array[Stdlib::Absolutepath] $prunepaths,
  Optional[Array[Stdlib::Absolutepath]] $extra_prunepaths,
  Optional[Array[String]] $prunenames,
  Optional[Array[String]] $extra_prunenames,
  Optional[String] $cron_schedule,
  Optional[Enum['yes', 'no']] $prune_bind_mounts,
  Optional[Integer[0,59]] $cron_minute = fqdn_rand(60, "${module_name}-min"),
  Optional[Integer[0,23]] $cron_hour = fqdn_rand(24, "${module_name}-hour"),
  Optional[Integer[0,6]] $cron_day = fqdn_rand(7, "${module_name}-day")
) {

  contain ::mlocate::install
  contain ::mlocate::cron

  Class['::mlocate::install']
  -> Class['::mlocate::cron']
}
