format:
	stylua --glob "**/*.lua" .

build:
	curl https://raw.githubusercontent.com/BigWigsMods/packager/refs/heads/master/release.sh | bash -
