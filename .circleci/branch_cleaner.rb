require "time"

# 1 hour
HOUR_SEC = 60 * 60

`git for-each-ref --sort='-*committerdate' --format="%(refname:short) %(committerdate:raw)" refs/remotes/origin/smoke_test/`.each_line.map do |line|
  branch_name, unixtime, _ = *line.strip.split(" ")
  [branch_name.gsub("origin/", ""), Time.at(unixtime.to_i)]
end.select do |_branch_name, committer_at|
  # Remove old branch
  Time.now - committer_at > HOUR_SEC * 12
end.each do |branch_name, _committer_at|
  system "git push --delete origin #{branch_name}"
end
