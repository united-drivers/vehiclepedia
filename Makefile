.PHONY: dev
dev: ./node_modules/.bin/hugo
	npm start

.PHONY: build
build:
	npm run build

./node_modules/.bin/hugo:
	npm install

.PHONY: deploy
deploy: build
	cd public && git init
	echo "vehiclepedia.united-drivers.org" > public/CNAME
	touch public/.nojekyll
	cd public && git add .
	cd public && git commit -am "Deploy"
	cd public && git push "git@github.com:united-drivers/vehiclepedia" "master:gh-pages" --force
	cd public && rm -rf .git
