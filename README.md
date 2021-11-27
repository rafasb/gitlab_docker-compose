# Despligue local de GitLab

Gitlab es una plataforma muy completa para desarrollo. Tiene, entre otras, las funcionalidades de:

1) Servidor Git para control de versiones

2) Servicio de CI/CD

3) Registro de imágenes de contenedores 

## Pasos previos 

**Establecer valores de entorno**

En el fichero **.env** debemos establecer los valores de nombre del host con el valor de FQDN que apunta a la IP del host.
Así mismo debemos establecer el directorio de almacenamiento de datos.
Ambos datos se emplearán en la creación del contenedor.

**Disponer de certificados**

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

## Referencias
https://deliciousbrains.com/ssl-certificate-authority-for-local-https-development/
https://stackoverflow.com/questions/55747402/docker-gitlab-change-forgotten-root-password

