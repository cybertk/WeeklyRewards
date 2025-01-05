format:
	stylua Core/ DB/ Modules/ WeeklyRewards.lua Util.lua

build:
	curl https://raw.githubusercontent.com/BigWigsMods/packager/refs/heads/master/release.sh | bash -
