#!/bin/bash
ulimit -S -n 20000
siege -c 700 -t 20 -b -f web.txt
