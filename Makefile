post:
	bash _scripts/post.sh

git:
	git add --all
	git commit -a -m "`date`"
	git push
