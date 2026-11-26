# Predição de Renda Domiciliar e Redução de Variáveis — Microdados do Censo IBGE (2000 e 2010)

[![Open In Colab - Censo 2000](https://colab.research.google.com/assets/colab-badge.svg)](https://colab.research.google.com/github/oscardasilva0/mestrado_censo_reduzido/blob/master/ml.ipynb)
[![Open In Colab - Censo 2010](https://colab.research.google.com/assets/colab-badge.svg)](https://colab.research.google.com/github/oscardasilva0/mestrado_censo_reduzido/blob/master/ml%20_2010.ipynb)

**Atalhos para Execução no Google Colab:**
- **Censo 2000 (`ml.ipynb`):** [Abrir no Google Colab](https://colab.research.google.com/github/oscardasilva0/mestrado_censo_reduzido/blob/master/ml.ipynb)
- **Censo 2010 (`ml _2010.ipynb`):** [Abrir no Google Colab](https://colab.research.google.com/github/oscardasilva0/mestrado_censo_reduzido/blob/master/ml%20_2010.ipynb)

Este repositório contém o pipeline de extração, tratamento, modelagem preditiva e seleção de variáveis (*feature selection*) aplicado aos microdados da amostra de domicílios dos **Censos Demográficos do IBGE de 2000 e 2010** para o município de **Salvador - BA** (código IBGE `2927408`).

O objetivo central do projeto é treinar modelos baseados em *Gradient Boosting* (`XGBRegressor`) para estimar a renda mensal domiciliar a partir das características físicas do domicílio e posse de bens, avaliando a viabilidade de um **conjunto reduzido de variáveis ("Censo Reduzido")** sem perda significativa de poder preditivo.

---

## Estrutura do Projeto

```text
mestrado_censo_reduzido/
├── baixar_dados.qmd               # Script R/Quarto para download dos microdados de Salvador (Censo 2000)
├── baixar_dados_2010.qmd          # Script R/Quarto para download dos microdados de Salvador (Censo 2010)
├── 2000_dictionary_microdata.xlsx # Dicionário oficial de variáveis dos microdados (Censo 2000)
├── 2010_dictionary_microdata.xlsx # Dicionário oficial de variáveis dos microdados (Censo 2010)
├── salvador.csv                   # Base bruta extraída do Censo 2000 (66.348 domicílios, 87 colunas)
├── salvador_2010.csv              # Base bruta extraída do Censo 2010 (44.502 domicílios, 83 colunas)
├── etl.ipynb                      # Notebook exploratório inicial de tipagem e limpeza (Censo 2000)
├── ml.ipynb                       # Pipeline completo de tratamento, treino e redução de variáveis (Censo 2000)
├── ml _2010.ipynb                 # Pipeline completo de tratamento, treino e redução de variáveis (Censo 2010)
└── README.md                      # Documentação e guia de execução do projeto
```

---

## Pré-requisitos e Instalação

O projeto utiliza **R** para a extração dos microdados oficiais do IBGE (via pacote `censobr`) e **Python** para o pré-processamento, modelagem e otimização de hiperparâmetros.

### 1. Ambiente R — Coleta de Dados *(Opcional)*
> **Nota:** Esta etapa é **opcional**, pois os arquivos extraídos (`salvador.csv` e `salvador_2010.csv`) já estão disponíveis na raiz do projeto.

Necessário apenas caso deseje baixar novamente as bases a partir do pacote `censobr`:
```r
install.packages(c("censobr", "dplyr", "arrow"))
```

### 2. Ambiente Python (Tratamento e Machine Learning)
Recomenda-se Python 3.10+ em um ambiente virtual (`.venv` ou `conda`):
```bash
pip install pandas numpy scikit-learn xgboost optuna scipy matplotlib jupyter
```

---

## Fluxo de Execução Passo a Passo

### Etapa 1: Extração dos Microdados (R / Quarto) — *(Opcional)*
> **Observação:** Esta etapa é **opcional**, pois os arquivos `salvador.csv` e `salvador_2010.csv` já estão presentes na raiz do repositório. Você pode iniciar a execução diretamente na **Etapa 2**.

1. **Censo 2000 (`baixar_dados.qmd`):**
   - Utiliza `censobr::read_households(year = 2000)` filtrando `code_muni == 2927408` (Salvador) e exporta `salvador.csv`.
2. **Censo 2010 (`baixar_dados_2010.qmd`):**
   - Utiliza `censobr::read_households(year = 2010)` filtrando `code_muni == 2927408` (Salvador) e exporta `salvador_2010.csv`.

---

### Etapa 2: Preparação e Tipagem dos Dados (Python)
A preparação das bases nos notebooks segue os dicionários `2000_dictionary_microdata.xlsx` e `2010_dictionary_microdata.xlsx`:

0. **Carregamento do Arquivo (Local ou Ambiente Virtual / Google Colab):**
   - **Execução Local:** O arquivo é lido diretamente da raiz do projeto (`salvador.csv` ou `salvador_2010.csv`).
   - **Execução em Ambiente Virtual / Nuvem (Google Colab):** Caso o arquivo não esteja no diretório local do ambiente virtual, o carregamento pode ser feito diretamente via URL do GitHub:
     - **Censo 2000:** [https://github.com/oscardasilva0/mestrado_censo_reduzido/blob/master/salvador.csv](https://github.com/oscardasilva0/mestrado_censo_reduzido/blob/master/salvador.csv)
     - **Censo 2010:** [https://github.com/oscardasilva0/mestrado_censo_reduzido/blob/master/salvador_2010.csv](https://github.com/oscardasilva0/mestrado_censo_reduzido/blob/master/salvador_2010.csv)
     ```python
     # Censo 2000 (ambiente virtual / Colab via GitHub)
     url_2000 = "https://github.com/oscardasilva0/mestrado_censo_reduzido/blob/master/salvador.csv?raw=true"
     dados_censo = pd.read_csv(url_2000)

     # Censo 2010 (ambiente virtual / Colab via GitHub)
     url_2010 = "https://github.com/oscardasilva0/mestrado_censo_reduzido/blob/master/salvador_2010.csv?raw=true"
     dados_censo = pd.read_csv(url_2010)
     ```

1. **Renomeação Semântica:** Os códigos originais do IBGE (ex.: `V0201`, `V0203`, `V6529` / `V7616`) são renomeados para nomes descritivos mantendo o código original como sufixo (ex.: `condicao_oculpacao_V0201`, `n_comodos_V0203`, `renda_V6529`).
2. **Limpeza da Variável Alvo e Colunas Auxiliares:**
   - Remoção de registros em que a variável resposta de renda domiciliar (`renda_V7616` em 2000; `renda_V6529` em 2010) é nula.
   - Remoção das colunas de marca de imputação do IBGE (`_M0201` a `_M0701`) e variáveis de identificação geográfica constantes para o município de Salvador (`code_muni`, `code_state`, `uf`, `regiao`, `mesoregiao`, `microregiao`).
3. **Tipagem e Tratamento de Nulos (`ml.ipynb` e `ml _2010.ipynb`):**
   - Conversão das variáveis qualitativas para o tipo `category` e variáveis quantitativas para `int64` / `float64`.
   - Tratamento de valores ausentes (preenchimento de aluguel com `0` em 2010, criação de categoria para condição de ocupação do terreno em 2000 e medidor de energia/internet em 2010, imputação de esgoto pela moda da área de ponderação `code_weighting`, e remoção de registros com mais de 70% de variáveis nulas).

---

### Etapa 3: Treinamento, Otimização e Seleção de Variáveis

Dentro dos notebooks de modelagem (`ml.ipynb` e `ml _2010.ipynb`), a execução segue a seguinte ordem:

1. **Definição de `X` e `Y` e Divisão Amostral:**
   - **Variáveis removidas de `X`:** Variáveis de renda derivadas (`renda_sal`, `renda_percapita`, `renda_percapita_sal`), peso amostral (`peso_P001` / `peso_V0010`) e área de ponderação (`AREAP` / `AREAP_V0011`).
   - **Transformação do Alvo:** $Y = \ln(1 + \text{renda})$ via `np.log1p()` para comprimir a assimetria positiva da distribuição de renda.
   - **Particionamento (`train_test_split` com `random_state=42`):**
     - `X_test`, `y_test`: 33% da base total para avaliação final.
     - `X_treino`, `y_treino`: 67% da base total, subdivididos em `X_train` (80% do treino) e `X_val` (20% do treino para *early stopping*).
2. **Treinamento Inicial (`XGBRegressor`):**
   - Configurado com `enable_categorical=True`, `tree_method="hist"`, `objective="reg:absoluteerror"`, `eval_metric="mphe"` e `early_stopping_rounds=50`.
3. **Avaliação de Métricas (`avaliar_metricas`):**
   - As predições são revertidas da escala logarítmica para Reais (R\$) via `np.expm1()` e avaliadas no treino e no teste pelas métricas: **$R^2$**, **MAE (R\$)**, **MAPE**, **MSE (R\$²)**, **RMSE (R\$)** e **$D^2$** (`d2_absolute_error_score`).
4. **Otimização Bayesiana de Hiperparâmetros (`Optuna`):**
   - Executa 20 *trials* com validação cruzada (`cv=3`) maximizando o `d2_absolute_error_score` para buscar a melhor combinação de `n_estimators`, `learning_rate`, `max_depth` e `subsample`.
5. **Importância e Redução de Variáveis (*Feature Importance*):**
   - Extrai a importância relativa (`reg.feature_importances_`) das variáveis do modelo, plota o ranking das *Top 15* variáveis mais importantes e re-treina o `XGBRegressor` apenas com o subconjunto reduzido (`X_reduzido` — 12 variáveis no Censo 2000 e 13 a 14 variáveis no Censo 2010) para verificar a estabilidade das métricas após a redução do questionário.

