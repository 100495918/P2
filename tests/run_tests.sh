#!/bin/bash
# =============================================================================
# run_tests.sh - Ejecuta todas las pruebas de Uc3mshell y muestra los resultados
# Uso: bash run_tests.sh
# Debe ejecutarse desde el directorio raiz de la practica (donde esta uc3mshell)
# =============================================================================

SHELL_BIN="./uc3mshell"
TESTS_DIR="./tests"
OUT_DIR="/tmp/uc3mshell_test_results"
PASS=0
FAIL=0

# Colores
GREEN="\033[0;32m"
RED="\033[0;31m"
YELLOW="\033[1;33m"
CYAN="\033[0;36m"
RESET="\033[0m"

mkdir -p "$OUT_DIR"

check() {
    echo -e "${CYAN}--------------------------------------------------${RESET}"
    echo -e "${YELLOW}$1${RESET}"
    echo -e "${CYAN}--------------------------------------------------${RESET}"
}

run_test() {
    local num="$1"
    local desc="$2"
    local script="$3"
    local expect_fail="${4:-0}"   # 1 si se espera que el programa retorne error

    check "PRUEBA $num: $desc"
    echo -e "Script: $script\n"

    local stdout_file="$OUT_DIR/test${num}_stdout.txt"
    local stderr_file="$OUT_DIR/test${num}_stderr.txt"

    "$SHELL_BIN" "$script" >"$stdout_file" 2>"$stderr_file"
    local ret=$?

    echo -e "${YELLOW}--- STDOUT ---${RESET}"
    cat "$stdout_file"
    echo -e "${YELLOW}--- STDERR ---${RESET}"
    cat "$stderr_file"
    echo -e "${YELLOW}--- Codigo de retorno: $ret ---${RESET}"

    if [ "$expect_fail" -eq 1 ]; then
        if [ "$ret" -ne 0 ]; then
            echo -e "${GREEN}[OK] El programa termino con error como se esperaba (ret=$ret)${RESET}"
            PASS=$((PASS+1))
        else
            echo -e "${RED}[FAIL] Se esperaba error pero retorno 0${RESET}"
            FAIL=$((FAIL+1))
        fi
    else
        if [ "$ret" -eq 0 ]; then
            echo -e "${GREEN}[OK] El programa termino correctamente (ret=0)${RESET}"
            PASS=$((PASS+1))
        else
            echo -e "${RED}[FAIL] El programa retorno error inesperado (ret=$ret)${RESET}"
            FAIL=$((FAIL+1))
        fi
    fi
    echo ""
}

# Verificar que el binario existe
if [ ! -f "$SHELL_BIN" ]; then
    echo -e "${RED}ERROR: No se encuentra $SHELL_BIN. Compila la practica primero con 'make uc3mshell'.${RESET}"
    exit 1
fi

if [ ! -d "$TESTS_DIR" ]; then
    echo -e "${RED}ERROR: No se encuentra el directorio $TESTS_DIR.${RESET}"
    exit 1
fi

echo -e "${CYAN}============================================================${RESET}"
echo -e "${CYAN}   BATERIA DE PRUEBAS - Uc3mshell P2${RESET}"
echo -e "${CYAN}============================================================${RESET}"
echo ""

# --- PRUEBA 1: Encabezado incorrecto (debe fallar con ret != 0) ---
run_test "01" "Encabezado incorrecto (debe terminar con error)" \
    "$TESTS_DIR/test01_bad_header.sh" 1

# --- PRUEBA 2: Comandos simples ---
run_test "02" "Comandos simples sin y con argumentos" \
    "$TESTS_DIR/test02_simple_commands.sh"

# --- PRUEBA 3: Comentarios y lineas vacias ---
check "PRUEBA 03: Comentarios y lineas vacias"
echo -e "Script: $TESTS_DIR/test03_comments_empty.sh\n"
echo -e "${YELLOW}Salida esperada (solo estas dos lineas):${RESET}"
echo "  antes_del_vacio"
echo "  despues_del_vacio"
echo -e "${YELLOW}Salida obtenida:${RESET}"
stdout=$("$SHELL_BIN" "$TESTS_DIR/test03_comments_empty.sh" 2>/dev/null)
echo "$stdout"
if echo "$stdout" | grep -q "antes_del_vacio" && echo "$stdout" | grep -q "despues_del_vacio"; then
    echo -e "${GREEN}[OK]${RESET}"
    PASS=$((PASS+1))
