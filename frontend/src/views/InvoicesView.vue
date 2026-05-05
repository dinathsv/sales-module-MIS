<template>
  <div class="invoices-page">
    <div class="page-header">
      <div>
        <h1>Invoices</h1>
        <p>View and manage generated invoices</p>
      </div>
    </div>

    <div class="filters-bar">
      <select v-model="statusFilter" @change="loadInvoices" class="form-control">
        <option value="">All Status</option>
        <option value="draft">Draft</option>
        <option value="sent">Sent</option>
        <option value="paid">Paid</option>
        <option value="overdue">Overdue</option>
      </select>
    </div>

    <LoadingSpinner v-if="store.loading" />

    <template v-else>
      <div class="card">
        <table class="data-table">
          <thead>
            <tr>
              <th>Invoice #</th>
              <th>Customer</th>
              <th>Issue Date</th>
              <th>Due Date</th>
              <th>Subtotal</th>
              <th>Discount</th>
              <th>Total</th>
              <th>Status</th>
              <th>Actions</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="inv in store.invoices" :key="inv.id">
              <td class="text-primary font-medium">{{ inv.invoice_number }}</td>
              <td>{{ inv.customer_name || 'N/A' }}</td>
              <td class="text-muted">{{ inv.issue_date }}</td>
              <td class="text-muted">{{ inv.due_date || '-' }}</td>
              <td>Rs. {{ fmt(inv.subtotal) }}</td>
              <td class="text-warning">Rs. {{ fmt(inv.discount) }}</td>
              <td class="text-primary font-semibold">Rs. {{ fmt(inv.total) }}</td>
              <td><StatusBadge :status="inv.status" /></td>
              <td>
                <button class="btn btn-ghost btn-sm" @click="viewInvoice(inv.id)">👁 View</button>
              </td>
            </tr>
            <tr v-if="!store.invoices.length">
              <td colspan="9" class="empty-state"><div class="icon">📄</div><h3>No invoices found</h3></td>
            </tr>
          </tbody>
        </table>
      </div>

      <div class="pagination" v-if="store.pagination.totalPages > 1">
        <button @click="loadInvoices(store.pagination.page - 1)" :disabled="store.pagination.page <= 1">← Prev</button>
        <span class="text-muted">Page {{ store.pagination.page }} of {{ store.pagination.totalPages }}</span>
        <button @click="loadInvoices(store.pagination.page + 1)" :disabled="store.pagination.page >= store.pagination.totalPages">Next →</button>
      </div>
    </template>

    <!-- Invoice Viewer Modal -->
    <Modal v-if="selectedInvoice" :title="`Invoice ${selectedInvoice.invoice_number}`" @close="selectedInvoice = null" maxWidth="800px">
      <div class="invoice-document">
        <div style="display:flex;justify-content:space-between;margin-bottom:30px">
          <div>
            <h2 style="color:#1a1a1a;font-size:1.5rem;margin-bottom:4px">INVOICE</h2>
            <p style="color:#6b7280;font-size:0.85rem">{{ selectedInvoice.invoice_number }}</p>
          </div>
          <div style="text-align:right">
            <h3 style="color:#4f46e5;font-size:1.2rem">SalesHub</h3>
            <p style="color:#6b7280;font-size:0.8rem">Sales Module System</p>
          </div>
        </div>

        <div style="display:flex;justify-content:space-between;margin-bottom:24px">
          <div>
            <p style="color:#6b7280;font-size:0.75rem;text-transform:uppercase;margin-bottom:4px">Bill To</p>
            <p style="font-weight:600">{{ selectedInvoice.customer_name }}</p>
          </div>
          <div style="text-align:right">
            <p style="color:#6b7280;font-size:0.8rem">Issue: {{ selectedInvoice.issue_date }}</p>
            <p style="color:#6b7280;font-size:0.8rem">Due: {{ selectedInvoice.due_date || 'N/A' }}</p>
          </div>
        </div>

        <table>
          <thead>
            <tr><th>Description</th><th>Qty</th><th>Unit Price</th><th style="text-align:right">Total</th></tr>
          </thead>
          <tbody>
            <tr v-for="item in selectedInvoice.items" :key="item.id">
              <td>{{ item.description }}</td>
              <td>{{ item.quantity }}</td>
              <td>Rs. {{ fmt(item.unit_price) }}</td>
              <td style="text-align:right;font-weight:600">Rs. {{ fmt(item.line_total) }}</td>
            </tr>
          </tbody>
        </table>

        <div style="margin-top:20px;text-align:right;border-top:2px solid #e5e7eb;padding-top:16px">
          <p style="color:#6b7280">Subtotal: Rs. {{ fmt(selectedInvoice.subtotal) }}</p>
          <p style="color:#6b7280">Discount: Rs. {{ fmt(selectedInvoice.discount) }}</p>
          <p style="font-size:1.2rem;font-weight:700;color:#4f46e5;margin-top:8px">Total: Rs. {{ fmt(selectedInvoice.total) }}</p>
        </div>
      </div>
      <template #footer>
        <button class="btn btn-ghost" @click="selectedInvoice = null">Close</button>
        <button class="btn btn-primary" @click="printInvoice">🖨 Print</button>
      </template>
    </Modal>
  </div>
</template>

<script>
import { useInvoicesStore } from '../stores/invoices'
import StatusBadge from '../components/common/StatusBadge.vue'
import LoadingSpinner from '../components/common/LoadingSpinner.vue'
import Modal from '../components/common/Modal.vue'

export default {
  name: 'InvoicesView',
  components: { StatusBadge, LoadingSpinner, Modal },
  data() { return { statusFilter: '', selectedInvoice: null } },
  computed: { store() { return useInvoicesStore() } },
  methods: {
    fmt(n) { return Number(n || 0).toLocaleString('en-US', { minimumFractionDigits: 2, maximumFractionDigits: 2 }) },
    loadInvoices(page = 1) {
      this.store.fetchInvoices(page, { status: this.statusFilter })
    },
    async viewInvoice(id) {
      this.selectedInvoice = await this.store.fetchInvoice(id)
    },
    printInvoice() { window.print() }
  },
  mounted() { this.loadInvoices() }
}
</script>
