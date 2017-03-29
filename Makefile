.PHONY: serve
serve:
	bundle exec jekyll serve

.PHONY: deps
deps:
	npm install -g cloudflare-cli
	bundle
	#brew install bower
	#bower install

.PHONY: build
build:
	bundle exec jekyll build

.PHONY: deploy
deploy: build
	cd _site && git init
	echo "vehiclepedia.united-drivers.org" > _site/CNAME
	touch _site/.nojekyll
	cd _site && git add .
	cd _site && git commit -am "Deploy"
	cd _site && git push "git@github.com:united-drivers/vehiclepedia" "master:gh-pages" --force
	cd _site && rm -rf .git
	cfcli -d united-drivers.org purge || true
