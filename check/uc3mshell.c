#include "mycalc.h" // Includes mycalc.h
#include <fcntl.h>
#include <stdio.h>
#include <string.h>
#include <sys/wait.h>
#include <unistd.h>
#include <stdlib.h>
#include <ctype.h>
#include "mycalc.h"

const int max_line = 1024;
const int max_commands = 10;
#define max_redirections 3 // stdin, stdout, stderr
#define max_args 15

/* VARS TO BE USED FOR THE STUDENTS */
char *argvv[max_args];
char *filev[max_redirections];
int background = 0;

/**
 * This function splits a char* line into different tokens based on a given
 * character
 * @return Number of tokens
 */
int tokenizar_linea(char *linea, char *delim, char *tokens[], int max_tokens) {
  int i = 0;
  char *token = strtok(linea, delim);
  while (token != NULL && i < max_tokens - 1) {
    tokens[i++] = token;
    token = strtok(NULL, delim);
  }
  tokens[i] = NULL;
  return i;
}

/**
 * This function processes the command line to evaluate if there are
 * redirections. If any redirection is detected, the destination file is
 * indicated in filev[i] array. filev[0] for STDIN filev[1] for STDOUT filev[2]
 * for STDERR
 */
void procesar_redirecciones(char *args[]) {
  int i = 0, first_red = -1;

  // Store the pointer to the filename if needed.
  for (i = 0; args[i] != NULL; i++) {

    if (strcmp(args[i], "<") == 0) {
      filev[0] = args[i + 1];
      if (first_red == -1)
        first_red = i;
    } else if (strcmp(args[i], ">") == 0) {
      filev[1] = args[i + 1];
      if (first_red == -1)
        first_red = i;
    } else if (strcmp(args[i], "!>") == 0) {
      filev[2] = args[i + 1];
      if (first_red == -1)
        first_red = i;
    }
  }

  // starting from the first redirectorion, all fields are set to NULL
  if (first_red != -1)
    for (i = first_red; args[i] != NULL; i++) {
      args[i] = NULL;
    }
}

/**
 * This function processes the input command line and returns in global
 * variables: argvv -- command an args as argv filev -- files for redirections.
 * NULL value means no redirection. background -- 0 means foreground; 1
 * background.
 */
