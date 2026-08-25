-- models/marts/fct_desvio_previsao.sql
{{
    config(
        materialized='table',
        schema='marts'
    )
}}

WITH base AS (
    SELECT *
    FROM {{ ref('int_clima_diario') }}
    WHERE fonte_dados = 'fcst'  -- Usando apenas os dados disponíveis
),

-- Calcular médias por cidade para usar como referência
medias_cidade AS (
    SELECT
        cidade,
        ROUND(AVG(temperatura), 2) AS temp_media,
        ROUND(AVG(precipitacao), 2) AS precip_media,
        ROUND(AVG(sensacao), 2) AS sensacao_media,
        ROUND(AVG(umidade), 2) AS umidade_media,
        COUNT(*) AS total_dias_referencia,
        MIN(data) AS data_inicio_referencia,
        MAX(data) AS data_fim_referencia
    FROM base
    GROUP BY cidade
),

-- Calcular desvios diários em relação à média da cidade
desvios_calculados AS (
    SELECT
        b.cidade,
        b.data,
        b.temperatura,
        b.precipitacao,
        b.sensacao,
        b.umidade,
        b.fonte_dados,
        m.temp_media,
        m.precip_media,
        m.sensacao_media,
        m.umidade_media,
        m.total_dias_referencia,
        -- Desvios absolutos (comparando com a média)
        ROUND(b.temperatura - m.temp_media, 2) AS desvio_temperatura,
        ROUND(b.precipitacao - m.precip_media, 2) AS desvio_precipitacao,
        ROUND(b.sensacao - m.sensacao_media, 2) AS desvio_sensacao,
        ROUND(b.umidade - m.umidade_media, 2) AS desvio_umidade,
        -- Desvios percentuais
        ROUND((b.temperatura - m.temp_media) / NULLIF(m.temp_media, 0) * 100, 2) AS pct_desvio_temperatura,
        ROUND((b.precipitacao - m.precip_media) / NULLIF(m.precip_media, 0) * 100, 2) AS pct_desvio_precipitacao,
        ROUND((b.sensacao - m.sensacao_media) / NULLIF(m.sensacao_media, 0) * 100, 2) AS pct_desvio_sensacao,
        ROUND((b.umidade - m.umidade_media) / NULLIF(m.umidade_media, 0) * 100, 2) AS pct_desvio_umidade,
        -- Classificação dos desvios de temperatura
        CASE 
            WHEN ABS(b.temperatura - m.temp_media) > 5 THEN 'Desvio Extremo'
            WHEN ABS(b.temperatura - m.temp_media) > 3 THEN 'Desvio Significativo'
            WHEN ABS(b.temperatura - m.temp_media) > 1 THEN 'Desvio Moderado'
            ELSE 'Dentro da Média'
        END AS classificacao_desvio_temp,
        -- Classificação dos desvios de precipitação
        CASE 
            WHEN ABS(b.precipitacao - m.precip_media) > 5 THEN 'Desvio Extremo'
            WHEN ABS(b.precipitacao - m.precip_media) > 3 THEN 'Desvio Significativo'
            WHEN ABS(b.precipitacao - m.precip_media) > 1 THEN 'Desvio Moderado'
            ELSE 'Dentro da Média'
        END AS classificacao_desvio_precip,
        -- Flag para identificar dias atípicos
        CASE 
            WHEN ABS(b.temperatura - m.temp_media) > 5 
              OR ABS(b.precipitacao - m.precip_media) > 5 THEN 'ATIPICO'
            ELSE 'NORMAL'
        END AS flag_atipico
    FROM base b
    LEFT JOIN medias_cidade m ON b.cidade = m.cidade
)

SELECT *
FROM desvios_calculados
WHERE desvio_temperatura IS NOT NULL 
   OR desvio_precipitacao IS NOT NULL
ORDER BY cidade, data;