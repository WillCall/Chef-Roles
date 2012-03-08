name "solo"
description "Base role applied to all solo nodes."
run_list(
  "recipe[users::sysadmins]",
  "recipe[locale]",
  "recipe[git]",
  "recipe[build-essential]"
)
override_attributes(
  :authorization => {
    :sudo => {
      :users => ["ubuntu"],
      :passwordless => true
    }
  }
)
