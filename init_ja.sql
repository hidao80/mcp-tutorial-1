-- 初期データベーススキーマとサンプルデータ

-- ユーザーテーブル
CREATE TABLE IF NOT EXISTS users (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    email TEXT UNIQUE NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- 商品テーブル
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

-- カテゴリテーブル
CREATE TABLE IF NOT EXISTS categories (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL UNIQUE,
    description TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- 注文テーブル
CREATE TABLE IF NOT EXISTS orders (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER NOT NULL,
    total_amount DECIMAL(10, 2) NOT NULL,
    status TEXT DEFAULT 'pending',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id)
);

-- 注文詳細テーブル
CREATE TABLE IF NOT EXISTS order_items (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    order_id INTEGER NOT NULL,
    product_id INTEGER NOT NULL,
    quantity INTEGER NOT NULL,
    unit_price DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(id),
    FOREIGN KEY (product_id) REFERENCES products(id)
);

-- インデックス作成
CREATE INDEX IF NOT EXISTS idx_users_email ON users(email);
CREATE INDEX IF NOT EXISTS idx_products_category ON products(category_id);
CREATE INDEX IF NOT EXISTS idx_orders_user ON orders(user_id);
CREATE INDEX IF NOT EXISTS idx_order_items_order ON order_items(order_id);
CREATE INDEX IF NOT EXISTS idx_order_items_product ON order_items(product_id);

-- サンプルデータ挿入

-- カテゴリ
INSERT OR IGNORE INTO categories (name, description) VALUES 
    ('Electronics', '電子機器・ガジェット'),
    ('Books', '書籍・雑誌'),
    ('Clothing', '衣類・ファッション'),
    ('Food', '食品・飲料');

-- ユーザー
INSERT OR IGNORE INTO users (name, email) VALUES 
    ('田中太郎', 'tanaka@example.com'),
    ('佐藤花子', 'sato@example.com'),
    ('鈴木次郎', 'suzuki@example.com'),
    ('高橋美咲', 'takahashi@example.com');

-- 商品
INSERT OR IGNORE INTO products (name, description, price, stock_quantity, category_id) VALUES 
    ('MacBook Pro', 'Apple製ノートパソコン', 299800.00, 5, 1),
    ('iPhone 15', 'Apple製スマートフォン', 124800.00, 10, 1),
    ('プログラミング入門', 'プログラミング学習書', 2980.00, 20, 2),
    ('デザインパターン', 'ソフトウェア設計書', 4500.00, 15, 2),
    ('カジュアルシャツ', '綿100%シャツ', 3980.00, 30, 3),
    ('ジーンズ', 'デニムパンツ', 8900.00, 25, 3),
    ('オーガニックコーヒー', '有機栽培コーヒー豆', 1200.00, 50, 4),
    ('緑茶セット', '高級緑茶詰め合わせ', 2800.00, 40, 4);

-- 注文の挿入（total_amountは一時的に0で作成し、後で更新）
INSERT OR IGNORE INTO orders (id, user_id, total_amount, status) VALUES 
    (1, 1, 0.00, 'completed'),
    (2, 2, 0.00, 'pending'),
    (3, 3, 0.00, 'processing'),
    (4, 4, 0.00, 'completed');

-- 注文詳細の挿入
INSERT OR IGNORE INTO order_items (order_id, product_id, quantity, unit_price) VALUES 
    -- 注文1: 田中太郎
    (1, 1, 1, 299800.00),  -- MacBook Pro x1
    (1, 3, 1, 2980.00),    -- プログラミング入門 x1
    -- 注文2: 佐藤花子  
    (2, 5, 1, 3980.00),    -- カジュアルシャツ x1
    (2, 6, 1, 8900.00),    -- ジーンズ x1
    -- 注文3: 鈴木次郎
    (3, 2, 1, 124800.00),  -- iPhone 15 x1
    -- 注文4: 高橋美咲
    (4, 7, 2, 1200.00),    -- オーガニックコーヒー x2
    (4, 8, 1, 2800.00);    -- 緑茶セット x1

-- ordersテーブルのtotal_amountを注文明細から正確に計算して更新
UPDATE orders 
SET total_amount = (
    SELECT SUM(quantity * unit_price)
    FROM order_items 
    WHERE order_items.order_id = orders.id
)
WHERE id IN (1, 2, 3, 4);

-- 更新日時のトリガー作成
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

-- 注文詳細が変更された時にordersテーブルのtotal_amountを自動更新するトリガー
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