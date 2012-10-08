DEST=../build

all: publish init config permissions

publish: 
	emacs --script elisp/publish.el

init:
	(mkdir -p ${DEST}/css ${DEST}/html ${DEST}/js ${DEST}/php ${DEST}/python ${DEST}/tmp ${DEST}/test)

config:
	rsync -avC html/index.html ${DEST}/index.html
	rsync -avC js ${DEST}
	rsync -avC php ${DEST}
	rsync -avC python ${DEST}
	rsync -avC experiments/code/test ${DEST}

permissions:
	chmod 755 -R ${DEST}/
	chmod 777 ${DEST}/tmp
	chmod 777 -R ${DEST}/test
 
local: permissions
	sudo rsync -av ${DEST}/ /var/www/build

export: permissions
	rsync -av ${DEST}/ cse05@devel.virtual-labs.ac.in:./public_html/final-build

code-export: clean all
	mkdir -p ${DEST}/${code-export-filename}/
	rsync -avC code ${DEST}/${code-export-filename}/
	(cd ${DEST}; tar -cvzf ${code-export-filename}.tgz ${code-export-filename}/)
	scp ${DEST}/${code-export-filename}.tgz pascal.iiit.ac.in:/var/www/popl/code/

clean:
	rm -rf ${DEST}
	sudo rm -rf /var/www/build
