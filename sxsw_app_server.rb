name "sxsw_app_server"
description "Rails + unicorn + nginx + SXSW web application"
run_list(
  "role[base]",
  "recipe[willcall::execjs]",
  "recipe[application]",
)


after_fork_stuff = <<EOF
  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.establish_connection
EOF

before_fork_stuff = <<EOF
  ##
  # When sent a USR2, Unicorn will suffix its pidfile with .oldbin and
  # immediately start loading up a new version of itself (loaded with a new
  # version of our app). When this new Unicorn is completely loaded
  # it will begin spawning workers. The first worker spawned will check to
  # see if an .oldbin pidfile exists. If so, this means we've just booted up
  # a new Unicorn and need to tell the old one that it can now die. To do so
  # we send it a QUIT.
  #
  # Using this method we get 0 downtime deploys.

  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.connection.disconnect!

  old_pid = "\#{server.config[:pid]}.oldbin"
  if old_pid != server.pid
    begin
      sig = (worker.nr + 1) >= server.worker_processes ? :QUIT : :TTOU
      Process.kill(sig, File.read(old_pid).to_i)
      puts "Killed process \#{File.read(old_pid).to_i.to_s}"
    rescue Errno::ENOENT, Errno::ESRCH
      #Our work is already done
    end
  end  
  
EOF

override_attributes(
  :unicorn => {
    :preload_app => true,
    :before_fork => before_fork_stuff,
    :after_fork => after_fork_stuff
  }
)
