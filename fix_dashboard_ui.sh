#!/bin/bash
FILE="frontend/src/views/DashboardView.vue"

# Reduce padding on the card
sed -i 's/padding: 16px 20px;/padding: 14px 16px;/g' $FILE

# Smaller icon
sed -i 's/font-size: 1.5rem;/font-size: 1.2rem;/g' $FILE
sed -i 's/width: 42px;/width: 36px;/g' $FILE
sed -i 's/height: 42px;/height: 36px;/g' $FILE

# Smaller text
sed -i 's/font-size: 1.25rem;/font-size: 1.1rem;/g' $FILE
sed -i 's/font-size: 0.8rem;/font-size: 0.7rem;/g' $FILE
sed -i 's/margin-top: 2px;/margin-top: 0px;/g' $FILE

# Fix the pill badge size
sed -i 's/padding: 4px 10px;/padding: 2px 8px;/g' $FILE

