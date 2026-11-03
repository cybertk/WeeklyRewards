WOW_ROOT_DIR ?= /mnt/d
boot:
	cp -r $(WOW_ROOT_DIR)/World\ of\ Warcraft/_retail_/Interface/AddOns/WeeklyRewards/Embeds .
	cp -r $(WOW_ROOT_DIR)/World\ of\ Warcraft/_retail_/Interface/AddOns/WeeklyRewards/Libs .

format:
	stylua --glob "**/*.lua" --glob "!Locales/" .
	git grep "print" -- "**/*.lua" WeeklyRewards.lua Util.lua

build:
	curl https://raw.githubusercontent.com/BigWigsMods/packager/refs/heads/master/release.sh | bash -

minify: .github/scripts/minify_lua.py
	python3 .github/scripts/minify_lua.py --tracked

.github/scripts/minify_lua.py:
	mkdir -p .github/scripts
	curl -fsSL -o .github/scripts/minify_lua.py https://raw.githubusercontent.com/cybertk/minify-lua/v1/minify_lua.py
