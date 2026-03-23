-- ========================================
-- Platzi FC Database Schema
-- PostgreSQL Schema for Football Club Management
-- ========================================

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ========================================
-- ENUM TYPES
-- ========================================

-- Player positions
CREATE TYPE player_position AS ENUM (
    'GOALKEEPER',
    'DEFENDER',
    'MIDFIELDER',
    'FORWARD'
);

-- Match status
CREATE TYPE match_status AS ENUM (
    'SCHEDULED',
    'LIVE',
    'FINISHED',
    'POSTPONED',
    'CANCELLED'
);

-- Match result (from perspective of home team)
CREATE TYPE match_result AS ENUM (
    'WIN',
    'DRAW',
    'LOSS',
    'PENDING'
);

-- Product categories
CREATE TYPE product_category AS ENUM (
    'JERSEY',
    'SHORTS',
    'SOCKS',
    'ACCESSORIES',
    'EQUIPMENT',
    'MERCHANDISE'
);

-- Order status
CREATE TYPE order_status AS ENUM (
    'PENDING',
    'CONFIRMED',
    'PROCESSING',
    'SHIPPED',
    'DELIVERED',
    'CANCELLED'
);

-- Payment status
CREATE TYPE payment_status AS ENUM (
    'PENDING',
    'COMPLETED',
    'FAILED',
    'REFUNDED'
);

-- ========================================
-- CORE ENTITIES
-- ========================================

