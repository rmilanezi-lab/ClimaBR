{% docs __overview__ %}
# 🌤️ Projeto ClimaBR - Análise Climática com dbt + Athena

Este projeto tem como objetivo construir uma solução de engenharia e análise de dados meteorológicos usando o **dbt** com o **Amazon Athena**, consumindo dados da **API da Visual Crossing**. A arquitetura segue boas práticas com camadas `staging`, `intermediate` e `marts`.

---

## 📌 Objetivos
- Ingerir, padronizar e enriquecer dados climáticos históricos e de previsão
- Estruturar uma arquitetura em camadas no dbt para análises confiáveis
- Medir desvios entre previsão e dados observados
- Gerar indicadores mensais por cidade com agregações climáticas

---

## 🧱 Estrutura do Projeto

```bash

├── models/
│   ├── staging/
│   │   └── stg_clima.sql               # Modelo raw dos dados da API
│   ├── intermediate/
│   │   └── int_clima_diario.sql        # Enriquecimento dos dados climáticos
│   └── marts/
│       ├── fact_analise_mensal.sql     # Fato mensal de métricas climáticas
│       └── fact_desvio_previsao.sql    # Fato com desvio entre previsão e combinado
│
```

---

## 🗃️ Fontes de Dados
- [Visual Crossing Weather API](https://www.visualcrossing.com/weather-data-editions)

---

## 🔍 Exemplos de Métricas
- Temperatura média, sensação térmica, umidade, precipitação, amplitude térmica, horas de sol, fase da lua, condição climática predominante, desvio entre previsão e valor combinado

---

## 🛠️ Tecnologias
- [dbt-core](https://docs.getdbt.com/docs/introduction) 1.9+
- Amazon Athena
- S3 (como staging e destino dos dados processados)

---

## 📈 Resultado Esperado
O projeto entrega modelos analíticos prontos para consumo em dashboards, relatórios e sistemas de alerta, com foco em análise climática histórica e previsão confiável.

---

## 👨‍💻 Autor
**ClimaBR by Carlos Oliveira**  
Engenharia de Dados | AWS | dbt | Athena
{% enddocs %}
