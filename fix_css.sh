#!/bin/bash
FILE="frontend/src/assets/styles/main.css"

# Change primary color to Light Blue
sed -i 's/--color-primary: #4f46e5; \/\* Deep Indigo \*\//--color-primary: #0ea5e9; \/\* Light Sky Blue \*\//g' $FILE
sed -i 's/--color-primary-light: #818cf8;/--color-primary-light: #38bdf8;/g' $FILE
sed -i 's/--color-primary-dark: #3730a3;/--color-primary-dark: #0284c7;/g' $FILE
sed -i 's/--color-primary-bg: #e0e7ff;/--color-primary-bg: #e0f2fe;/g' $FILE

# Fix the stat-value sizing that makes it chunky
sed -i 's/\.stat-value {/.stat-value {/g' $FILE
sed -i 's/font-size: 1.8rem;/font-size: 1.25rem;/g' $FILE
sed -i 's/font-size: 2.2rem;/font-size: 1.5rem;/g' $FILE
sed -i 's/width: 60px;/width: 48px;/g' $FILE
sed -i 's/height: 60px;/height: 48px;/g' $FILE

