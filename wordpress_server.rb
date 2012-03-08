name "wordpress_server"
description "Installs wordpress"
run_list(
  "recipe[wordpress::default]",
  "recipe[newrelic-sysmond::php]"
)

override_attributes(
  :wordpress => {
    :server_aliases => ["blog.getwillcall.com"],
    :checksum => "21e3cebd02808f9ee39a979d22e6e10bce5356ddf7068aef182847b12c9b95a9",
    :version => "3.3"
  }, 
  :remote_syslog => {
    :files => ["/var/log/apache2/wordpress-error.log","/var/log/apache2/wordpress-access.log"]
  }
)
