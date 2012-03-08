name "aws"
description "Role applied to all aws nodes."
run_list()
override_attributes(
  :monit => {
    :mmonit_server_host => "10.1.0.37",
    :mmonit_server_port => "8080",
    :mmonit_server_username => "monit",
    :mmonit_server_password => "monit",
    :notify_email => "ptescher@getwillcall.com",
    :mail_format => {
      :from => "monit@getwillcall.com"
    }
  }
)
