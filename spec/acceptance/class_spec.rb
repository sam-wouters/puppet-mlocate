require 'spec_helper_acceptance'

describe 'mlocate' do
  def cleanup_helper
    pp = <<-EOS
      package { 'mlocate': ensure => 'absent', }
      file { '/etc/cron.daily/locate': ensure => 'absent', }
      file { '/etc/updatedb.conf': ensure => 'absent', }
      file { '/usr/bin/locate': ensure => 'absent', }
      file { '/usr/bin/updatedb': ensure => 'absent', }
      file { '/var/lib/mlocate':
        ensure => 'absent',
        recurse => true,
        purge => true,
        force => true,
      }
    EOS
    apply_manifest(pp, catch_failures: true)
  end

  before(:context) do
    cleanup_helper
  end

  it 'works with no errors' do
    pp = <<-EOS
      class { 'mlocate': }
    EOS

    apply_manifest(pp, catch_failures: true)
    apply_manifest(pp, catch_changes: true)
  end
end
