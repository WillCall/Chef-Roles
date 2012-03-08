name "base"
description "Base role applied to all nodes."
run_list(
  "recipe[locale]",
  "recipe[hostname]",
  "recipe[chef-client::delete_validation]",
  "recipe[chef-client::config]",
  "recipe[chef-client::service]",
  "recipe[users::sysadmins]",
  "recipe[sudo]",
  "recipe[apt]",
  "recipe[git]",
  "recipe[build-essential]",
  "recipe[postfix]",
  "recipe[monit]",
  "recipe[monit::source]",
  "recipe[munin::client]",
  "recipe[newrelic-sysmond]",
  "recipe[remote_syslog]",
  "recipe[byobu]",
  "recipe[willcall::ec2_fix]",
  "recipe[oh-my-zsh]"
)
override_attributes(
  :authorization => {
    :sudo => {
      :users => ["ubuntu"],
      :passwordless => true
    }
  },
  :newrelic => {
    :license_key => "bfb2b704f5cd20f7d766e0f3c72cf726b50999f4"
  },
  :remote_syslog => {
    :server => "logs.papertrailapp.com",
    :port => "50982"
  },
  :tracelytics => {
    :access_key => "cbaf1a08-453f-49ed-aa06-af3358ee58e7"
  },
  :chef_client => {
    :init_style => "runit"
  },
  :ohai => {
    :plugin_path => "/etc/chef/ohai_plugins"
  },
  :monit => {
    :notify_email => "ptescher@getwillcall.com",
    :mail_format => {
      :from => "monit@getwillcall.com"
    }
  }
)
