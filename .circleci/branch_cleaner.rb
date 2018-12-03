require "time"

BRANCH_KEEP_HOURS = (ARGV[0] || 12).to_i

# 1 hour
HOUR_SEC = 60 * 60

`git for-each-ref --sort='-*committerdate' --format="%(refname:short) %(committerdate:raw)" refs/remotes/origin/smoke_test/`.each_line.map do |line|
  branch_name, unixtime, _ = *line.strip.split(" ")
  [branch_name.gsub("origin/", ""), Time.at(unixtime.to_i)]
end.select do |_branch_name, committer_at|
  # Remove old branch
  Time.now - committer_at > HOUR_SEC * BRANCH_KEEP_HOURS
end.each do |branch_name, _committer_at|
  system "git push --delete origin #{branch_name}"
end
