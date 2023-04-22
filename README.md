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