else
    echo -e "${RED}[FAIL] No se encontraron las lineas esperadas${RESET}"
    FAIL=$((FAIL+1))
fi
echo ""

# --- PRUEBA 4: Pipes ---
run_test "04" "Secuencia de comandos con pipes (hasta 3)" \
    "$TESTS_DIR/test04_pipes.sh"

# --- PRUEBA 5: Redireccion entrada/salida ---
run_test "05" "Redirecciones de entrada (<) y salida (>)" \
    "$TESTS_DIR/test05_redirections_in_out.sh"

# --- PRUEBA 6: Redireccion de error ---
check "PRUEBA 06: Redireccion de error (!>)"
echo -e "Script: $TESTS_DIR/test06_redirect_error.sh\n"
"$SHELL_BIN" "$TESTS_DIR/test06_redirect_error.sh" 2>/dev/null
echo -e "${YELLOW}Verificando que el fichero de error fue creado...${RESET}"
if [ -f "/tmp/test6_error.txt" ] && [ -s "/tmp/test6_error.txt" ]; then
    echo -e "${GREEN}[OK] /tmp/test6_error.txt existe y tiene contenido:${RESET}"
    cat /tmp/test6_error.txt
    PASS=$((PASS+1))
else
    echo -e "${RED}[FAIL] /tmp/test6_error.txt no existe o esta vacio${RESET}"
    FAIL=$((FAIL+1))
fi
echo ""

# --- PRUEBA 7: Background ---
# NOTA: No usamos $() para capturar la salida porque bash esperaria a todos los
# subprocesos del pipeline, dando un falso fallo. Redirigimos a fichero directamente.
check "PRUEBA 07: Ejecucion en background (&)"
echo -e "Script: $TESTS_DIR/test07_background.sh\n"
echo -e "${YELLOW}Midiendo tiempo de ejecucion (no debe tardar 3 segundos)...${RESET}"
local_out="$OUT_DIR/test07_stdout.txt"
start_time=$(date +%s%N)
"$SHELL_BIN" "$TESTS_DIR/test07_background.sh" >"$local_out" 2>/dev/null
end_time=$(date +%s%N)
elapsed=$(( (end_time - start_time) / 1000000 ))
echo -e "${YELLOW}Salida obtenida:${RESET}"
cat "$local_out"
echo "Tiempo: ${elapsed}ms"
if [ "$elapsed" -lt 2500 ] && grep -q "esto_se_imprime_sin_esperar_sleep" "$local_out"; then
    echo -e "${GREEN}[OK] El background no bloqueo el interprete (${elapsed}ms < 2500ms)${RESET}"
    PASS=$((PASS+1))
else
    echo -e "${RED}[FAIL] El interprete parece haberse bloqueado esperando el proceso en background (${elapsed}ms)${RESET}"
    FAIL=$((FAIL+1))
fi
echo ""

# --- PRUEBA 8: exit ---
check "PRUEBA 08: Comando interno exit"
echo -e "Script: $TESTS_DIR/test08_exit.sh\n"
echo -e "${YELLOW}Salida esperada:${RESET}"
echo "  antes_de_exit_invalido"
echo "  [ERROR] El codigo de salida debe ser un numero entero"
echo "  tras_exit_pepe"
echo "  [ERROR] Falta codigo de salida"
echo "  tras_exit_sin_argumento"
echo "  Goodbye 3"
echo "  (NO debe aparecer 'esto_NO_debe_imprimirse')"
echo -e "${YELLOW}Salida obtenida:${RESET}"
stdout=$("$SHELL_BIN" "$TESTS_DIR/test08_exit.sh" 2>/dev/null)
echo "$stdout"
if echo "$stdout" | grep -q "Goodbye 3" && ! echo "$stdout" | grep -q "esto_NO_debe_imprimirse"; then
    echo -e "${GREEN}[OK] exit funciona correctamente${RESET}"
    PASS=$((PASS+1))
