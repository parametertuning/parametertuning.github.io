post:
	bash _scripts/post.sh

edit:
	vim $(shell ls -1 _posts/*.md | tac | peco)

git:
	git add --all
	git commit -a -m "`date`"
	git push
