#!/usr/bin/env bash
set -euo pipefail

VENV_DIR=".venv"

echo "Criando ambiente virtual em ${VENV_DIR}..."
python3 -m venv "${VENV_DIR}"

echo "Atualizando pip..."
"${VENV_DIR}/bin/python" -m pip install --upgrade pip

echo "Instalando dependências de requirements.txt..."
"${VENV_DIR}/bin/pip" install -r requirements.txt

echo "Registrando kernel Jupyter para o ambiente virtual..."
"${VENV_DIR}/bin/python" -m ipykernel install --user --name=mestrado-censo --display-name="Python (mestrado-censo)"

echo ""
echo "Instalação concluída!"
echo "Para ativar o ambiente virtual, execute:"
echo "  source ${VENV_DIR}/bin/activate"

