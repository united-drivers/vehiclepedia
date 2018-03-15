DEPS = themes/docdock/README.md node_modules/.bin/hugo

.PHONY: dev
dev: $(DEPS)
	npm start

.PHONY: build
build: $(DEPS)
	npm run build

.PHONY: minify
minify:
	npm run minify.html
	npm run minify.css
	npm run minify.js

node_modules/.bin/hugo: package.json
	npm install

themes/docdock/README.md:
	git submodule init
	git submodule update

.PHONY: deploy
deploy: build minify
	cd public && git init
	echo "vehiclepedia.united-drivers.org" > public/CNAME
	touch public/.nojekyll
	cd public && git add .
	cd public && git commit -am "Deploy"
	cd public && git push "git@github.com:united-drivers/vehiclepedia" "master:gh-pages" --force
	cd public && rm -rf .git
