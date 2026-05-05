#!/bin/bash
FILE="frontend/src/assets/styles/main.css"

# Typography tweaks: tighter tracking on headings, sleeker base font
sed -i 's/body {/body {\n  letter-spacing: -0.01em;/g' $FILE
sed -i 's/h1, h2, h3, h4, h5, h6 {/h1, h2, h3, h4, h5, h6 {\n  letter-spacing: -0.025em;/g' $FILE

# Update card styles specifically to look refined, not bloated
sed -i 's/box-shadow: var(--shadow-sm);/box-shadow: var(--shadow-md);/g' $FILE
sed -i 's/border: 1px solid var(--border-color);/border: 1px solid var(--border-color-light);/g' $FILE

# Update button standard to have subtle lift and better shadow
sed -i 's/font-weight: 500;/font-weight: 600;/g' $FILE

