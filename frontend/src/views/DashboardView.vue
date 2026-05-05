<template>
  <div class="dashboard">
    <div class="page-header">
      <div>
        <h1>Dashboard</h1>
        <p>Welcome back! Here's your sales overview.</p>
      </div>
    </div>

    <LoadingSpinner v-if="loading" />

    <template v-else>
      <!-- Stats Cards -->
      <div class="stats-grid">
        <div class="card stat-card" v-for="stat in statsCards" :key="stat.label">
          <div class="stat-icon">{{ stat.icon }}</div>
          <div class="stat-info">
            <span class="stat-value">{{ stat.value }}</span>
            <span class="stat-label">{{ stat.label }}</span>
          </div>
          <div class="stat-change" :class="stat.changeClass" v-if="stat.change">
            {{ stat.change }}
          </div>
        </div>
      </div>

      <!-- Charts & Recent Sales -->
      <div class="grid-2">
        <div class="card">
          <h3 class="card-title">Revenue Trend</h3>
          <div class="chart-container">
            <canvas ref="revenueChart"></canvas>
          </div>
        </div>

        <div class="card">
          <h3 class="card-title">Recent Sales</h3>
          <table class="data-table">
            <thead>
              <tr>
                <th>Order</th>
                <th>Customer</th>
                <th>Amount</th>
                <th>Status</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="sale in recentSales" :key="sale.id">
                <td class="text-primary font-medium">{{ sale.order_id }}</td>
                <td>{{ sale.customer_name || 'N/A' }}</td>
                <td class="text-primary font-semibold">Rs. {{ formatNumber(sale.total_amount) }}</td>
                <td><StatusBadge :status="sale.status" /></td>
              </tr>
              <tr v-if="!recentSales.length">
                <td colspan="4" class="text-center text-muted">No sales yet</td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>

      <!-- Top Products -->
      <div class="card mt-3">
        <h3 class="card-title">Top Selling Products</h3>
        <table class="data-table">
          <thead>
            <tr>
              <th>#</th>
              <th>Product</th>
              <th>SKU</th>
              <th>Category</th>
              <th>Qty Sold</th>
              <th>Revenue</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="(p, i) in topProducts" :key="p.product_id">
              <td>{{ i + 1 }}</td>
              <td class="text-primary text-medium">{{ p.product_name }}</td>
              <td class="text-muted">{{ p.product_sku }}</td>
              <td>{{ p.category }}</td>
              <td>{{ p.total_qty_sold }}</td>
              <td class="text-success font-semibold">Rs. {{ formatNumber(p.total_revenue) }}</td>
            </tr>
          </tbody>
        </table>
      </div>
    </template>
  </div>
</template>

<script>
import { Chart, registerables } from 'chart.js'
import { useReportsStore } from '../stores/reports'
import { useSalesStore } from '../stores/sales'
import StatusBadge from '../components/common/StatusBadge.vue'
import LoadingSpinner from '../components/common/LoadingSpinner.vue'

Chart.register(...registerables)

