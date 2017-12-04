#!/bin/bash

cd "$DIR"
bash <(sed -n ''"$FROM"',$p' "$DIR/vm$ID.sh")
