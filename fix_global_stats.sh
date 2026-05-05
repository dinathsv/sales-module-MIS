#!/bin/bash
FILE="frontend/src/assets/styles/main.css"
sed -i 's/font-size: 1.25rem;/font-size: 1.1rem;/g' $FILE
sed -i 's/font-size: 1.5rem;/font-size: 1.2rem;/g' $FILE
sed -i 's/width: 48px;/width: 36px;/g' $FILE
sed -i 's/height: 48px;/height: 36px;/g' $FILE
sed -i 's/font-size: 0.85rem;/font-size: 0.7rem;/g' $FILE
