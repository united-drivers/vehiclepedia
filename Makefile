.PHONY: serve
serve:
	jekyll serve

.PHONY: build
build:
	jekyll build

.PHONY: deploy
deploy: build
	cd _site && git init
	echo "vehiclepedia.united-drivers.org" > _site/CNAME
	touch _site/.nojekyll
	cd _site && git add .
	cd _site && git commit -am "Deploy"
	cd _site && git push "git@github.com:united-drivers/vehiclepedia" "master:gh-pages" --force
	cd _site && rm -rf .git
