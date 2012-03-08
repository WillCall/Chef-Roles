name "willcall_scheduler"
description "Servers that run clockwork for scheduling"
run_list(
  "recipe[clockwork]",
)