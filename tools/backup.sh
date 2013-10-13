#!/bin/bash

usage()
{
	echo "Usage: $0 sourcedir destdir"
}

if [ $# -ne 2 ]
then
	usage
	exit 1
fi

cd $1 && tar cvf - . | tar xvf - -C $2

# another method to do this job:
# find . -depth | xargs tar cvf -  | (cd /dest/dir && tar xvfp -)
# find . -depth | xargs tar cvf -  | \
	ssh machine_name `cd /dest ; mkdir dir ; tar xvfp -`
# find . -depth | cpio -dampv {/dest/dir}
# find . -depth | ssh machine_name `cpio -dampv /dest/dir`
# rsync -av -e ssh user@remotehost:/src/dir/ /localhost/dest/dir/
# tar cvfz /mnt/nfs/wholedisk.tar/gz / --excelude /proc/* \
#	--exclude /mnt/nfs/*
