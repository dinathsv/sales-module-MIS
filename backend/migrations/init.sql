-- ============================================
-- Sales Module Database Schema
-- Database: salesdb (PostgreSQL)
-- ============================================

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ============================================
-- USERS TABLE (for JWT authentication)
-- ============================================
CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    role VARCHAR(20) DEFAULT 'admin',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================
-- CUSTOMERS TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS customers (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100),
    phone VARCHAR(20),
    address TEXT,
    company VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================
-- PRODUCTS TABLE (reference for sale items)
-- ============================================
CREATE TABLE IF NOT EXISTS products (
    id SERIAL PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    sku VARCHAR(50) UNIQUE NOT NULL,
    category VARCHAR(50),
    description TEXT,
    price DECIMAL(12,2) NOT NULL DEFAULT 0.00,
    stock_qty INTEGER DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================
-- SALES TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS sales (
    id SERIAL PRIMARY KEY,
    customer_id INTEGER REFERENCES customers(id) ON DELETE SET NULL,
    order_id VARCHAR(50) UNIQUE,
    status VARCHAR(20) DEFAULT 'pending' CHECK (status IN ('pending', 'completed', 'cancelled')),
    subtotal DECIMAL(12,2) DEFAULT 0.00,
    discount_percent DECIMAL(5,2) DEFAULT 0.00,
    discount_amount DECIMAL(12,2) DEFAULT 0.00,
    tax_amount DECIMAL(12,2) DEFAULT 0.00,
    total_amount DECIMAL(12,2) DEFAULT 0.00,
    notes TEXT,
    created_by INTEGER REFERENCES users(id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================
-- SALE ITEMS TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS sale_items (
    id SERIAL PRIMARY KEY,
    sale_id INTEGER NOT NULL REFERENCES sales(id) ON DELETE CASCADE,
    product_id INTEGER REFERENCES products(id) ON DELETE SET NULL,
    quantity INTEGER NOT NULL DEFAULT 1,
    unit_price DECIMAL(12,2) NOT NULL DEFAULT 0.00,
    line_total DECIMAL(12,2) NOT NULL DEFAULT 0.00
);

-- ============================================
-- INVOICES TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS invoices (
    id SERIAL PRIMARY KEY,
    sale_id INTEGER REFERENCES sales(id) ON DELETE SET NULL,
    invoice_number VARCHAR(50) UNIQUE NOT NULL,
    customer_id INTEGER REFERENCES customers(id) ON DELETE SET NULL,
    issue_date DATE DEFAULT CURRENT_DATE,
    due_date DATE,
    subtotal DECIMAL(12,2) DEFAULT 0.00,
    discount DECIMAL(12,2) DEFAULT 0.00,
    tax DECIMAL(12,2) DEFAULT 0.00,
    total DECIMAL(12,2) DEFAULT 0.00,
    status VARCHAR(20) DEFAULT 'draft' CHECK (status IN ('draft', 'sent', 'paid', 'overdue')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================
-- INVOICE ITEMS TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS invoice_items (
    id SERIAL PRIMARY KEY,
    invoice_id INTEGER NOT NULL REFERENCES invoices(id) ON DELETE CASCADE,
    product_id INTEGER REFERENCES products(id) ON DELETE SET NULL,
    description VARCHAR(255),
    quantity INTEGER NOT NULL DEFAULT 1,
    unit_price DECIMAL(12,2) NOT NULL DEFAULT 0.00,
    discount DECIMAL(12,2) DEFAULT 0.00,
    line_total DECIMAL(12,2) NOT NULL DEFAULT 0.00
);

-- ============================================
-- INDEXES
-- ============================================
CREATE INDEX IF NOT EXISTS idx_sales_customer_id ON sales(customer_id);
CREATE INDEX IF NOT EXISTS idx_sales_status ON sales(status);
CREATE INDEX IF NOT EXISTS idx_sales_created_at ON sales(created_at);
CREATE INDEX IF NOT EXISTS idx_sales_order_id ON sales(order_id);
CREATE INDEX IF NOT EXISTS idx_sale_items_sale_id ON sale_items(sale_id);
CREATE INDEX IF NOT EXISTS idx_sale_items_product_id ON sale_items(product_id);
CREATE INDEX IF NOT EXISTS idx_invoices_sale_id ON invoices(sale_id);
CREATE INDEX IF NOT EXISTS idx_invoices_customer_id ON invoices(customer_id);
CREATE INDEX IF NOT EXISTS idx_invoices_status ON invoices(status);
CREATE INDEX IF NOT EXISTS idx_invoice_items_invoice_id ON invoice_items(invoice_id);
CREATE INDEX IF NOT EXISTS idx_products_sku ON products(sku);
CREATE INDEX IF NOT EXISTS idx_products_category ON products(category);

-- ============================================
-- SEED DATA
-- ============================================

-- Admin user (password: admin123)
-- bcrypt hash for "admin123"
INSERT INTO users (username, email, password_hash, role) VALUES
('admin', 'admin@salesmodule.com', '$2a$10$voPywEBD.A5WThPii2FuM.ng49rNhJqgn4BYlke8hSclsB87RreIa', 'admin'),
('manager', 'manager@salesmodule.com', '$2a$10$voPywEBD.A5WThPii2FuM.ng49rNhJqgn4BYlke8hSclsB87RreIa', 'admin')
ON CONFLICT (username) DO NOTHING;

-- Customers
INSERT INTO customers (name, email, phone, address, company) VALUES
('Amal Perera', 'amal@example.com', '+94771234567', '123 Galle Road, Colombo 03', 'ABC Trading'),
('Nimal Silva', 'nimal@example.com', '+94772345678', '45 Kandy Road, Peradeniya', 'Silva & Sons'),
('Kumari Fernando', 'kumari@example.com', '+94773456789', '78 Main Street, Negombo', 'KF Enterprises'),
('Ruwan Jayawardena', 'ruwan@example.com', '+94774567890', '12 Temple Road, Kandy', 'RJ Solutions'),
('Dilini Wickramasinghe', 'dilini@example.com', '+94775678901', '56 Beach Road, Galle', 'DW Imports'),
('Saman Kumara', 'saman@example.com', '+94776789012', '90 Hill Street, Nuwara Eliya', 'SK Retail'),
('Priya Rajapaksha', 'priya@example.com', '+94777890123', '34 Lake Drive, Kandy', 'PR Wholesale'),
('Chaminda De Silva', 'chaminda@example.com', '+94778901234', '67 Station Road, Matara', 'CDS Supplies'),
('Nadeesha Bandara', 'nadeesha@example.com', '+94779012345', '23 Park Avenue, Colombo 07', 'NB Commerce'),
('Lasith Malinga', 'lasith@example.com', '+94770123456', '89 Cricket Lane, Galle', 'LM Distributors')
ON CONFLICT DO NOTHING;

-- Products
INSERT INTO products (name, sku, category, description, price, stock_qty) VALUES
('Laptop Pro 15"', 'LP-001', 'Electronics', 'High-performance laptop with 16GB RAM', 185000.00, 50),
('Wireless Mouse', 'WM-002', 'Accessories', 'Ergonomic wireless mouse with USB receiver', 3500.00, 200),
('USB-C Hub 7-in-1', 'UH-003', 'Accessories', 'Multi-port USB-C hub with HDMI', 8500.00, 100),
('Mechanical Keyboard', 'MK-004', 'Accessories', 'RGB mechanical keyboard with Cherry MX switches', 12500.00, 75),
('27" Monitor 4K', 'MN-005', 'Electronics', '27-inch 4K UHD IPS monitor', 95000.00, 30),
('Webcam HD 1080p', 'WC-006', 'Accessories', 'Full HD webcam with noise-cancelling mic', 7500.00, 120),
('External SSD 1TB', 'ES-007', 'Storage', '1TB portable SSD with USB 3.2', 22000.00, 80),
('Desk Lamp LED', 'DL-008', 'Office', 'Adjustable LED desk lamp with dimmer', 4500.00, 150),
('Office Chair Ergonomic', 'OC-009', 'Furniture', 'Ergonomic office chair with lumbar support', 45000.00, 25),
('Notebook A4 Pack (5)', 'NB-010', 'Stationery', 'Pack of 5 A4 ruled notebooks', 750.00, 500),
('Wireless Headphones', 'WH-011', 'Audio', 'Over-ear wireless headphones with ANC', 18500.00, 60),
('Portable Speaker', 'PS-012', 'Audio', 'Bluetooth portable speaker, waterproof', 9500.00, 90),
('Tablet 10"', 'TB-013', 'Electronics', '10-inch tablet with stylus support', 65000.00, 40),
('Printer Laser A4', 'PL-014', 'Electronics', 'Monochrome laser printer with WiFi', 35000.00, 20),
('HDMI Cable 2m', 'HC-015', 'Accessories', '2-meter HDMI 2.1 cable', 1200.00, 300),
('Surge Protector 6-Way', 'SP-016', 'Accessories', '6-way surge protector with USB ports', 3200.00, 180),
('Mouse Pad XL', 'MP-017', 'Accessories', 'Extended gaming mouse pad', 2800.00, 250),
('Phone Stand Adjustable', 'PS-018', 'Accessories', 'Adjustable aluminum phone/tablet stand', 2200.00, 200),
('Ethernet Cable Cat6 5m', 'EC-019', 'Networking', '5-meter Cat6 ethernet cable', 800.00, 400),
('USB Flash Drive 64GB', 'UF-020', 'Storage', '64GB USB 3.0 flash drive', 1500.00, 350)
ON CONFLICT (sku) DO NOTHING;

-- Sales (mix of statuses, spanning last 90 days)
INSERT INTO sales (customer_id, order_id, status, subtotal, discount_percent, discount_amount, tax_amount, total_amount, notes, created_by, created_at) VALUES
(1, 'ORD-2026-0001', 'completed', 197000.00, 5.00, 9850.00, 0.00, 187150.00, 'Bulk laptop order', 1, NOW() - INTERVAL '85 days'),
(2, 'ORD-2026-0002', 'completed', 15500.00, 0.00, 0.00, 0.00, 15500.00, 'Office accessories', 1, NOW() - INTERVAL '78 days'),
(3, 'ORD-2026-0003', 'completed', 95000.00, 10.00, 9500.00, 0.00, 85500.00, 'Monitor purchase', 1, NOW() - INTERVAL '72 days'),
(4, 'ORD-2026-0004', 'cancelled', 22000.00, 0.00, 0.00, 0.00, 22000.00, 'Customer cancelled', 1, NOW() - INTERVAL '65 days'),
(5, 'ORD-2026-0005', 'completed', 370000.00, 8.00, 29600.00, 0.00, 340400.00, 'Two laptops for office', 1, NOW() - INTERVAL '55 days'),
(6, 'ORD-2026-0006', 'completed', 55750.00, 0.00, 0.00, 0.00, 55750.00, 'Mixed electronics order', 1, NOW() - INTERVAL '48 days'),
(7, 'ORD-2026-0007', 'completed', 45000.00, 5.00, 2250.00, 0.00, 42750.00, 'Office chair purchase', 1, NOW() - INTERVAL '40 days'),
(8, 'ORD-2026-0008', 'pending', 130000.00, 0.00, 0.00, 0.00, 130000.00, 'Tablet and printer order', 1, NOW() - INTERVAL '30 days'),
(9, 'ORD-2026-0009', 'completed', 27500.00, 3.00, 825.00, 0.00, 26675.00, 'Audio equipment', 1, NOW() - INTERVAL '20 days'),
(1, 'ORD-2026-0010', 'completed', 185000.00, 5.00, 9250.00, 0.00, 175750.00, 'Laptop reorder', 1, NOW() - INTERVAL '15 days'),
(3, 'ORD-2026-0011', 'pending', 9700.00, 0.00, 0.00, 0.00, 9700.00, 'Accessory bundle', 1, NOW() - INTERVAL '10 days'),
(5, 'ORD-2026-0012', 'completed', 35000.00, 0.00, 0.00, 0.00, 35000.00, 'Printer purchase', 1, NOW() - INTERVAL '7 days'),
(2, 'ORD-2026-0013', 'pending', 65000.00, 5.00, 3250.00, 0.00, 61750.00, 'Tablet order', 1, NOW() - INTERVAL '3 days'),
(7, 'ORD-2026-0014', 'completed', 18500.00, 0.00, 0.00, 0.00, 18500.00, 'Headphones order', 1, NOW() - INTERVAL '1 day'),
(10, 'ORD-2026-0015', 'pending', 280000.00, 10.00, 28000.00, 0.00, 252000.00, 'Large electronics bundle', 1, NOW())
ON CONFLICT (order_id) DO NOTHING;

-- Sale Items
INSERT INTO sale_items (sale_id, product_id, quantity, unit_price, line_total) VALUES
-- ORD-0001: Laptop + Mouse + Hub
(1, 1, 1, 185000.00, 185000.00), (1, 2, 2, 3500.00, 7000.00), (1, 3, 1, 8500.00, 5000.00),
-- ORD-0002: Keyboard + Mouse + Cable
(2, 4, 1, 12500.00, 12500.00), (2, 2, 1, 3500.00, 1500.00), (2, 15, 1, 1500.00, 1500.00),
-- ORD-0003: Monitor
(3, 5, 1, 95000.00, 95000.00),
-- ORD-0004: External SSD
(4, 7, 1, 22000.00, 22000.00),
-- ORD-0005: Two Laptops
(5, 1, 2, 185000.00, 370000.00),
-- ORD-0006: Webcam + SSD + Headphones + Speaker
(6, 6, 1, 7500.00, 7500.00), (6, 7, 1, 22000.00, 22000.00), (6, 11, 1, 18500.00, 18500.00), (6, 12, 1, 9500.00, 7750.00),
-- ORD-0007: Office Chair
(7, 9, 1, 45000.00, 45000.00),
-- ORD-0008: Tablet + Printer
(8, 13, 1, 65000.00, 65000.00), (8, 14, 1, 35000.00, 35000.00), (8, 7, 1, 22000.00, 30000.00),
-- ORD-0009: Headphones + Speaker
(9, 11, 1, 18500.00, 18500.00), (9, 12, 1, 9500.00, 9000.00),
-- ORD-0010: Laptop
(10, 1, 1, 185000.00, 185000.00),
-- ORD-0011: Mouse Pad + Phone Stand + Cable + Hub
(11, 17, 1, 2800.00, 2800.00), (11, 18, 1, 2200.00, 2200.00), (11, 15, 1, 1200.00, 1200.00), (11, 3, 1, 8500.00, 3500.00),
-- ORD-0012: Printer
(12, 14, 1, 35000.00, 35000.00),
-- ORD-0013: Tablet
(13, 13, 1, 65000.00, 65000.00),
-- ORD-0014: Headphones
(14, 11, 1, 18500.00, 18500.00),
-- ORD-0015: Laptop + Monitor + Chair
(15, 1, 1, 185000.00, 185000.00), (15, 5, 1, 95000.00, 95000.00)
ON CONFLICT DO NOTHING;

-- Invoices (for completed sales)
INSERT INTO invoices (sale_id, invoice_number, customer_id, issue_date, due_date, subtotal, discount, tax, total, status, created_at) VALUES
(1, 'INV-20260211-0001', 1, NOW() - INTERVAL '85 days', NOW() - INTERVAL '55 days', 197000.00, 9850.00, 0.00, 187150.00, 'paid', NOW() - INTERVAL '85 days'),
(2, 'INV-20260218-0002', 2, NOW() - INTERVAL '78 days', NOW() - INTERVAL '48 days', 15500.00, 0.00, 0.00, 15500.00, 'paid', NOW() - INTERVAL '78 days'),
(3, 'INV-20260224-0003', 3, NOW() - INTERVAL '72 days', NOW() - INTERVAL '42 days', 95000.00, 9500.00, 0.00, 85500.00, 'paid', NOW() - INTERVAL '72 days'),
(5, 'INV-20260312-0004', 5, NOW() - INTERVAL '55 days', NOW() - INTERVAL '25 days', 370000.00, 29600.00, 0.00, 340400.00, 'paid', NOW() - INTERVAL '55 days'),
(6, 'INV-20260319-0005', 6, NOW() - INTERVAL '48 days', NOW() - INTERVAL '18 days', 55750.00, 0.00, 0.00, 55750.00, 'paid', NOW() - INTERVAL '48 days'),
(7, 'INV-20260327-0006', 7, NOW() - INTERVAL '40 days', NOW() - INTERVAL '10 days', 45000.00, 2250.00, 0.00, 42750.00, 'sent', NOW() - INTERVAL '40 days'),
(9, 'INV-20260416-0007', 9, NOW() - INTERVAL '20 days', NOW() + INTERVAL '10 days', 27500.00, 825.00, 0.00, 26675.00, 'sent', NOW() - INTERVAL '20 days'),
(10, 'INV-20260421-0008', 1, NOW() - INTERVAL '15 days', NOW() + INTERVAL '15 days', 185000.00, 9250.00, 0.00, 175750.00, 'sent', NOW() - INTERVAL '15 days'),
(12, 'INV-20260429-0009', 5, NOW() - INTERVAL '7 days', NOW() + INTERVAL '23 days', 35000.00, 0.00, 0.00, 35000.00, 'draft', NOW() - INTERVAL '7 days'),
(14, 'INV-20260505-0010', 7, NOW() - INTERVAL '1 day', NOW() + INTERVAL '29 days', 18500.00, 0.00, 0.00, 18500.00, 'draft', NOW() - INTERVAL '1 day')
ON CONFLICT (invoice_number) DO NOTHING;

-- Invoice Items (matching sale items for invoiced sales)
INSERT INTO invoice_items (invoice_id, product_id, description, quantity, unit_price, discount, line_total) VALUES
(1, 1, 'Laptop Pro 15"', 1, 185000.00, 0.00, 185000.00),
(1, 2, 'Wireless Mouse', 2, 3500.00, 0.00, 7000.00),
(1, 3, 'USB-C Hub 7-in-1', 1, 8500.00, 0.00, 5000.00),
(2, 4, 'Mechanical Keyboard', 1, 12500.00, 0.00, 12500.00),
(2, 2, 'Wireless Mouse', 1, 3500.00, 0.00, 1500.00),
(2, 15, 'HDMI Cable 2m', 1, 1500.00, 0.00, 1500.00),
(3, 5, '27" Monitor 4K', 1, 95000.00, 0.00, 95000.00),
(4, 1, 'Laptop Pro 15"', 2, 185000.00, 0.00, 370000.00),
(5, 6, 'Webcam HD 1080p', 1, 7500.00, 0.00, 7500.00),
(5, 7, 'External SSD 1TB', 1, 22000.00, 0.00, 22000.00),
(5, 11, 'Wireless Headphones', 1, 18500.00, 0.00, 18500.00),
(5, 12, 'Portable Speaker', 1, 9500.00, 0.00, 7750.00),
(6, 9, 'Office Chair Ergonomic', 1, 45000.00, 0.00, 45000.00),
(7, 11, 'Wireless Headphones', 1, 18500.00, 0.00, 18500.00),
(7, 12, 'Portable Speaker', 1, 9500.00, 0.00, 9000.00),
(8, 1, 'Laptop Pro 15"', 1, 185000.00, 0.00, 185000.00),
(9, 14, 'Printer Laser A4', 1, 35000.00, 0.00, 35000.00),
(10, 11, 'Wireless Headphones', 1, 18500.00, 0.00, 18500.00)
ON CONFLICT DO NOTHING;
