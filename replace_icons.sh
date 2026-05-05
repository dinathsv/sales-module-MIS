#!/bin/bash

# Update Sidebar icons
SIDEBAR="frontend/src/components/layout/AppSidebar.vue"
sed -i "s/<div class=\"logo-icon\">📊<\/div>/<div class=\"logo-icon\"><i class='bx bx-star' style='color: var(--color-primary);'><\/i><\/div>/g" $SIDEBAR

# Update navItems in Sidebar
sed -i "s/{ path: '\/', label: 'Dashboard', icon: '🏠' }/{ path: '\/', label: 'Dashboard', icon: 'bx bx-home-alt' }/g" $SIDEBAR
sed -i "s/{ path: '\/sales', label: 'Sales', icon: '💰' }/{ path: '\/sales', label: 'Sales', icon: 'bx bx-dollar-circle' }/g" $SIDEBAR
sed -i "s/{ path: '\/invoices', label: 'Invoices', icon: '📄' }/{ path: '\/invoices', label: 'Invoices', icon: 'bx bx-file-blank' }/g" $SIDEBAR
sed -i "s/{ path: '\/customers', label: 'Customers', icon: '👥' }/{ path: '\/customers', label: 'Customers', icon: 'bx bx-group' }/g" $SIDEBAR
sed -i "s/{ path: '\/reports', label: 'Reports', icon: '📈' }/{ path: '\/reports', label: 'Reports', icon: 'bx bx-line-chart' }/g" $SIDEBAR

sed -i "s/{{ item.icon }}/<i :class=\"item.icon\"><\/i>/g" $SIDEBAR
sed -i "s/{{ collapsed ? '▶' : '◀' }}/<i :class=\"collapsed ? 'bx bx-chevron-right' : 'bx bx-chevron-left'\"><\/i>/g" $SIDEBAR


# Update Dashboard stats
DASH="frontend/src/views/DashboardView.vue"
sed -i "s/icon: '💰'/icon: 'bx bx-wallet'/g" $DASH
sed -i "s/icon: '📦'/icon: 'bx bx-box'/g" $DASH
sed -i "s/icon: '⏳'/icon: 'bx bx-time-five'/g" $DASH
sed -i "s/icon: '📊'/icon: 'bx bx-bar-chart-square'/g" $DASH
sed -i "s/{{ stat.icon }}/<i :class=\"stat.icon\" style=\"color: var(--color-primary);\"><\/i>/g" $DASH

