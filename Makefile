serve:
	jekyll serve

build:
	jekyll build

commit:
	git add .
	git commit

upload: 
	rsync -e "ssh" -avz _site/ martinjacobd_jacobmartin@ssh.phx.nearlyfreespeech.net:/home/public/
