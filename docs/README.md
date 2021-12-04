# Despligue local de GitLab

Gitlab es una plataforma muy completa para desarrollo. Tiene, entre otras, las funcionalidades de:

1) Servidor Git para control de versiones

2) Servicio de CI/CD

3) Registro de imágenes de contenedores 

## Pasos previos 

1) Instalar docker** https://docs.docker.com/engine/install/ y https://docs.docker.com/engine/install/linux-postinstall/ 

2) Instalar docker-compose: https://docs.docker.com/compose/install/

3) Clonar el directorio con: `git clone: https://github.com/rafasb/gitlab_doker-compose.git`

4) Cambiar el directorio con: `cd gitlab_doker-compose`

5) **Establecer valores de entorno**

En el fichero **.env** debemos establecer los valores de nombre del host con el valor de FQDN que apunta a la IP del host.

Así mismo debemos establecer el directorio de almacenamiento de datos.

Ambos datos se emplearán en la creación del contenedor.

6) **Disponer de certificados**

Podemos cargar los certificados generados o adquiridos en este directorio, incluyendo la clave privada para el servicio (.key) y el certificado firmado por la CA (.crt).

Alternativamente disponemos del script gen-certs.sh que nos facilita la creación de una CA local y un certificado firmado por dicha CA para el servicio.

## Puesta en marcha del servicio

Hay que tener en cuenta que el arranque es muy lento.

Ejecutaremos la orden siguiente en el directorio del proyecto:

```bash 
docker-compose up -d 
```

## Acceso por primera vez

Por algún motivo el password por defecto parece no funcionar. Tampoco permite establecer el password en el arranque inicial. Por tanto, previamente hay que resetear el password de root con el siguiente procedimiento

En el host:
```bash 
docker exec -it gitlab_web_1 bash
```

Una vez dentro del contenedor:
```bash 
gitlab-rake "gitlab:password:reset[root]"
```

Solicitará password de root y confirmación.

## Notas finales

* Combiene no emplear las versiones latest y fijarlas en el docker-compose.

* Variables de entorno: Todos los valores de las variables de entorno deben ser cambiados para garantizar la seguridad (nombres de base de datos, nombres de usuario y sus contraseñas).

* Disponer de un sistema de backup para el directorio `datos`

* No es posible cambiar el **puerto 443** dado que el registro de imágenes de contenedores no puede emplear puertos alternativos.

* Este contenedor ha recibido muchas críticas ya que no sigue la política de separar los servicios en diferentes contenedores. Una misma imagen contiene la aplicación y la base de datos, además de otros servicios auxiliares.

* La aplicación es realmente potente y profesional, recomendamos el uso de la versión enterprise ya que rápidamente se convertirá en una pieza clave de cualquier desarrollo.

* La aplicación es muy pesada y consume bastantes recursos, comparados con otros proyectos que he realizado.

## Referencias

https://deliciousbrains.com/ssl-certificate-authority-for-local-https-development/

https://stackoverflow.com/questions/55747402/docker-gitlab-change-forgotten-root-password