-- Teams table
CREATE TABLE teams (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(255) NOT NULL,
    short_name VARCHAR(50) NOT NULL,
    crest_url VARCHAR(500),
    founded_year INTEGER,
    stadium_name VARCHAR(255),
    stadium_capacity INTEGER,
    website VARCHAR(500),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Players table
CREATE TABLE players (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    team_id UUID NOT NULL REFERENCES teams(id) ON DELETE CASCADE,
    name VARCHAR(255) NOT NULL,
    shirt_number INTEGER,
    position player_position NOT NULL,
    date_of_birth DATE,
    nationality VARCHAR(100),
    height DECIMAL(5,2), -- in cm
    weight DECIMAL(5,2), -- in kg
    photo_url VARCHAR(500),
    bio TEXT,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- ========================================
-- MATCHES AND COMPETITIONS
-- ========================================

-- Competitions/Leagues
CREATE TABLE competitions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(255) NOT NULL,
    short_name VARCHAR(50),
    type VARCHAR(50), -- LEAGUE, CUP, TOURNAMENT
    country VARCHAR(100),
    season VARCHAR(50),
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Matches table
CREATE TABLE matches (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    competition_id UUID REFERENCES competitions(id) ON DELETE SET NULL,
    home_team_id UUID NOT NULL REFERENCES teams(id),
    away_team_id UUID NOT NULL REFERENCES teams(id),
    match_date TIMESTAMP WITH TIME ZONE NOT NULL,
    venue VARCHAR(255),
    status match_status DEFAULT 'SCHEDULED',
    home_score INTEGER DEFAULT 0,
    away_score INTEGER DEFAULT 0,
    result match_result DEFAULT 'PENDING',
    match_day INTEGER, -- Match day in competition
    external_id VARCHAR(100), -- ID from external sports API
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT check_different_teams CHECK (home_team_id != away_team_id),
    CONSTRAINT check_scores CHECK (
        (status = 'FINISHED' AND home_score IS NOT NULL AND away_score IS NOT NULL) OR
        (status != 'FINISHED')
    )
);

-- Match events (goals, cards, substitutions)
CREATE TABLE match_events (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    match_id UUID NOT NULL REFERENCES matches(id) ON DELETE CASCADE,
    player_id UUID REFERENCES players(id),
    team_id UUID NOT NULL REFERENCES teams(id),
    event_type VARCHAR(50) NOT NULL, -- GOAL, YELLOW_CARD, RED_CARD, SUBSTITUTION
    event_minute INTEGER NOT NULL,
    event_description TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- ========================================
-- NEWS AND CONTENT
-- ========================================

-- News articles
CREATE TABLE news (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    title VARCHAR(500) NOT NULL,
    slug VARCHAR(500) UNIQUE NOT NULL,
    excerpt TEXT,
    content TEXT NOT NULL,
    featured_image_url VARCHAR(500),
    author VARCHAR(255),
    published_at TIMESTAMP WITH TIME ZONE,
    is_published BOOLEAN DEFAULT false,
    tags TEXT[], -- Array of tags
    external_id VARCHAR(100), -- ID from Sanity CMS
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Multimedia content
CREATE TABLE multimedia (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    title VARCHAR(255) NOT NULL,
    description TEXT,
    media_type VARCHAR(50) NOT NULL, -- IMAGE, VIDEO, GALLERY
    media_url VARCHAR(500) NOT NULL,
    thumbnail_url VARCHAR(500),
    category VARCHAR(100),
    tags TEXT[],
    is_featured BOOLEAN DEFAULT false,
    published_at TIMESTAMP WITH TIME ZONE,
    external_id VARCHAR(100), -- ID from Sanity CMS
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- ========================================
-- E-COMMERCE
-- ========================================

-- Products table
CREATE TABLE products (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(255) NOT NULL,
    slug VARCHAR(255) UNIQUE NOT NULL,
    description TEXT,
    category product_category NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    compare_price DECIMAL(10,2), -- Original price for discounts
    sku VARCHAR(100) UNIQUE,
    stock_quantity INTEGER DEFAULT 0,
    images TEXT[], -- Array of image URLs
    is_active BOOLEAN DEFAULT true,
    is_featured BOOLEAN DEFAULT false,
    external_id VARCHAR(100), -- ID from Sanity CMS
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Product variants (size, color, etc.)
CREATE TABLE product_variants (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    product_id UUID NOT NULL REFERENCES products(id) ON DELETE CASCADE,
    variant_name VARCHAR(100), -- e.g., "Large", "Red", "L-Red"
    variant_type VARCHAR(50), -- SIZE, COLOR, SIZE_COLOR
    price_adjustment DECIMAL(10,2) DEFAULT 0,
    stock_quantity INTEGER DEFAULT 0,
    sku VARCHAR(100),
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Orders table
CREATE TABLE orders (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    order_number VARCHAR(50) UNIQUE NOT NULL,
    customer_email VARCHAR(255) NOT NULL,
    customer_name VARCHAR(255) NOT NULL,
    customer_phone VARCHAR(50),
    shipping_address TEXT NOT NULL,
    billing_address TEXT,
    subtotal DECIMAL(10,2) NOT NULL,
    tax_amount DECIMAL(10,2) DEFAULT 0,
    shipping_amount DECIMAL(10,2) DEFAULT 0,
    total_amount DECIMAL(10,2) NOT NULL,
    status order_status DEFAULT 'PENDING',
    payment_status payment_status DEFAULT 'PENDING',
    payment_method VARCHAR(50),
    transaction_id VARCHAR(255),
    notes TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Order items
CREATE TABLE order_items (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    order_id UUID NOT NULL REFERENCES orders(id) ON DELETE CASCADE,
    product_id UUID NOT NULL REFERENCES products(id),
    product_variant_id UUID REFERENCES product_variants(id),
    quantity INTEGER NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    total_price DECIMAL(10,2) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- ========================================
-- CONTACT AND FORMS
-- ========================================

-- Contact submissions
CREATE TABLE contact_submissions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL,
    phone VARCHAR(50),
    subject VARCHAR(255),
    message TEXT NOT NULL,
    submission_type VARCHAR(50) DEFAULT 'CONTACT', -- CONTACT, SUPPORT, SPONSORSHIP
    is_read BOOLEAN DEFAULT false,
    is_responded BOOLEAN DEFAULT false,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Newsletter subscriptions
CREATE TABLE newsletter_subscriptions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    email VARCHAR(255) UNIQUE NOT NULL,
    name VARCHAR(255),
    is_active BOOLEAN DEFAULT true,
    subscription_date TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    unsubscribe_date TIMESTAMP WITH TIME ZONE
);

-- ========================================
-- SYSTEM AND ADMIN
-- ========================================

-- System settings
CREATE TABLE system_settings (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    key VARCHAR(100) UNIQUE NOT NULL,
    value TEXT,
    description TEXT,
    is_public BOOLEAN DEFAULT false,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Audit logs
CREATE TABLE audit_logs (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id VARCHAR(255), -- Can be null for system actions
    action VARCHAR(100) NOT NULL,
    entity_type VARCHAR(100) NOT NULL,
    entity_id UUID,
    old_values JSONB,
    new_values JSONB,
    ip_address INET,
    user_agent TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- ========================================
-- INDEXES FOR PERFORMANCE
-- ========================================

-- Teams indexes
CREATE INDEX idx_teams_name ON teams(name);
CREATE INDEX idx_teams_short_name ON teams(short_name);

-- Players indexes
CREATE INDEX idx_players_team_id ON players(team_id);
CREATE INDEX idx_players_position ON players(position);
CREATE INDEX idx_players_shirt_number ON players(shirt_number);
CREATE INDEX idx_players_is_active ON players(is_active);

-- Matches indexes
CREATE INDEX idx_matches_date ON matches(match_date);
CREATE INDEX idx_matches_home_team ON matches(home_team_id);
CREATE INDEX idx_matches_away_team ON matches(away_team_id);
CREATE INDEX idx_matches_status ON matches(status);
CREATE INDEX idx_matches_competition ON matches(competition_id);

-- News indexes
CREATE INDEX idx_news_published ON news(is_published);
CREATE INDEX idx_news_published_at ON news(published_at DESC);
CREATE INDEX idx_news_slug ON news(slug);
CREATE INDEX idx_news_tags ON news USING GIN(tags);

-- Multimedia indexes
CREATE INDEX idx_multimedia_type ON multimedia(media_type);
CREATE INDEX idx_multimedia_published ON multimedia(published_at DESC);
CREATE INDEX idx_multimedia_featured ON multimedia(is_featured);
CREATE INDEX idx_multimedia_tags ON multimedia USING GIN(tags);

-- Products indexes
CREATE INDEX idx_products_category ON products(category);
CREATE INDEX idx_products_active ON products(is_active);
CREATE INDEX idx_products_featured ON products(is_featured);
CREATE INDEX idx_products_slug ON products(slug);
CREATE INDEX idx_products_price ON products(price);

-- Product variants indexes
CREATE INDEX idx_product_variants_product ON product_variants(product_id);
CREATE INDEX idx_product_variants_active ON product_variants(is_active);

-- Orders indexes
CREATE INDEX idx_orders_customer ON orders(customer_email);
CREATE INDEX idx_orders_status ON orders(status);
CREATE INDEX idx_orders_payment_status ON orders(payment_status);
CREATE INDEX idx_orders_created ON orders(created_at DESC);
CREATE INDEX idx_orders_number ON orders(order_number);

-- Order items indexes
CREATE INDEX idx_order_items_order ON order_items(order_id);
CREATE INDEX idx_order_items_product ON order_items(product_id);

-- Contact indexes
CREATE INDEX idx_contact_email ON contact_submissions(email);
CREATE INDEX idx_contact_read ON contact_submissions(is_read);
CREATE INDEX idx_contact_created ON contact_submissions(created_at DESC);

-- Newsletter indexes
CREATE INDEX idx_newsletter_email ON newsletter_subscriptions(email);
CREATE INDEX idx_newsletter_active ON newsletter_subscriptions(is_active);

-- Audit logs indexes
CREATE INDEX idx_audit_entity ON audit_logs(entity_type, entity_id);
CREATE INDEX idx_audit_user ON audit_logs(user_id);
CREATE INDEX idx_audit_created ON audit_logs(created_at DESC);

-- ========================================
-- TRIGGERS FOR UPDATED_AT
-- ========================================

-- Function to update updated_at column
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Create triggers for all tables with updated_at
CREATE TRIGGER update_teams_updated_at BEFORE UPDATE ON teams FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_players_updated_at BEFORE UPDATE ON players FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_competitions_updated_at BEFORE UPDATE ON competitions FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_matches_updated_at BEFORE UPDATE ON matches FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_news_updated_at BEFORE UPDATE ON news FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_multimedia_updated_at BEFORE UPDATE ON multimedia FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_products_updated_at BEFORE UPDATE ON products FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_product_variants_updated_at BEFORE UPDATE ON product_variants FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_orders_updated_at BEFORE UPDATE ON orders FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_contact_submissions_updated_at BEFORE UPDATE ON contact_submissions FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_system_settings_updated_at BEFORE UPDATE ON system_settings FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- ========================================
-- VIEWS FOR COMMON QUERIES
-- ========================================

-- View for player statistics
CREATE VIEW player_stats AS
SELECT 
    p.id,
    p.name,
    p.shirt_number,
    p.position,
    t.name as team_name,
    COUNT(CASE WHEN m.status = 'FINISHED' THEN 1 END) as matches_played,
    COUNT(CASE WHEN me.event_type = 'GOAL' THEN 1 END) as goals_scored,
    COUNT(CASE WHEN me.event_type = 'YELLOW_CARD' THEN 1 END) as yellow_cards,
    COUNT(CASE WHEN me.event_type = 'RED_CARD' THEN 1 END) as red_cards
FROM players p
JOIN teams t ON p.team_id = t.id
LEFT JOIN matches m ON (m.home_team_id = t.id OR m.away_team_id = t.id) AND m.status = 'FINISHED'
LEFT JOIN match_events me ON me.match_id = m.id AND me.player_id = p.id
WHERE p.is_active = true
GROUP BY p.id, p.name, p.shirt_number, p.position, t.name;

-- View for team standings
CREATE VIEW team_standings AS
SELECT 
    t.id,
    t.name,
    t.short_name,
    COUNT(CASE WHEN m.status = 'FINISHED' THEN 1 END) as matches_played,
    COUNT(CASE WHEN m.status = 'FINISHED' AND m.result = 'WIN' THEN 1 END) as wins,
    COUNT(CASE WHEN m.status = 'FINISHED' AND m.result = 'DRAW' THEN 1 END) as draws,
    COUNT(CASE WHEN m.status = 'FINISHED' AND m.result = 'LOSS' THEN 1 END) as losses,
    COALESCE(SUM(CASE WHEN m.status = 'FINISHED' AND m.result = 'WIN' THEN 3 
                   WHEN m.status = 'FINISHED' AND m.result = 'DRAW' THEN 1 
                   ELSE 0 END), 0) as points,
    COALESCE(SUM(CASE WHEN m.status = 'FINISHED' THEN m.home_score ELSE 0 END), 0) as goals_for,
    COALESCE(SUM(CASE WHEN m.status = 'FINISHED' THEN m.away_score ELSE 0 END), 0) as goals_against,
    COALESCE(SUM(CASE WHEN m.status = 'FINISHED' THEN m.home_score ELSE 0 END), 0) - 
    COALESCE(SUM(CASE WHEN m.status = 'FINISHED' THEN m.away_score ELSE 0 END), 0) as goal_difference
FROM teams t
LEFT JOIN matches m ON (m.home_team_id = t.id)
WHERE t.id IS NOT NULL
GROUP BY t.id, t.name, t.short_name
ORDER BY points DESC, goal_difference DESC, goals_for DESC;

-- ========================================
-- SAMPLE DATA (Optional - for development)
-- ========================================

-- Insert sample teams (commented out for production)
-- INSERT INTO teams (name, short_name, founded_year, stadium_name, stadium_capacity) VALUES
-- ('Platzi FC', 'PFC', 2024, 'Estadio Platzi', 25000),
-- ('Rival Team', 'RIV', 2023, 'Estadio Rival', 20000);

-- Insert sample players (commented out for production)
-- INSERT INTO players (team_id, name, shirt_number, position, date_of_birth, nationality) VALUES
-- ((SELECT id FROM teams WHERE short_name = 'PFC'), 'Juan García', 1, 'GOALKEEPER', '1995-06-15', 'Spain'),
-- ((SELECT id FROM teams WHERE short_name = 'PFC'), 'Carlos Rodríguez', 10, 'FORWARD', '1998-03-22', 'Spain');

-- ========================================
-- COMMENTS
-- ========================================

/*
This schema supports all the main features outlined in the Platzi FC project:

1. **Core Entities**: Teams, Players with full relationships
2. **Matches & Competitions**: Complete match management with events
3. **Content Management**: News and multimedia with CMS integration support
4. **E-commerce**: Products, variants, orders with full order management
5. **Contact & Forms**: Contact submissions and newsletter management
6. **System Features**: Audit logs, settings, and performance optimizations

Key design decisions:
- UUID primary keys for distributed systems compatibility
- Comprehensive indexing for performance
- Enum types for data consistency
- Audit trail for all important operations
- Views for common statistical queries
- Triggers for automatic timestamp management
- External ID fields for CMS and API integrations

The schema is normalized but includes denormalized views for performance where needed.
All tables include created_at/updated_at timestamps for audit purposes.
*/
