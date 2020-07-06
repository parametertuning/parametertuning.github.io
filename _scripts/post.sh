#!/bin/bash

POSTFILE=$(date "+_posts/%Y-%m-%d-twitter2.md")

newfile() {
    if [ -f $POSTFILE ]; then
        return
    fi

    cat <<HEADER > $POSTFILE
---
title: Twitter2 - $(date "+%Y-%m-%d")
author: cdddar
---

HEADER
}

makepost() {
    TMP=$(mktemp)
    cat <<SUBHEADER > $TMP
## $(date "+%H:%M:%S")

Clear buffer to cancel.

SUBHEADER
    EDITOR=${EDITOR:-vim}
    $EDITOR $TMP
    if [ -s $TMP ]; then
        cat $TMP >> $POSTFILE
        echo "Added to $POSTFILE"
    else
        echo "Canceled"
    fi
    rm $TMP
}

newfile
makepost