int procesar_linea(char *linea) {

  char *comandos[max_commands];
  int num_comandos = tokenizar_linea(linea, "|", comandos, max_commands);
  if (num_comandos == 0) {
    /* Para evitar la violación de segmento que daba con el num_comandos = 0*/  
    return 0;
  }
  background = 0;

  // Check if background is indicated
  if (strchr(comandos[num_comandos - 1], '&')) {
    background = 1;
    char *pos = strchr(comandos[num_comandos - 1], '&');
    // removes character &
    *pos = '\0';
  }

  filev[0] = NULL;
  filev[1] = NULL;
  filev[2] = NULL;
  // Finish processing

  int in_fd = 0;
  int fd[2];
  pid_t pid = 0;

  for (int i = 0; i < num_comandos; i++) {

    tokenizar_linea(comandos[i], " \t\n", argvv, max_args);
    procesar_redirecciones(argvv);

    if (i < (num_comandos -1)){
      if(pipe(fd) < 0) {
        perror("Error al crear la tubería");
        exit(-1);
      };
    }



    if (argvv[0] == NULL){
      /* Esto hace que no de error si encuentra una cadena con NULL*/
      continue;
    }

    if (strcmp(argvv[0], "exit" )== 0){

      if (argvv[1] == NULL){
        printf("[ERROR] Falta codigo de salida\n");
        continue;
      }

      int es_numero = 1;
      for( int j = 0; argvv[1][j] != '\0'; j++ ){

        if(j == 0 && argvv[1][j] == '-'){ /* Esto es para el caso de que sea un número negativo*/
          continue;

        }

        if(!isdigit(argvv[1][j])){
          es_numero = 0;
          break;
        }

      }

      if (es_numero == 0){
        printf("[ERROR] El codigo de salida debe ser un numero entero\n");
        continue;
      }
      while (wait(NULL) > 0){}

        // 4. Despedida y cierre definitivo de la shell
      printf("Goodbye %s\n", argvv[1]);
      exit(0); 
    }

    else if (strcmp(argvv[0], "mycalc") == 0){
      int arg_mycalc = 0;
      while(argvv[arg_mycalc] != NULL){
        arg_mycalc++;
      }

      int copia_stdout = -1;
      if (filev[1] != NULL){
        int salida_red = open(filev[1], O_WRONLY|O_CREAT|O_TRUNC, 0666);
        if (salida_red >= 0){

          copia_stdout = dup(STDOUT_FILENO); /* Guardamos la pantalla*/
          dup2(salida_red, STDOUT_FILENO); /* Redirigimos la salida al archivo que hemos abierto*/
          close(salida_red);
        }
      }
      mycalc(arg_mycalc, argvv);

      /* Restauramos la salida*/

      if (copia_stdout != -1){

        dup2(copia_stdout, STDOUT_FILENO);
        close(copia_stdout);
      }
      
      continue;
    }
    for (int j = 1; argvv[j] != NULL; j++) { /* Bucle para quitar las comillas de los argumentos*/
        size_t len = strlen(argvv[j]);
      
        if (len >= 2 && argvv[j][0] == '"' && argvv[j][len - 1] == '"') {
            
            argvv[j][len - 1] = '\0';
            
            
            argvv[j] = argvv[j] + 1; 
        }
    }

    pid = fork();

    if ( pid < 0){

      perror("Error al realizar el fork");
      exit(-1);
    }

    else if (pid == 0){
      /* Proceso hijo*/

      if (in_fd != 0){
        dup2(in_fd, STDIN_FILENO);
        close(in_fd);
      }

      if (i < (num_comandos -1)){
        dup2(fd[1], STDOUT_FILENO);
        close(fd[1]);
        close(fd[0]);
      }

      if (filev[0] != NULL){
        int entrada_red = open(filev[0], O_RDONLY);

        if (entrada_red < 0){
          perror("Error al abrir el fichero de entrada");
          exit(-1);
        }
        dup2(entrada_red, STDIN_FILENO);
        close(entrada_red);
      }

      if (filev[1] != NULL){
        int salida_red = open(filev[1], O_WRONLY | O_CREAT | O_TRUNC, 0666);

        if (salida_red < 0){
          perror("Error al abrir el fichero de salida");
          exit(-1);
        }
        dup2(salida_red, STDOUT_FILENO);
        close(salida_red);
      }

      if (filev[2] != NULL){
        int error_red = open(filev[2], O_WRONLY | O_CREAT | O_TRUNC, 0666);
        if(error_red < 0){
          perror("Error al abrir el fichero de error");
          exit(-1);
        }

        dup2(error_red, STDERR_FILENO);
        close(error_red);
      }
      if (strcmp(argvv[0], "mycp") == 0){
        argvv[0] = "./mycp";
      }



      execvp(argvv[0], argvv);
      perror("Error al ejecutar el comando");
      exit(-1);

    }
    else{
      /* Proceso Padre*/

      if (in_fd != 0){
        close(in_fd);

      }
      if(i < (num_comandos -1)){
        close(fd[1]);
        in_fd = fd[0];
      }
    }
    
  }

  if (background == 0){
    for (int i = 0; i< num_comandos ; i++){
      wait(NULL);

    }
  }
  else{
    printf("%d\n", pid);
  }
  return num_comandos;
}

int main(int argc, char *argv[]) {

  /*printf("Running %s with %d arguments\n", argv[0], argc - 1); */

  /* STUDENTS CODE MUST BE HERE */
  if (argc != 2){
    perror("Número de argumentos incorrecto");
    return -1;

  }
  int fd;

  if ((fd = open(argv[1], O_RDONLY)) < 0){

    perror("Error al abrir el archivo");
    return -1;

  }

  char buffer[1024];
  int i = 0;
  char c;
  ssize_t bytes_leidos;
  int primera_linea = 1;

  while ((bytes_leidos = read(fd, &c, 1)) > 0){
    if (c == '\n'){
      buffer[i] = '\0';

      if (primera_linea == 1){
        primera_linea = 0;
        if (strcmp(buffer, "## Uc3mshell P2") != 0){
          perror("La primera línea no es ## Uc3msheell P2");
          return -1;
        }
      }
      else{
        procesar_linea(buffer);
      }
      i = 0;
    }
    else{
        buffer[i] = c;
        i++;

        if (i >= 1023){
          break;
      }

    }

  }
  if (i>0){
    buffer[i] = '\0';
    if (primera_linea == 0){
      procesar_linea(buffer);
    }
  }
  close(fd);
  return 0;
}
