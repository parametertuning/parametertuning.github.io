#!/bin/bash

POSTFILE=$(date "+_posts/%Y-%m-%d-twitter2.md")

newfile() {
    if [ -f $POSTFILE ]; then
        return
    fi

    cat <<HEADER > $POSTFILE
---
title: $(date "+%Y-%m-%d")
author: cdddar
excerpt: Tweets of the Day

---

HEADER
}

postprocessing() {
    TMP_POSTFILE=$(mktemp)
    cat $POSTFILE |
        awk 'last!=""||$0!="";{last=$0}' | # empty lines trim
        ruby _scripts/link.rb |
        cat > $TMP_POSTFILE
    mv $TMP_POSTFILE $POSTFILE
}

makepost() {
    TMP=$(mktemp)
    cat <<SUBHEADER > $TMP
### $(date "+%H:%M:%S")

<!-- Clear buffer and exit to cancel. -->
<!-- vim: set ft=markdown: -->
SUBHEADER
    EDITOR=${EDITOR:-vim}
    $EDITOR $TMP
    if [ -s $TMP ]; then
        echo >> $POSTFILE
        sed 's/<!--[^>]*-->//g' $TMP >> $POSTFILE
        postprocessing
        echo "Added to $POSTFILE"
    else
        echo "Canceled"
    fi
    rm $TMP
}

post-from-file() {
    cat <<SUBHEADER >> $POSTFILE

### $(date "+%H:%M:%S")

SUBHEADER
    cat "$1" >> $POSTFILE
    echo >> $POSTFILE
    postprocessing
}

newfile

if [ $# -eq 0 ]; then
    makepost
else
    echo "$1" >&2
    cat "$1" >&2
    post-from-file "$1"
fi
