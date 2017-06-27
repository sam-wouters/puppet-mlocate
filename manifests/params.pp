class mlocate::params {

  $package_name          = 'mlocate'
  $package_ensure        = 'present'
  $update_command        = '/usr/local/bin/mlocate.cron'
  $deploy_update_command = true
  $update_on_install     = true
  $conf_file             = '/etc/updatedb.conf'
  $cron_ensure           = 'present'
  if $::osfamily == 'RedHat' and $::operatingsystemmajrelease == '5' {
    $prune_bind_mounts  = undef
    $prunenames = undef
  } else {
    $prunenames         = [ '.git', '.hg', '.svn' ]
    $prune_bind_mounts  = 'yes'
  }

  if $::osfamily == 'RedHat' and versioncmp($::operatingsystemrelease, '7.0') >= 0 {
    $cron_daily_path = '/etc/cron.daily/mlocate'
  } else {
    $cron_daily_path = '/etc/cron.daily/mlocate.cron'
  }

  $prunefs = [
    '9p', 'afs', 'anon_inodefs', 'auto', 'autofs', 'bdev', 'binfmt_misc',
    'cgroup', 'cifs', 'coda', 'configfs', 'cpuset', 'debugfs', 'devpts',
    'ecryptfs', 'exofs', 'fuse', 'fuse.sshfs', 'fusectl', 'fuse.glusterfs',
    'gfs', 'gfs2', 'gpfs', 'hugetlbfs', 'inotifyfs', 'iso9660', 'jffs2',
    'lustre', 'mqueue', 'ncpfs', 'nfs', 'nfs4', 'nfsd', 'pipefs', 'proc',
    'ramfs', 'rootfs', 'rpc_pipefs', 'securityfs', 'selinuxfs', 'sfs',
    'sockfs', 'sysfs', 'tmpfs', 'ubifs', 'udf', 'usbfs',
  ]

  $prunepaths = [
    '/afs', '/media', '/mnt', '/net', '/sfs', '/tmp', '/udev',
    '/var/cache/ccache', '/var/lib/yum/yumdb', '/var/spool/cups',
    '/var/spool/squid', '/var/tmp',
  ]

  $_cron_min  = fqdn_rand(60, "${module_name}-min")
  $_cron_hour = fqdn_rand(24, "${module_name}-hour")
  $_cron_day  = fqdn_rand(7, "${module_name}-day")

  # default run weekly at a random minute in a random hour on a random day.
  $cron_schedule = "${_cron_min} ${_cron_hour} * * ${_cron_day}"

}
