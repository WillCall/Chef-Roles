name "monitoring"
description "The monitoring server"
run_list(
  "recipe[munin::server]"
)
override_attributes(
  :munin => {
    :sysadmin_email => "alerts@getwillcall.com",
    :server_auth_method => "basic"
  }
)
