#!/bin/bash

# ============================================================
#   Flutter Clean Architecture - Scaffold Generator
#   ينشئ المجلدات والملفات الفارغة فقط
# ============================================================

GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BOLD='\033[1m'
RESET='\033[0m'

echo ""
echo -e "${CYAN}${BOLD}╔══════════════════════════════════════════════════════╗${RESET}"
echo -e "${CYAN}${BOLD}║   Flutter Clean Architecture - Scaffold Generator    ║${RESET}"
echo -e "${CYAN}${BOLD}╚══════════════════════════════════════════════════════╝${RESET}"
echo ""

read -p "$(echo -e ${YELLOW}${BOLD}"Enter the feature name (e.g., product): "${RESET})" FEATURE_RAW

if [[ -z "$FEATURE_RAW" ]]; then
  echo -e "${RED}❌ You didn't enter a name!${RESET}"
  exit 1
fi

FEATURE=$(echo "$FEATURE_RAW" | tr '[:upper:]' '[:lower:]' | tr ' ' '_')
BASE_PATH="lib/features/${FEATURE}"

if [[ -d "$BASE_PATH" ]]; then
  echo -e "${RED}⚠️  The feature '${FEATURE}' already exists.${RESET}"
  read -p "$(echo -e ${YELLOW}"Do you want to overwrite it? (y/n): "${RESET})" OVERWRITE
  if [[ "$OVERWRITE" != "y" ]]; then
    echo -e "${CYAN}Cancelled.${RESET}"
    exit 0
  fi
fi

echo ""
echo -e "${CYAN}⚙️  Creating scaffold for ${BOLD}${FEATURE}${RESET}"
echo ""

make() {
  local PATH_="$1"
  mkdir -p "$(dirname "$PATH_")"
  touch "$PATH_"
  echo -e "  ${GREEN}✔${RESET} $PATH_"
}

# ══════════════════════════════════════════════════════════════
echo -e "${BOLD}📂 Domain${RESET}"
make "${BASE_PATH}/domain/entities/${FEATURE}_entity.test.dart"
make "${BASE_PATH}/domain/repositories/${FEAtestTURE}_repository.test.dart"
make "${BASE_PATH}/domain/usecases/get_${FEATURE}s_usecase.test.dart"
make "${BASE_PATH}/domain/usecases/get_${FEATURE}_by_id_usecase.test.dart"
make "${BASE_PATH}/domain/usecases/create_${FEATURE}_usecase.test.dart"

echo ""
echo -e "${BOLD}📂 Data${RESET}"
make "${BASE_PATH}/data/models/${FEATURE}_model.test.dart"
make "${BASE_PATH}/data/datasources/${FEATURE}_remote_datasource.test.dart"
make "${BASE_PATH}/data/datasources/${FEATURE}_local_datasource.test.dart"
make "${BASE_PATH}/data/repositories/${FEATURE}_repository_impl.test.dart"

echo ""
echo -e "${BOLD}📂 Presentation${RESET}"
make "${BASE_PATH}/presentation/pages/${FEATURE}s_page.test.dart"
make "${BASE_PATH}/presentation/widgets/${FEATURE}_card.test.dart"
make "${BASE_PATH}/presentation/widgets/${FEATURE}_list.test.dart"
make "${BASE_PATH}/presentation/widgets/${FEATURE}_search_bar.test.dart"
make "${BASE_PATH}/presentation/controllers/${FEATURE}_controller.test.dart"
make "${BASE_PATH}/presentation/controllers/${FEATURE}_binding.test.dart"

# ══════════════════════════════════════════════════════════════
echo ""
echo -e "${CYAN}${BOLD}╔══════════════════════════════════════════════════════╗${RESET}"
echo -e "${CYAN}${BOLD}║             scaffold created successfully            ║${RESET}"
echo -e "${CYAN}${BOLD}╚══════════════════════════════════════════════════════╝${RESET}"
echo ""
find "$BASE_PATH" -type f | sort | sed 's|^|   |'
echo ""