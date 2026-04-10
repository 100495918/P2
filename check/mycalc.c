#include "mycalc.h"
#include <string.h>
#include <stdlib.h>
#include <unistd.h>
#include <stdio.h>

int mycalc(int argc, char **argv) {
  
  char buffer_salida[1024]; // Nuestro "cubo" de texto
  int longitud; // Para medir cuántas letras vamos a escribir

  if (argc != 4) {
    longitud = snprintf(buffer_salida, sizeof(buffer_salida), "[ERROR] La estructura del comando es mycalc <operando 1> <operador> <operando 2>\n");
    // Escribimos el error en la salida de errores (descriptor 2)
    if(write(STDERR_FILENO, buffer_salida, (size_t)longitud) < 0){
      perror("Error al escribir");
      return -1;
    }
    return -1;
  }

  int a = atoi(argv[1]);
  int b = atoi(argv[3]);
  int resultado = 0;

  if (strcmp(argv[2], "+") == 0){
    resultado = a + b;
  }
  else if (strcmp(argv[2], "-") == 0){
    resultado = a - b;
  }
  else if (strcmp(argv[2], "x") == 0){
    resultado = a * b;
  }
  else if (strcmp(argv[2], "/") == 0){
    if(b == 0){
      longitud = snprintf(buffer_salida, sizeof(buffer_salida), "[ERROR] No se puede dividir por 0\n");
      if  (write(STDERR_FILENO, buffer_salida, (size_t)longitud) < 0){
        perror("Error al escribir");
        return -1;
      }
      return -1; 
    }
    resultado = a / b;
  }
  else{
    longitud = snprintf(buffer_salida, sizeof(buffer_salida), "[ERROR] El operador no es válido\n");
    if (write(STDERR_FILENO, buffer_salida, (size_t)longitud) < 0){
      perror("Error al escribir");
      return -1;
    }
    return -1; 
  }

  // Preparamos la frase del resultado final en memoria
  longitud = snprintf(buffer_salida, sizeof(buffer_salida), "Operación: %d %s %d = %d\n", a, argv[2], b, resultado);
  
  // Usamos la LLAMADA AL SISTEMA pura para enviarlo a la salida estándar
  if(write(STDOUT_FILENO, buffer_salida, (size_t)longitud) < 0){
    perror("Error al escribir");
    return -1;
  }

  return 0;
}
