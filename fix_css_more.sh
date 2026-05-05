#!/bin/bash
FILE="frontend/src/assets/styles/main.css"
sed -i 's/\.stat-value {/.stat-value {\n  white-space: nowrap;\n  overflow: hidden;\n  text-overflow: ellipsis;/g' $FILE
