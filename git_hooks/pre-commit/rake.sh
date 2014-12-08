#!/usr/bin/env bash

case "$1" in 
  --help|-h|--about ) 
    echo "Run rake tests"
    exit 0
    ;;
esac

bundle exec rake
