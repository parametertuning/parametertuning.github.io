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
excerpt: Tweets of the Day

---

HEADER
}

makepost() {
    TMP=$(mktemp)
    cat <<SUBHEADER > $TMP
## $(date "+%H:%M:%S")

Clear buffer and exit to cancel.

<!-- vim: set ft=markdown: -->
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
