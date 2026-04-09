# English version below
# Sistemas Operativos - Práctica 2 

## Uso de los Scripts de Ejemplo

Los archivos `1-basic-bash.sh` y `2-medium-bash.sh` son scripts que se pueden ejecutar en la shell de Linux de la siguiente manera:

```bash
bash ./scripts-ejemplo/1-basic-bash.sh
bash ./scripts-ejemplo/2-medium-bash.sh
```

Estos scripts te ayudarán a entender cómo desarrollar tu práctica, ya que proporcionan un conjunto de comandos válidos que se espera que ejecute tu programa.

Los archivos `1-basic-uc3mshell.sh` y `2-medium-uc3mshell.sh` están pensados para ser ejecutados por tu programa. Por ejemplo:

```bash
./uc3mshell ./scripts-ejemplo/1-basic-uc3mshell.sh 
./uc3mshell ./scripts-ejemplo/2-medium-uc3mshell.sh
```
Recomendamos **redirigir la salida estándar (stdout) y la salida de error (stderr) a archivos separados**.

* Para la shell de Linux:

    ```bash
    # 1-basic-bash
    bash ./scripts-ejemplo/1-basic-bash.sh > scripts-ejemplo/bashdir/1-std.txt 2> scripts-ejemplo/bashdir/1-err.txt
    ```

    ```bash
    # 2-medium-bash
    bash ./scripts-ejemplo/2-medium-bash.sh > scripts-ejemplo/bashdir/2-std.txt 2> scripts-ejemplo/bashdir/2-err.txt
    ```

* Para uc3mshell:

    ```bash
    #1-basic-uc3mshell
    ./uc3mshell ./scripts-ejemplo/1-basic-uc3mshell.sh > scripts-ejemplo/studentdir/1-std.txt 2> scripts-ejemplo/studentdir/1-err.txt
    ```

    ```bash
    #2-medium-uc3mshell
    ./uc3mshell ./scripts-ejemplo/2-medium-uc3mshell.sh > scripts-ejemplo/studentdir/2-std.txt 2> scripts-ejemplo/studentdir/2-err.txt
    ```

Después, puedes **comparar ambas salidas**:

```bash
# 1-basic
diff scripts-ejemplo/bashdir/1-std.txt scripts-ejemplo/studentdir/1-std.txt
diff scripts-ejemplo/bashdir/1-err.txt scripts-ejemplo/studentdir/1-err.txt
#2-medium
diff scripts-ejemplo/bashdir/2-std.txt scripts-ejemplo/studentdir/2-std.txt
diff scripts-ejemplo/bashdir/2-err.txt scripts-ejemplo/studentdir/2-err.txt
```

> **Importante** La salida estándar de la prueba "2-medium" podría variar ligeramente, pero solo en lo que respecta al PID del proceso en segundo plano.


## English version 
# Operating Systems - Lab 2

## Usage of the Example Scripts

The files `1-basic-bash.sh` and `2-medium-bash.sh` are scripts that can be executed in a regular Linux shell as follows:

```bash
bash ./scripts-ejemplo/1-basic-bash.sh
bash ./scripts-ejemplo/2-medium-bash.sh
```


These scripts may help you understand how to develop your lab assignment, as they provide a set of valid commands that are expected to be executed by your program.

The files `1-basic-uc3mshell.sh` and `2-medium-uc3mshell.sh` are expected to be executed by your program. For example:

```bash
./uc3mshell ./scripts-ejemplo/1-basic-uc3mshell.sh 
./uc3mshell ./scripts-ejemplo/2-medium-uc3mshell.sh
```

We recommend **to redirec the standard output and standard error to separate files**.

* For the Linux shell:
    ```bash
    # 1-basic-bash
    bash ./scripts-ejemplo/1-basic-bash.sh > scripts-ejemplo/bashdir/1-std.txt 2> scripts-ejemplo/bashdir/1-err.txt
    ```

    ```bash
    # 2-medium-bash
    bash ./scripts-ejemplo/2-medium-bash.sh > scripts-ejemplo/bashdir/2-std.txt 2> scripts-ejemplo/bashdir/2-err.txt
    ```


* For uc3mshell:
    ```bash
    #1-basic-uc3mshell
    ./uc3mshell ./scripts-ejemplo/1-basic-uc3mshell.sh > scripts-ejemplo/studentdir/1-std.txt 2> scripts-ejemplo/studentdir/1-err.txt
    ```
    ```bash
    #2-medium-uc3mshell
    ./uc3mshell ./scripts-ejemplo/2-medium-uc3mshell.sh > scripts-ejemplo/studentdir/2-std.txt 2> scripts-ejemplo/studentdir/2-err.txt
    ```


Then, **you should compare both outputs**:
```bash
# 1-basic
diff scripts-ejemplo/bashdir/1-std.txt scripts-ejemplo/studentdir/1-std.txt
diff scripts-ejemplo/bashdir/1-err.txt scripts-ejemplo/studentdir/1-err.txt
#2-medium
diff scripts-ejemplo/bashdir/2-std.txt scripts-ejemplo/studentdir/2-std.txt
diff scripts-ejemplo/bashdir/2-err.txt scripts-ejemplo/studentdir/2-err.txt
```

> **Important**
> The standard output of the "2-medium" test might differ slightly, but only regarding the PID of the background process.