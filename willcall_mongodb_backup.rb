name "willcall_mongodb_backup"
description "Backup MongoDB database server"

run_list(
  "recipe[willcall::mongodb_backup]"
)
