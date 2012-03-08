name "willcall_app_server"
description "Rails + unicorn + nginx + WillCall web application"
run_list(
  "recipe[willcall::execjs]",
  "recipe[application]",
  "recipe[willcall::cron]",
  "role[willcall_db_client]"
)

after_fork_stuff = <<EOF
  ##
  # Unicorn master loads the app then forks off workers - because of the way
  # Unix forking works, we need to make sure we aren't using any of the parent's
  # sockets, e.g. db connection

  Mongoid.master.connection.connect 
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

  Mongoid.master.connection.close

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
