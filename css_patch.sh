#!/bin/bash
FILE="frontend/src/assets/styles/main.css"

# Replace colors to a more sophisticated Indigo/Slate palette
sed -i 's/--color-primary: #3b82f6;/--color-primary: #4f46e5; \/* Deep Indigo *\//g' $FILE
sed -i 's/--color-primary-light: #60a5fa;/--color-primary-light: #818cf8;/g' $FILE
sed -i 's/--color-primary-dark: #2563eb;/--color-primary-dark: #3730a3;/g' $FILE
sed -i 's/--color-primary-bg: #eff6ff;/--color-primary-bg: #e0e7ff;/g' $FILE

# Refine gray scale to a cooler, more premium slate gray
sed -i 's/--bg-secondary: #f9fafb;/--bg-secondary: #f8fafc; \/* Premium Slate Gray *\//g' $FILE
sed -i 's/--text-primary: #111827;/--text-primary: #0f172a;/g' $FILE
sed -i 's/--text-secondary: #4b5563;/--text-secondary: #475569;/g' $FILE
sed -i 's/--text-muted: #9ca3af;/--text-muted: #94a3b8;/g' $FILE
sed -i 's/--border-color: #e5e7eb;/--border-color: #e2e8f0;/g' $FILE
sed -i 's/--border-color-light: #f3f4f6;/--border-color-light: #f1f5f9;/g' $FILE

# Upgrade box shadows to be more layered and 'pro'
sed -i 's/--shadow-sm: 0 1px 2px 0 rgba(0, 0, 0, 0.05);/--shadow-sm: 0 1px 2px rgba(0, 0, 0, 0.03), 0 1px 3px rgba(0, 0, 0, 0.02);/g' $FILE
sed -i 's/--shadow-md: 0 4px 6px -1px rgba(0, 0, 0, 0.05), 0 2px 4px -2px rgba(0, 0, 0, 0.05);/--shadow-md: 0 2px 4px rgba(0, 0, 0, 0.02), 0 8px 16px rgba(0, 0, 0, 0.03);/g' $FILE
sed -i 's/--shadow-lg: 0 10px 15px -3px rgba(0, 0, 0, 0.05), 0 4px 6px -4px rgba(0, 0, 0, 0.05);/--shadow-lg: 0 4px 6px rgba(0, 0, 0, 0.02), 0 12px 24px rgba(0, 0, 0, 0.04), 0 24px 48px rgba(0, 0, 0, 0.04);/g' $FILE

