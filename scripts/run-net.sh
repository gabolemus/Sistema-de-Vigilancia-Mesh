#!/bin/bash
cd src-net && make && cd .. && trap "exit \$?" INT && ./exe/mesh-net-surveillance && exit \$?
