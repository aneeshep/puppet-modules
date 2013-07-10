# == Class: tomcat
#
# Full description of class tomcat here.
#
# === Parameters
#
# Document parameters here.
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the funtion of this class and if it
#   has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should not be used in preference to class parameters  as of
#   Puppet 2.6.)
#
# === Examples
#
#  class { tomcat:
#    servers => [ 'pool.ntp.org', 'ntp.local.company.com' ]
#  }
#
# === Authors
#
# Author Name <author@domain.com>
#
# === Copyright
#
# Copyright 2013 Your name here, unless otherwise noted.
#
class imaginea-tomcat {


  file {'java-jdk-7' :
          path => '/tmp/java-jdk.tar.gz',
          ensure => present,
          source => 'puppet:///files/jdk-7u25-linux-x64.tar.gz'
          
       }
       
  exec { "tar -xzf /tmp/java-jdk.tar.gz":
          cwd     => "/tmp",
          path    => ["/usr/bin", "/usr/sbin", "/bin"],
          require => File['java-jdk-7']
       }
       
  file { 'java_home_config' :
          path  => '/etc/profile.d/java_jdk.sh',
          content => 'export JAVA_HOME=/tmp/jdk1.7.0_25',
          require => Exec['tar -xzf /tmp/java-jdk.tar.gz'],
        }
        
  
  

  archive { 'apache-tomcat-6.0.26':
    ensure => present,
    url    => 'http://archive.apache.org/dist/tomcat/tomcat-6/v6.0.26/bin/apache-tomcat-6.0.26.tar.gz',
    target => '/opt',
    require => File['java_home_config']
  }
  
  exec { "/opt/apache-tomcat-6.0.26/bin/startup.sh":
    cwd     => "/opt",
    environment => "JAVA_HOME=/tmp/jdk1.7.0_25",
    path    => ["/usr/bin", "/bin"],
    require => Archive['apache-tomcat-6.0.26']
  }

}
