format:
	stylua --glob "**/*.lua" --glob "!Locales/" .

build:
	curl https://raw.githubusercontent.com/BigWigsMods/packager/refs/heads/master/release.sh | bash -
