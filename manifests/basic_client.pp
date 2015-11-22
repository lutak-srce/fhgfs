#
# = Class: fhgfs::basic_client
#
# This module manages FhGFS client. 
# Mountpoints are defined with fhgfs::mount resource.
#
class fhgfs::basic_client (
  $version       = $fhgfs::version,
  $kernel_module = "puppet:///modules/fhgfs/${::kernelrelease}/${::beegfs_version}/rdma/fhgfs.ko",
) inherits fhgfs {

  package { 'fhgfs-helperd':
    ensure   => $version,
  }

  package { 'fhgfs-client':
    ensure   => $version,
  }

  service { 'fhgfs-helperd':
    ensure   => running,
    enable   => true,
    provider => redhat,
    require  => Package['fhgfs-helperd'],
  }

  service { 'fhgfs-client':
    ensure   => running,
    enable   => true,
    provider => redhat,
    require  => [ Package['fhgfs-client'], Service['fhgfs-helperd'], File['/var/lib/fhgfs/client/force-auto-build'], File["/lib/modules/${::kernelrelease}/updates/fs/fhgfs_autobuild/fhgfs.ko"] ],
  }

  file { '/var/lib/fhgfs/client/force-auto-build':
    ensure => absent,
  }

  file { [ "/lib/modules/${::kernelrelease}/updates/fs", "/lib/modules/${::kernelrelease}/updates/fs/fhgfs_autobuild" ]:
    ensure => directory,
    owner  => root,
    group  => root,
    mode   => '0755',
  }

  file { "/lib/modules/${::kernelrelease}/updates/fs/fhgfs_autobuild/fhgfs.ko":
    ensure => present,
    owner  => root,
    group  => root,
    mode   => '0644',
    source => $kernel_module,
  }

}