export default {
  name: 'DashboardView',
  components: { StatusBadge, LoadingSpinner },
  data() {
    return { loading: true, recentSales: [], topProducts: [], chartInstance: null }
  },
  computed: {
    statsCards() {
      const d = useReportsStore().dashboard
      if (!d) return []
      return [
        { icon: '💰', label: 'Total Revenue', value: `Rs. ${this.formatNumber(d.total_revenue)}`, change: d.revenue_growth ? `${d.revenue_growth > 0 ? '+' : ''}${d.revenue_growth.toFixed(1)}%` : null, changeClass: d.revenue_growth >= 0 ? 'positive' : 'negative' },
        { icon: '📦', label: 'Total Sales', value: d.total_sales, change: d.sales_growth ? `${d.sales_growth > 0 ? '+' : ''}${d.sales_growth.toFixed(1)}%` : null, changeClass: d.sales_growth >= 0 ? 'positive' : 'negative' },
        { icon: '⏳', label: 'Pending Orders', value: d.pending_orders },
        { icon: '📊', label: 'Avg. Order Value', value: `Rs. ${this.formatNumber(d.average_order_value)}` },
      ]
    }
  },
  methods: {
    formatNumber(n) {
      return Number(n || 0).toLocaleString('en-US', { minimumFractionDigits: 2, maximumFractionDigits: 2 })
    },
    renderChart() {
      const rev = useReportsStore().revenue
      if (!rev?.revenue_by_period?.length) return

      const labels = rev.revenue_by_period.map(r => r.period).reverse()
      const data = rev.revenue_by_period.map(r => r.revenue).reverse()

      if (this.chartInstance) this.chartInstance.destroy()

      const ctx = this.$refs.revenueChart?.getContext('2d')
      if (!ctx) return

      const gradient = ctx.createLinearGradient(0, 0, 0, 300)
      gradient.addColorStop(0, 'rgba(15, 23, 42, 0.1)')
      gradient.addColorStop(1, 'rgba(15, 23, 42, 0.0)')

      this.chartInstance = new Chart(ctx, {
        type: 'line',
        data: {
          labels,
          datasets: [{
            label: 'Revenue (Rs.)',
            data,
            borderColor: '#6366f1',
            backgroundColor: gradient,
            borderWidth: 2,
            fill: true,
            tension: 0.4,
            pointBackgroundColor: '#6366f1',
            pointBorderColor: '#fff',
            pointBorderWidth: 2,
            pointRadius: 4,
            pointHoverRadius: 6
          }]
        },
        options: {
          responsive: true,
          maintainAspectRatio: false,
          plugins: {
            legend: { display: false },
            tooltip: {
              backgroundColor: 'rgba(17,24,39,0.9)',
              titleColor: '#f1f5f9',
              bodyColor: '#94a3b8',
              borderColor: 'rgba(255,255,255,0.1)',
              borderWidth: 1,
              cornerRadius: 8,
              padding: 12
            }
          },
          scales: {
            x: {
              ticks: { color: '#64748b', font: { size: 11 } },
              grid: { color: 'rgba(255,255,255,0.04)' }
            },
            y: {
              ticks: { color: '#64748b', font: { size: 11 }, callback: v => `Rs. ${(v/1000).toFixed(0)}K` },
              grid: { color: 'rgba(255,255,255,0.04)' }
            }
          }
        }
      })
    }
  },
  async mounted() {
    const reports = useReportsStore()
    const sales = useSalesStore()
    try {
      await Promise.all([
        reports.fetchDashboard(),
        reports.fetchRevenue(),
        reports.fetchTopProducts(5),
        sales.fetchSales(1)
      ])
      this.recentSales = (sales.sales || []).slice(0, 8)
      this.topProducts = reports.topProducts || []
      this.$nextTick(() => this.renderChart())
    } finally {
      this.loading = false
    }
  },
  beforeUnmount() {
    if (this.chartInstance) this.chartInstance.destroy()
  }
}
</script>

<style scoped>
.stat-card {
  display: flex;
  align-items: center;
  gap: 16px;
  padding: 22px 24px;
}

.stat-icon {
  font-size: 2rem;
  width: 50px;
  height: 50px;
  display: flex;
  align-items: center;
  justify-content: center;
  background: var(--bg-glass);
  border-radius: var(--radius-md);
}

.stat-info {
  flex: 1;
  display: flex;
  flex-direction: column;
}

.stat-value {
  font-size: 1.4rem;
  font-weight: 700;
  color: var(--text-primary);
  animation: countUp 0.5s ease;
}

.stat-label {
  font-size: 0.8rem;
  color: var(--text-muted);
  margin-top: 2px;
}

.stat-change {
  font-size: 0.8rem;
  font-weight: 600;
  padding: 4px 10px;
  border-radius: 20px;
}

.stat-change.positive { background: var(--color-success-bg); color: var(--color-success); }
.stat-change.negative { background: var(--color-danger-bg); color: var(--color-danger); }

.card-title {
  font-size: 1rem;
  font-weight: 600;
  margin-bottom: 20px;
  color: var(--text-primary);
}

.chart-container {
  height: 280px;
  position: relative;
}
</style>
