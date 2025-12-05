CREATE DATABASE dad_chefs_production;
CREATE DATABASE dad_chefs_production_cache;
CREATE DATABASE dad_chefs_production_queue;
CREATE DATABASE dad_chefs_production_cable;

-- Enable pgvector extension for the main database
\c dad_chefs_production
CREATE EXTENSION IF NOT EXISTS vector;