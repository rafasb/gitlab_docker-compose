#!/bin/bash

# Importamos el FQDN del host
if [ -f .env ]; then
    # Load Environment Variables
    export $(grep -v '^#' .env | xargs)
fi

#Generamos la clave privada para el certificado raíz de la CA privada. 
#Puedes generar una contraseña con: openssl rand -base64 14
echo 'Clave de certificado raíz. Se solicita en el siguiente paso: '
read n
openssl genrsa -aes256 -out certs/ca-root.key --passout pass:$n 2048

echo '######################################'
echo 'GENERACIÓN DE CERTIFICADO RAÍZ PRIVADO'
echo 'Solicita el password usado anteriormente, Código del país, estado-provincia, ciudad, organización, unidad organizativa y CN (CommonName)'
echo 'Pulsa intro '
read x
openssl req -x509 -new -nodes -key certs/ca-root.key -sha256 -days 1825 -out certs/ca-root.pem

#Generamos una clave privada para nuestro servidor.
openssl genrsa -out certs/$FQDNHOSTNAME.key 2048

#Generamos un CSR para la firma posterior por parte de la CA
#Solicita el password usado anteriormente, Código del país, estado-provincia, ciudad, organización, unidad organizativa y CN (CommonName)
#IMPORTANTE: CN es el nombre FQDN del host que empleará el certificado, es decir el valor de FQDNHOSTNAME.
echo '######################################'
echo 'GENERACIÓN DE SOLICITUD DE CERTIFICADO'
echo 'Solicita el password usado anteriormente, Código del país, estado-provincia, ciudad, organización, unidad organizativa y '
echo 'CN (CommonName). Este último debe coincidir con el valor FQDNHOSTNAME del fichero .env'
echo 'EN ESTE PASO NO PONGAS NINGUNA CLAVE'
echo 'Pulsa intro '
read x
openssl req -new -key certs/$FQDNHOSTNAME.key -out certs/$FQDNHOSTNAME.csr

#Preparamos una extensión para el campo SAN
cat <<'EOF'  >certs/$FQDNHOSTNAME.ext
authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
subjectAltName = @alt_names

[alt_names]
DNS.1 = FQDNHOSTNAME
EOF
sed -i s/FQDNHOSTNAME/$FQDNHOSTNAME/g certs/$FQDNHOSTNAME.ext

#Firmamos nuestra clave privada del host con la clave raíz
echo '#################################'
echo 'FIRMA Y GENERACIÓN DE CERTIFICADO'
echo 'Requiere del password introducido en el primer paso (certificado raíz)'
openssl x509 -req -in certs/$FQDNHOSTNAME.csr -CA certs/ca-root.pem -CAkey certs/ca-root.key \
    -CAcreateserial -out certs/$FQDNHOSTNAME.crt -days 365 -sha256 -extfile certs/$FQDNHOSTNAME.ext

#Mostramos el resultado del certificado
echo '##################################'
echo 'DATOS DEL CERTIFICADO DEL SERVICIO'
openssl x509 -in certs/$FQDNHOSTNAME.crt -text

echo ' '
echo 'CERTIFICADOS LISTOS'