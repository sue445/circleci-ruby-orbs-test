require "time"

# 1 hour
HOUR_SEC = 60 * 60

def system!(command)
  puts command
  ret = system(command)
  raise "`#{command}` is failed" unless ret
end

`git for-each-ref --sort='-*committerdate' --format="%(refname:short) %(committerdate:raw)" refs/remotes/origin/smoke_test/`.each_line.map do |line|
  branch_name, unixtime, _ = *line.strip.split(" ")
  [branch_name.gsub("origin/", ""), unixtime.to_i]
end.select do |_branch_name, unixtime|
  # Remove old branch
  Time.now - Time.at(unixtime) > HOUR_SEC * 12
end.each do |branch_name, _unixtime|
  system!("git push --delete origin #{branch_name}")
end
