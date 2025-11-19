-- create_pgaudit.sql
-- 在默认 'postgres' 数据库中尝试创建 pgaudit 扩展
-- 如果你想在其它数据库/脚本中创建扩展，请根据需求调整
CREATE EXTENSION IF NOT EXISTS pgaudit;
