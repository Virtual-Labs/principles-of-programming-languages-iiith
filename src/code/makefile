SHELL=bash
tmp-dir=/tmp
popl-dir=${tmp-dir}/popl
build-dir=${popl-dir}/build
code-dir=${popl-dir}/code
date=$(shell expr `date +%F-%H-%M`)
code-export-filename=${date}-code
code-export-dir=${build-dir}/${code-export-filename}
login=choppell

all: init build

foo:
	(echo ${date};  sleep 5; echo ${date})

init:   clean
	(mkdir -p ${popl-dir}; svn co svn+ssh://${login}@pascal.iiit.ac.in/home/choppell/svn/projects/popl-vlab/src/code ${code-dir})

build:  init
	(mkdir -p ${code-export-dir})
	(rsync -avC ${code-dir} --exclude="makefile" --exclude="HOW-TO-BUILD" ${code-export-dir}/)
	(cd ${build-dir}; tar -cvzf ${code-export-filename}.tgz ${code-export-filename}/)

export: all
	(scp ${build-dir}/${code-export-filename}.tgz pascal.iiit.ac.in:/var/www/popl/code/)

clean:
	\rm -rf ${popl-dir}
