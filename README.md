# Mestrado Censo Reduzido: Estimação de Renda Domiciliar com XGBoost

[![Abrir no Google Colab](https://colab.research.google.com/assets/colab-badge.svg)](https://colab.research.google.com/github/oscardasilva0/mestrado_censo_reduzido/blob/master/xg_boost2_1.ipynb)

Projeto de pesquisa voltado à estimação da renda domiciliar em salários mínimos (`renda_sal_min_V7617`) a partir dos microdados do **Censo Demográfico 2000 (IBGE)**, utilizando modelos de **Gradient Boosting (XGBoost 2.0+)** com ponderação amostral (`peso_amostral_P001`).

---

## 🎯 Objetivos e Metodologia

O notebook principal [`xg_boost2_1.ipynb`](xg_boost2_1.ipynb) implementa um pipeline completo de Machine Learning:

1. **Tratamento dos Microdados**: Carga e padronização das variáveis sociodemográficas e de infraestrutura do domicílio, mantendo faltantes numéricos para aprendizado nativo de árvores.
2. **Divisão Amostral Estratificada**: Partição da base de Salvador (BA) em Treino (56%), Validação (24%) e Teste (20%) com pesos amostrais.
3. **Modelo Baseline**: Ajuste inicial com perda Pseudo-Huber e early stopping monitorado por SMAPE ponderado.
4. **Otimização Bayesiana (5-Fold CV)**: Calibração de hiperparâmetros de regularização e exploração de famílias de perdas (`reg:pseudohubererror`, `reg:tweedie`, etc.).
5. **Teste de Generalização Espacial Externa**: Treinamento do modelo em **Salvador (BA)** e avaliação de desempenho e drift espacial em **Brasília (DF)**.
6. **Experimento de Robustez (Sem 1º Decil)**: Análise comparativa do comportamento do modelo ao excluir a faixa de pobreza extrema no treinamento.

---

## 🚀 Como Executar

### Opção 1: Google Colab (Recomendado / Em Nuvem)
Clique no badge acima ou abra diretamente pelo link:  
👉 [Abrir xg_boost2_1.ipynb no Google Colab](https://colab.research.google.com/github/oscardasilva0/mestrado_censo_reduzido/blob/master/xg_boost2_1.ipynb)

> O notebook está configurado para instalar automaticamente as bibliotecas ausentes e importar os microdados diretamente via URLs do GitHub (`popn_2000_salvador.csv` e `popn_2000_brasilia.csv`), sem necessidade de download manual.

---

### Opção 2: Execução Local (Linux / macOS)

1. **Clone o repositório:**
   ```bash
   git clone https://github.com/oscardasilva0/mestrado_censo_reduzido.git
   cd mestrado_censo_reduzido
   ```

2. **Execute o script de configuração:**
   ```bash
   chmod +x setup.sh
   ./setup.sh
   ```
   *O script cria o ambiente virtual `.venv`, atualiza o `pip`, instala todas as dependências do `requirements.txt` e registra o kernel do Jupyter.*

3. **Ative o ambiente e abra o Jupyter:**
   ```bash
   source .venv/bin/activate
   jupyter notebook xg_boost2_1.ipynb
   ```

---

## 📦 Estrutura do Repositório

```text
mestrado_censo_reduzido/
├── xg_boost2_1.ipynb           # Notebook principal com pipeline XGBoost e experimentos
├── popn_2000_salvador.csv       # Amostra de microdados do Censo 2000 para Salvador (BA)
├── popn_2000_brasilia.csv       # Amostra de microdados do Censo 2000 para Brasília (DF)
├── requirements.txt            # Dependências Python do projeto
├── setup.sh                    # Script de automação de ambiente virtual e kernel
└── README.md                   # Documentação do projeto
```

---

## 🛠️ Tecnologias e Bibliotecas

- **Python 3.10+**
- **[XGBoost](https://xgboost.readthedocs.io/)** ($\ge$ 2.0.0): Algoritmo de gradient boosting ponderado.
- **[Bayesian Optimization](https://github.com/bayesian-optimization/BayesianOptimization)**: Otimização bayesiana de hiperparâmetros.
- **[scikit-learn](https://scikit-learn.org/)**: Métricas de regressão ponderadas (RMSE, MAE, R²).
- **[sktime](https://www.sktime.net/)**: Métrica SMAPE ponderada por pesos censitários.
- **[pandas](https://pandas.pydata.org/)** e **[numpy](https://numpy.org/)**: Manipulação de dados e álgebra vetorial.
- **[matplotlib](https://matplotlib.org/)**: Visualização de diagnósticos por decis e aderência.

