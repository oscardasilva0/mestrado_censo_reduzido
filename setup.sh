#!/usr/bin/env bash
set -euo pipefail

VENV_DIR=".venv"

echo "=========================================================="
echo " Setup do Projeto: Mestrado Censo Reduzido"
echo "=========================================================="

# 1. Verifica se o python3 está instalado
if ! command -v python3 &>/dev/null; then
    echo "Erro: python3 não encontrado. Por favor, instale o Python 3." >&2
    exit 1
fi

# 2. Cria o ambiente virtual caso não exista
if [ ! -d "${VENV_DIR}" ]; then
    echo "Criando ambiente virtual em ${VENV_DIR}..."
    python3 -m venv "${VENV_DIR}"
else
    echo "Ambiente virtual já existente em ${VENV_DIR}."
fi

# 3. Atualiza o gerenciador de pacotes pip
echo "Atualizando pip..."
"${VENV_DIR}/bin/python" -m pip install --upgrade pip

# 4. Instala as dependências do requirements.txt
echo "Instalando dependências de requirements.txt..."
"${VENV_DIR}/bin/pip" install -r requirements.txt

# 5. Registra o kernel no Jupyter
echo "Registrando kernel Jupyter (mestrado-censo)..."
"${VENV_DIR}/bin/python" -m ipykernel install --user --name=mestrado-censo --display-name="Python (mestrado-censo)"

echo ""
echo "=========================================================="
echo " Instalação concluída com sucesso!"
echo " Para ativar o ambiente virtual, execute:"
echo "   source ${VENV_DIR}/bin/activate"
echo " Para iniciar o Jupyter Notebook:"
echo "   jupyter notebook"
echo "=========================================================="
