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

trim() {
    TMP_POSTFILE=$(mktemp)
    cat $POSTFILE | awk 'last!=""||$0!="";{last=$0}' > $TMP_POSTFILE
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
        sed 's/<!--[^>]*-->//g' $TMP >> $POSTFILE
        trim
        echo "Added to $POSTFILE"
    else
        echo "Canceled"
    fi
    rm $TMP
}

newfile
makepost
