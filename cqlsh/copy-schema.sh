#!/bin/bash

set -x

usage() { 
    echo 'Usage: copy-schmea src_keyspace dest_keyspace'
}

# required

if [ -z $1 ]; then
    echo 'Must have a src_keyspace'
    usage
    exit    
fi

src_keyspace=$1

if [ -z $2 ]; then
    echo 'no dest keyspace, no rename'
    dest_keyspace=$1
else
    dest_keyspace=$2
fi

# export
cqlsh -e "DESC KEYSPACE $src_keyspace" > /tmp/$src_keyspace.cql

# rename
sed "s/$src_keyspace/$dest_keyspace/" < "/tmp/$src_keyspace.cql" > "/tmp/$dest_keyspace.cql"

# import
cqlsh -e "source '/tmp/$dest_keyspace.cql'"
