name "willcall_mongodb_server"
description "MongoDB Database server"

run_list(
  "recipe[willcall::mongodb]",
  "recipe[python]",
  "recipe[runit]",
  "recipe[mms-agent]"
)

override_attributes(
  :mongodb => {
    :dbpath => "/srv/willcall/data",
    :logpath => "/srv/willcall/shared/log",
    :client_role => "willcall_db_client",
    :cluster_name => "willcall"
  },
  # for mms-agent
  :mms_agent => {
    :api_key => '9922ed25c82d6917b68fd3642d06e58b',
    :secret_key => 'fc8fbeff702d4379f076ac2db459a812'
  }
  
)