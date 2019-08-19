#!/bin/bash
ulimit -S -n 20000
siege -c 1000 -t 1 -b http:www.my.com/test/test.php
