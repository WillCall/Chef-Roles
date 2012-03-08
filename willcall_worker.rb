name "willcall_worker"
description "WillCall worker app"
run_list(
  "role[willcall_db_client]",
  "recipe[application]"
  "recipe[delayed_job]"
)