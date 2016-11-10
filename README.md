# ServerSpec

### Prerequisitos
  - Debe estar desplegado en la misma red que las maquinas que queremos comprobar
  - Las maquinas a testear tienen que estar desplegadas de ante mano

### Description
Esta automatización nos permite comprobar el estado del SW dentro de las maquinas de la red. Para ello ha de desplegarse un servidor central (ServerSpec) que lanzará una serie de consulta a los nodos de la red.
Actualmente comprueba:
  - Memoria
  - Disco
  - Red
  - SW desplegado
  - Servicios levantados

### Instalation guide:
  * Install ruby, zypper install git-core
```
  1. yum install gcc-c++ patch readline readline-devel zlib zlib-devel
  2. yum install libyaml-devel libffi-devel openssl-devel make
  3. yum install bzip2 autoconf automake libtool bison iconv-devel sqlite-devel
  4. gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
  5. \curl -sSL https://get.rvm.io | bash -s stable
  6. source /etc/profile.d/rvm.sh
  7. rvm install 2.1.8
  8. rvm use 2.1.8 --default
  9. ruby --version
```
  * Install rspec, gem install rspec
```
  1. gem install rspec
```
  * Install ServerSpec, gem install serverspec
```
  1. gem install serverspec
```
  * Dowload the project, git clone ..
  * Remember to modify the IP node to test
  * Execute!, rake
