WOW_ROOT_DIR ?= /mnt/d
boot:
	cp -r $(WOW_ROOT_DIR)/World\ of\ Warcraft/_retail_/Interface/AddOns/WeeklyRewards/Embeds .
	cp -r $(WOW_ROOT_DIR)/World\ of\ Warcraft/_retail_/Interface/AddOns/WeeklyRewards/Libs .
format:
	stylua --glob "**/*.lua" --glob "!Locales/" .
	git grep "print" -- "**/*.lua"

build:
	curl https://raw.githubusercontent.com/BigWigsMods/packager/refs/heads/master/release.sh | bash -
