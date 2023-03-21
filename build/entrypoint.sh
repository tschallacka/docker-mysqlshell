#!/usr/bin/env sh
echo "Usage: docker run --volume yourdatadir:/data mysqlshell [OPTIONS] [SCRIPT]"
echo "Running mysqlsh $@"
mysqlsh "$@"