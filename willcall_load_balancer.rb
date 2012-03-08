name "willcall_load_balancer"
description "Load balancer for *.getwillcall.com, etc"
run_list(
  "recipe[willcall::execjs]",
  "recipe[application]",
  "recipe[haproxy::app_lb]",
  "recipe[varnish]",
  "recipe[willcall::nginx]"
)
override_attributes(
  :haproxy => {
    :app_server_role => "willcall_app_server",
    :port => "8088",
    :contimeout => "4000",
    :clitimeout => "150000",
    :srvtimeout => "120000",
    :errorfiles_dir => "/srv/willcall/current/public",
    :syslog_host => "logs.papertrailapp.com:50982"
  },
  :remote_syslog => {
    :files => ["/var/log/nginx/*.log"]
  }
)