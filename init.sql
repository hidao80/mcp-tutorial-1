-- Initial database schema and sample data (English version)

-- Users table
CREATE TABLE IF NOT EXISTS users (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    email TEXT UNIQUE NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Products table
CREATE TABLE IF NOT EXISTS products (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    description TEXT,
    price DECIMAL(10, 2) NOT NULL,
    stock_quantity INTEGER DEFAULT 0,
    category_id INTEGER,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Categories table
CREATE TABLE IF NOT EXISTS categories (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL UNIQUE,
    description TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Orders table
CREATE TABLE IF NOT EXISTS orders (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER NOT NULL,
    total_amount DECIMAL(10, 2) NOT NULL,
    status TEXT DEFAULT 'pending',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id)
);

-- Order items table
CREATE TABLE IF NOT EXISTS order_items (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    order_id INTEGER NOT NULL,
    product_id INTEGER NOT NULL,
    quantity INTEGER NOT NULL,
    unit_price DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(id),
    FOREIGN KEY (product_id) REFERENCES products(id)
);

-- Create indexes
CREATE INDEX IF NOT EXISTS idx_users_email ON users(email);
CREATE INDEX IF NOT EXISTS idx_products_category ON products(category_id);
CREATE INDEX IF NOT EXISTS idx_orders_user ON orders(user_id);
CREATE INDEX IF NOT EXISTS idx_order_items_order ON order_items(order_id);
CREATE INDEX IF NOT EXISTS idx_order_items_product ON order_items(product_id);

-- Insert sample data

-- Categories
INSERT OR IGNORE INTO categories (name, description) VALUES 
    ('Electronics', 'Electronic devices and gadgets'),
    ('Books', 'Books and magazines'),
    ('Clothing', 'Clothing and fashion'),
    ('Food', 'Food and beverages');

-- Users
INSERT OR IGNORE INTO users (name, email) VALUES 
    ('Taro Tanaka', 'tanaka@example.com'),
    ('Hanako Sato', 'sato@example.com'),
    ('Jiro Suzuki', 'suzuki@example.com'),
    ('Misaki Takahashi', 'takahashi@example.com');

-- Products
INSERT OR IGNORE INTO products (name, description, price, stock_quantity, category_id) VALUES 
    ('MacBook Pro', 'Apple laptop computer', 299800.00, 5, 1),
    ('iPhone 15', 'Apple smartphone', 124800.00, 10, 1),
    ('Programming Basics', 'Programming learning book', 2980.00, 20, 2),
    ('Design Patterns', 'Software design book', 4500.00, 15, 2),
    ('Casual Shirt', '100% cotton shirt', 3980.00, 30, 3),
    ('Jeans', 'Denim pants', 8900.00, 25, 3),
    ('Organic Coffee', 'Organic coffee beans', 1200.00, 50, 4),
    ('Green Tea Set', 'Premium green tea assortment', 2800.00, 40, 4);

-- Insert orders (total_amount temporarily set to 0, will be updated later)
INSERT OR IGNORE INTO orders (id, user_id, total_amount, status) VALUES 
    (1, 1, 0.00, 'completed'),
    (2, 2, 0.00, 'pending'),
    (3, 3, 0.00, 'processing'),
    (4, 4, 0.00, 'completed');

-- Insert order items
INSERT OR IGNORE INTO order_items (order_id, product_id, quantity, unit_price) VALUES 
    -- Order 1: Taro Tanaka
    (1, 1, 1, 299800.00),  -- MacBook Pro x1
    (1, 3, 1, 2980.00),    -- Programming Basics x1
    -- Order 2: Hanako Sato  
    (2, 5, 1, 3980.00),    -- Casual Shirt x1
    (2, 6, 1, 8900.00),    -- Jeans x1
    -- Order 3: Jiro Suzuki
    (3, 2, 1, 124800.00),  -- iPhone 15 x1
    -- Order 4: Misaki Takahashi
    (4, 7, 2, 1200.00),    -- Organic Coffee x2
    (4, 8, 1, 2800.00);    -- Green Tea Set x1

-- Update orders table total_amount with accurate calculations from order items
UPDATE orders 
SET total_amount = (
    SELECT SUM(quantity * unit_price)
    FROM order_items 
    WHERE order_items.order_id = orders.id
)
WHERE id IN (1, 2, 3, 4);

-- Create update timestamp triggers
CREATE TRIGGER IF NOT EXISTS update_users_timestamp 
    AFTER UPDATE ON users
    FOR EACH ROW
    BEGIN
        UPDATE users SET updated_at = CURRENT_TIMESTAMP WHERE id = NEW.id;
    END;

CREATE TRIGGER IF NOT EXISTS update_products_timestamp 
    AFTER UPDATE ON products
    FOR EACH ROW
    BEGIN
        UPDATE products SET updated_at = CURRENT_TIMESTAMP WHERE id = NEW.id;
    END;

CREATE TRIGGER IF NOT EXISTS update_orders_timestamp 
    AFTER UPDATE ON orders
    FOR EACH ROW
    BEGIN
        UPDATE orders SET updated_at = CURRENT_TIMESTAMP WHERE id = NEW.id;
    END;

-- Automatic total_amount update triggers when order_items change
CREATE TRIGGER IF NOT EXISTS update_order_total_on_insert
    AFTER INSERT ON order_items
    FOR EACH ROW
    BEGIN
        UPDATE orders 
        SET total_amount = (
            SELECT SUM(quantity * unit_price)
            FROM order_items 
            WHERE order_id = NEW.order_id
        ),
        updated_at = CURRENT_TIMESTAMP
        WHERE id = NEW.order_id;
    END;

CREATE TRIGGER IF NOT EXISTS update_order_total_on_update
    AFTER UPDATE ON order_items
    FOR EACH ROW
    BEGIN
        UPDATE orders 
        SET total_amount = (
            SELECT SUM(quantity * unit_price)
            FROM order_items 
            WHERE order_id = NEW.order_id
        ),
        updated_at = CURRENT_TIMESTAMP
        WHERE id = NEW.order_id;
    END;

CREATE TRIGGER IF NOT EXISTS update_order_total_on_delete
    AFTER DELETE ON order_items
    FOR EACH ROW
    BEGIN
        UPDATE orders 
        SET total_amount = (
            SELECT COALESCE(SUM(quantity * unit_price), 0)
            FROM order_items 
            WHERE order_id = OLD.order_id
        ),
        updated_at = CURRENT_TIMESTAMP
        WHERE id = OLD.order_id;
    END;