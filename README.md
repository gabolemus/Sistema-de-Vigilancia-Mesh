# Sistema de Vigilancia Mesh

## Descripción

Proyecto de sistema de video vigilancia empleando una red mesh ad-hoc con el protocolo de enrutamiento BATMAN-ADV.

## Archivos y Directorios

- [`public/`](public/): Directorio con los archivos públicos del sistema (React).
- [`scripts/`](scripts/): Directorio con los scripts de configuración y ejecución del sistema.
- [`src/`](src/): Directorio con los archivos fuente del sistema (React).
- [`src-net/`](src-net/): Directorio con los archivos fuente del sistema (C++).

## Requerimientos

1. Instalación de paquetes

Actualización de paquetes

```bash
sudo apt update -y && sudo apt upgrade -y
```

Instalación de paquetes de desarrollo y herramientas de networking

```bash
sudo apt install -y batctl iw gcc g++ gdb make cmake
```

Instalación de paquetes de NPM

```bash
npm install
```

2. Copiar y renombrar el archivo `.env.example` a `.env.local`

Después de copiar el archivo, es necesario modificar la variable `$iface` al nombre de la interfaz de red que se utilizará para la red mesh.

3. Correr la app de C++

Este programa se encarga de establecer la red mesh y de enviar el feed de las webcams a los nodos de la red.

```bash
npm run start-net
```

4. Correr la app de React

Esta aplicación se encarga de mostrar el feed de las webcams.

```bash
npm run start
```