else
    echo -e "${RED}[FAIL] exit no funciona como se esperaba${RESET}"
    FAIL=$((FAIL+1))
fi
echo ""

# --- PRUEBA 9: mycalc ---
check "PRUEBA 09: Comando interno mycalc"
echo -e "Script: $TESTS_DIR/test09_mycalc.sh\n"
echo -e "${YELLOW}Salida esperada (operaciones validas):${RESET}"
echo "  Operacion: 5 + 3 = 8"
echo "  Operacion: 10 - 4 = 6"
echo "  Operacion: 4 x 3 = 12"
echo "  Operacion: 20 / 4 = 5"
echo "  [ERROR] en stderr para division por 0, operador invalido y sintaxis incorrecta"
echo -e "${YELLOW}Salida obtenida (stdout):${RESET}"
stdout=$("$SHELL_BIN" "$TESTS_DIR/test09_mycalc.sh" 2>/tmp/test09_stderr.txt)
echo "$stdout"
echo -e "${YELLOW}Salida obtenida (stderr):${RESET}"
cat /tmp/test09_stderr.txt
if echo "$stdout" | grep -q "5 + 3 = 8" && \
   echo "$stdout" | grep -q "4 x 3 = 12"; then
    echo -e "${GREEN}[OK] mycalc calcula correctamente${RESET}"
    PASS=$((PASS+1))
else
    echo -e "${RED}[FAIL] mycalc no produce la salida esperada${RESET}"
    FAIL=$((FAIL+1))
fi
echo ""

# --- PRUEBA 10: mycp ---
check "PRUEBA 10: Comando externo mycp"
echo -e "Script: $TESTS_DIR/test10_mycp.sh\n"
"$SHELL_BIN" "$TESTS_DIR/test10_mycp.sh" 2>/tmp/test10_stderr.txt
echo -e "${YELLOW}Verificando que los md5 de origen y copia coinciden...${RESET}"
md5_orig=$(md5sum scripts-ejemplo/test_dir/shrek.txt 2>/dev/null | awk '{print $1}')
md5_copy=$(md5sum /tmp/test10_copia_shrek.txt 2>/dev/null | awk '{print $1}')
if [ "$md5_orig" = "$md5_copy" ] && [ -n "$md5_orig" ]; then
    echo -e "${GREEN}[OK] Los ficheros son identicos (md5: $md5_orig)${RESET}"
    PASS=$((PASS+1))
else
    echo -e "${RED}[FAIL] Los md5 no coinciden o el fichero no se creo (orig=$md5_orig, copia=$md5_copy)${RESET}"
    FAIL=$((FAIL+1))
fi
echo -e "${YELLOW}Errores esperados en stderr (fichero inexistente, args incorrectos):${RESET}"
cat /tmp/test10_stderr.txt
echo ""

# --- PRUEBA 11: Combinacion avanzada ---
run_test "11" "Combinacion avanzada: pipes + redirecciones + background" \
    "$TESTS_DIR/test11_advanced.sh"

# --- RESUMEN FINAL ---
echo -e "${CYAN}============================================================${RESET}"
echo -e "${CYAN}   RESUMEN DE RESULTADOS${RESET}"
echo -e "${CYAN}============================================================${RESET}"
echo -e "  ${GREEN}Pasadas: $PASS${RESET}"
echo -e "  ${RED}Falladas: $FAIL${RESET}"
TOTAL=$((PASS+FAIL))
echo -e "  Total:   $TOTAL"
echo ""
if [ "$FAIL" -eq 0 ]; then
    echo -e "${GREEN}  Todas las pruebas pasaron correctamente.${RESET}"
else
    echo -e "${RED}  Hay $FAIL prueba(s) que no pasaron. Revisa la salida anterior.${RESET}"
fi
echo -e "${CYAN}============================================================${RESET}"
