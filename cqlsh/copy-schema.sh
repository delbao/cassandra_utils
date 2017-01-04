#!/bin/bash

set -x

usage() { 
    echo 'Usage:'
    echo -e ' copy-schmea [options] src_keyspace dest_keyspace\n'
    echo 'Options:'
    echo ' -h <hostname> src hostname default: localhost'
}

# bash variable has no default value
hflag=false
options=':h:' # preceding colon(:) slience error reporting
             # after colon(:) expect argument 
while getopts $options option; do
    case "${option}" in
        h) 
            hflag=true; harg="${OPTARG}"
            ;;
        *) 
            usage
            exit
            ;;
    esac
done

shift $((OPTIND-1)) # remove all option args
 
# required
if [ -z $1 ]; then
    echo 'Must have a src_keyspace'
    usage
    exit    
fi

# hostname
if [ ! $hflag ]; then
    harg=localhost
fi

src_keyspace=$1

if [ -z $2 ]; then
    echo 'no dest keyspace, no rename'
    dest_keyspace=$1
else
    dest_keyspace=$2
fi

# export
cqlsh $harg -e "DESC KEYSPACE $src_keyspace" > /tmp/$src_keyspace.cql

# rename
if [ $src_keyspace != $dest_keyspace ]; then
    sed "s/$src_keyspace/$dest_keyspace/" < "/tmp/$src_keyspace.cql" > "/tmp/$dest_keyspace.cql"
fi

# import
cqlsh -e "source '/tmp/$dest_keyspace.cql'"
