#include <stdio.h>
#include <fcntl.h>
#include <unistd.h>
#include <stdlib.h>

int main(int argc, char **argv) {
  if (argc != 3) {
    printf("[ERROR] La estructura del comando es mycp <fichero origen> <fichero destino>\n");
    return -1;
  }

  int fd_origen = open(argv[1], O_RDONLY);

  if (fd_origen < 0){
    perror("Error al abrir el archivo origen");
    return -1;
  }

  int fd_destino = open(argv[2], O_WRONLY | O_CREAT | O_TRUNC, 0666);

  if (fd_destino < 0){
    perror("Error al abrir/crear el archivo destino");
    return -1;
  }

  char buffer[1024];
  ssize_t bytes_leidos;

  while((bytes_leidos = read(fd_origen, buffer, sizeof(buffer)) > 0)){
    ssize_t bytes_escritos = write(fd_destino, buffer, (size_t) bytes_leidos);

    if (bytes_escritos != bytes_leidos){
      perror("Error al escribir los datos en el buffer destino");
      close(fd_destino);
      close(fd_origen);
      return -1;
    }


  }
  
  if (bytes_leidos < 0){
    perror("Error al leer el archivo origen");

  }
  
  close(fd_destino);
  close(fd_origen);


  return 0;
}
