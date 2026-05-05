#!/bin/bash
FILE="frontend/src/assets/styles/main.css"

# Change primary color to Normal Blue (Standard SaaS Blue)
sed -i 's/--color-primary: #0ea5e9; \/\* Light Sky Blue \*\//--color-primary: #2563eb; \/\* Standard Blue \*\//g' $FILE
sed -i 's/--color-primary-light: #38bdf8;/--color-primary-light: #60a5fa;/g' $FILE
sed -i 's/--color-primary-dark: #0284c7;/--color-primary-dark: #1d4ed8;/g' $FILE
sed -i 's/--color-primary-bg: #e0f2fe;/--color-primary-bg: #eff6ff;/g' $FILE

