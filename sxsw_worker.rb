name "sxsw_worker"
description "sxsw worker app"
run_list(
  "role[base]",
  "recipe[application]",
  "recipe[delayed_job]"
)