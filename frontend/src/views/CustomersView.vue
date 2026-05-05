<template>
  <div class="customers-page">
    <div class="page-header">
      <div>
        <h1>Customers</h1>
        <p>Customer directory and sales history</p>
      </div>
    </div>

    <div class="filters-bar">
      <input v-model="search" type="text" class="form-control" placeholder="🔍 Search customers..." style="max-width:300px" />
    </div>

    <LoadingSpinner v-if="loading" />

    <template v-else>
      <div class="card">
        <table class="data-table">
          <thead>
            <tr>
              <th>Name</th>
              <th>Email</th>
              <th>Phone</th>
              <th>Company</th>
              <th>Total Sales</th>
              <th>Total Spent</th>
              <th>Actions</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="c in filteredCustomers" :key="c.id">
              <td class="text-primary font-medium">{{ c.name }}</td>
              <td class="text-muted">{{ c.email }}</td>
              <td class="text-muted">{{ c.phone }}</td>
              <td>{{ c.company || '-' }}</td>
              <td>{{ c.total_sales }}</td>
              <td class="text-success font-semibold">Rs. {{ fmt(c.total_spent) }}</td>
              <td>
                <button class="btn btn-ghost btn-sm" @click="viewHistory(c)">📜 History</button>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
    </template>

    <!-- Customer History Modal -->
    <Modal v-if="selectedCustomer" :title="`${selectedCustomer.name} — Sales History`" @close="selectedCustomer = null" maxWidth="800px">
      <div class="filters-bar mb-2">
        <select v-model="historyFilter.status" @change="loadHistory" class="form-control">
          <option value="">All Status</option>
          <option value="pending">Pending</option>
          <option value="completed">Completed</option>
          <option value="cancelled">Cancelled</option>
        </select>
        <input v-model="historyFilter.date_from" type="date" class="form-control" @change="loadHistory" />
        <input v-model="historyFilter.date_to" type="date" class="form-control" @change="loadHistory" />
      </div>

      <LoadingSpinner v-if="historyLoading" message="Loading history..." />
      <table v-else class="data-table">
        <thead>
          <tr><th>Order</th><th>Status</th><th>Total</th><th>Date</th></tr>
        </thead>
        <tbody>
          <tr v-for="s in history" :key="s.id">
            <td class="text-primary font-medium">{{ s.order_id }}</td>
            <td><StatusBadge :status="s.status" /></td>
            <td style="font-weight:600">Rs. {{ fmt(s.total_amount) }}</td>
            <td class="text-muted">{{ new Date(s.created_at).toLocaleDateString() }}</td>
          </tr>
          <tr v-if="!history.length">
            <td colspan="4" class="text-center text-muted" style="padding:30px">No sales history found</td>
          </tr>
        </tbody>
      </table>
    </Modal>
  </div>
</template>

<script>
import api from '../services/api'
import StatusBadge from '../components/common/StatusBadge.vue'
import LoadingSpinner from '../components/common/LoadingSpinner.vue'
import Modal from '../components/common/Modal.vue'

export default {
  name: 'CustomersView',
  components: { StatusBadge, LoadingSpinner, Modal },
  data() {
    return {
      customers: [], loading: true, search: '',
      selectedCustomer: null, history: [], historyLoading: false,
      historyFilter: { status: '', date_from: '', date_to: '' }
    }
  },
  computed: {
    filteredCustomers() {
      if (!this.search) return this.customers
      const q = this.search.toLowerCase()
      return this.customers.filter(c => c.name.toLowerCase().includes(q) || (c.email || '').toLowerCase().includes(q) || (c.company || '').toLowerCase().includes(q))
    }
  },
  methods: {
    fmt(n) { return Number(n || 0).toLocaleString('en-US', { minimumFractionDigits: 2, maximumFractionDigits: 2 }) },
    async viewHistory(customer) {
      this.selectedCustomer = customer
      this.historyFilter = { status: '', date_from: '', date_to: '' }
      this.loadHistory()
    },
    async loadHistory() {
      this.historyLoading = true
      try {
        const params = { ...this.historyFilter, limit: 50 }
        Object.keys(params).forEach(k => { if (!params[k]) delete params[k] })
        const { data } = await api.get(`/customers/${this.selectedCustomer.id}/history`, { params })
        this.history = data.data || []
      } finally { this.historyLoading = false }
    }
  },
  async mounted() {
    try {
      const { data } = await api.get('/customers')
      this.customers = data || []
    } finally { this.loading = false }
  }
}
</script>
