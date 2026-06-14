# Github Configurations
import  'justfiles/gitconfig.just'
import  'justfiles/nasm.just'
import  'justfiles/appium.just'
import  'justfiles/ssh.just'

# Muestra la lista de comandos
default:
   just --list

# Ajusta el volumen segun el nivel deseado
[linux]
vol level:
   @pactl set-sink-volume 0 {{ level }}% 

# Adiciona los archivos locales 
[linux]
sdot:
   stow --adopt .

# Inicializar los submodulos de mi configuracion de vim
[linux]
st:
    @git status

# Adicion de submodulos
[linux]
gasm httproute pcroute: 
    git submodule add {{ httproute }} {{ pcroute }}

# Inicializa los submodulos
[linux]
fetch-packs:
	git submodule init
	git submodule update

# Make update-packs :: updates the plugins
[linux]
update-packs:
	git submodule update --remote

# Limpia la cache del sistema operativo
[linux]
clean-cache:
	rm -rf ~/.cache/

# Inicializa el servicio de postgresql
[linux]
start-postgresql:
	@sudo systemctl start postgresql.service

# Habilita el servicio de postgresql
[linux]
enable-postgresql:
	@sudo systemctl enable postgresql.service

# Muestra el estado del servicio de postgresql
[linux]
status-postgresql:
	@sudo systemctl status postgresql.service

# Detiene el servicio de postgresql
[linux]
stop-postgresql:
	@sudo systemctl stop postgresql.service

# Lista los paquetes a instalar en el sistema operativo al instalar la distro
[linux]
untar file:
	@tar -xvf {{file}}

# Comando para inicializar el reparador de disco de gnome
[linux]
gd:
	@sudo gnome-disks

# Limpia la cache de npm 
[linux]
clean-npm:
	rm -rf ~/.npm/

# Actualiza rust a la ultima version
[linux]
update-rust:
    @echo "Actualizando a ultima version de rust"
    @rustup self update
    @echo "Ultima version actualizada"
    @echo "Actualizando a ultima version de los paquetes de rust"
    @rustup update
    @echo "Ultima version de los paquetes actualizada"

# Ve las herramientas que se necesita para trabajar en el sistema
[linux]
compile-tools:
    @nasm --version
    @gcc  --version
    @g++  --version  

# Elimina un paquete y sus dependencias subyacentes
[linux]
remove pkg:
    @sudo apt remove --purge {{pkg}} && sudo apt autoremove

# Lista los programas por tamanio de mayor a menor
[linux]
pkg-list:
    @echo  "SIZE  |  PACKAGE" 
    @echo  "----------------" 
    @dpkg-query -Wf '${Installed-Size}\t${Package}\n' | sort -rn | head -20

# Instala el paquete deseado
[linux]
install pkg:
    @sudo apt install {{pkg}}

