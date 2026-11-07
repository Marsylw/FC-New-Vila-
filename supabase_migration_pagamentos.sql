-- ====================================================================
-- FC NEW VILA - MIGRAÇÃO PARA SUPABASE: QUOTAS, EQUIPAMENTOS E DEVEDORES
-- ====================================================================
-- Instruções:
-- 1. Abre o painel do teu Supabase (https://supabase.com).
-- 2. No menu lateral esquerdo, clica em "SQL Editor".
-- 3. Cola o código abaixo e clica em "Run" (Executar).
-- ====================================================================

-- 1. ESTRUTURA PARA TABELA DE PAGAMENTOS
-- Adiciona colunas para identificar tipo de pagamento, mês de referência,
-- item de equipamento liquidado e notas adicionais.
ALTER TABLE IF EXISTS pagamentos 
  ADD COLUMN IF NOT EXISTS tipo TEXT DEFAULT 'quota',
  ADD COLUMN IF NOT EXISTS mes_referencia TEXT,
  ADD COLUMN IF NOT EXISTS item_equipamento TEXT,
  ADD COLUMN IF NOT EXISTS observacoes TEXT;

-- 2. ESTRUTURA PARA TABELA DE PEDIDOS DE EQUIPAMENTO
-- Adiciona identificador do item/material e o valor correspondente.
ALTER TABLE IF EXISTS pedidos_equipamento
  ADD COLUMN IF NOT EXISTS item TEXT DEFAULT 'Kit Principal Oficial',
  ADD COLUMN IF NOT EXISTS valor NUMERIC DEFAULT 5000;

-- 3. ÍNDICES PARA CONSULTAS RÁPIDAS NO ADMIN E PERFIL
CREATE INDEX IF NOT EXISTS idx_pagamentos_jogador ON pagamentos(jogador_id);
CREATE INDEX IF NOT EXISTS idx_pagamentos_tipo ON pagamentos(tipo);
CREATE INDEX IF NOT EXISTS idx_pagamentos_data ON pagamentos(data_pagamento);
CREATE INDEX IF NOT EXISTS idx_pedidos_jogador ON pedidos_equipamento(jogador_id);
CREATE INDEX IF NOT EXISTS idx_pedidos_estado ON pedidos_equipamento(estado);

-- 4. POLÍTICAS RLS (CASO RLS ESTEJA ATIVO)
-- Permite leitura e escrita pelo cliente anónimo autenticado
DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM pg_tables WHERE tablename = 'pagamentos') THEN
    ALTER TABLE pagamentos ENABLE ROW LEVEL SECURITY;
    DROP POLICY IF EXISTS "Permitir leitura de pagamentos" ON pagamentos;
    CREATE POLICY "Permitir leitura de pagamentos" ON pagamentos FOR SELECT USING (true);
    DROP POLICY IF EXISTS "Permitir insercao de pagamentos" ON pagamentos;
    CREATE POLICY "Permitir insercao de pagamentos" ON pagamentos FOR INSERT WITH CHECK (true);
    DROP POLICY IF EXISTS "Permitir alteracao de pagamentos" ON pagamentos;
    CREATE POLICY "Permitir alteracao de pagamentos" ON pagamentos FOR UPDATE USING (true);
    DROP POLICY IF EXISTS "Permitir remocao de pagamentos" ON pagamentos;
    CREATE POLICY "Permitir remocao de pagamentos" ON pagamentos FOR DELETE USING (true);
  END IF;

  IF EXISTS (SELECT 1 FROM pg_tables WHERE tablename = 'pedidos_equipamento') THEN
    ALTER TABLE pedidos_equipamento ENABLE ROW LEVEL SECURITY;
    DROP POLICY IF EXISTS "Permitir leitura de equipamentos" ON pedidos_equipamento;
    CREATE POLICY "Permitir leitura de equipamentos" ON pedidos_equipamento FOR SELECT USING (true);
    DROP POLICY IF EXISTS "Permitir insercao de equipamentos" ON pedidos_equipamento;
    CREATE POLICY "Permitir insercao de equipamentos" ON pedidos_equipamento FOR INSERT WITH CHECK (true);
    DROP POLICY IF EXISTS "Permitir alteracao de equipamentos" ON pedidos_equipamento;
    CREATE POLICY "Permitir alteracao de equipamentos" ON pedidos_equipamento FOR UPDATE USING (true);
    DROP POLICY IF EXISTS "Permitir remocao de equipamentos" ON pedidos_equipamento;
    CREATE POLICY "Permitir remocao de equipamentos" ON pedidos_equipamento FOR DELETE USING (true);
  END IF;
END $$;
