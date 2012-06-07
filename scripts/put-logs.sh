#!/bin/bash

rmdir -p $LOGS_DIR/* >/dev/null 2>&1 # remove empty dirs
rm -rf $PREFIX/logs
cp -rf $LOGS_DIR $PREFIX/logs
rm -f $(find $PREFIX/logs -type f -name download.log -or -name uncompress.log -or -name patch-*.log)
