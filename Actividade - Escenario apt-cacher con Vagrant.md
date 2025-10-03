# Actividade - Escenario apt-cacher con Vagrant



Temos unha rede interna chamada E-ATP-CACHER-LAN 172.16.1.1/24. 

O equipo Router (R) vai a estar conectado a tres redes:

- NAT de Vagrant.

- Externa en modo Bridge: A IP debe ser  da túa casa ou do centro se fas o exercicio no instituto. O gateway será o do centro ou a da túa casa.

- Interna: 172.16.1.0/24

**Agora explicamos como facelo.**

## Exercicio 1

Descarga os arquivos do proxecto de Vagrant que tes dipoñible nesta [enlace](https://github.com/dani-medina/Actividade_--_Escenario_apt-cacher_con_Vagrant/blob/main/ficheiros/E-Apt-Cacher.zip).

Fai as modificacións necesarias nos arquivos para que o equipo ROUTER se comporto como un ROUTER NAT. Para iso:

1. Cambia o Vagrantfile para que a segunda tarxeta de rede poida traballar en modo bridge. Proba que funciona e que tes tres tarxeta na máquina virtual: NAT, Bridge e Interna.


2. Cambia o Vagrantfile para que asigne unha IP á tarxeta Bridge. Fíxate que hai un script na sección provision que o fai. Bótalle un ollo ao script e modificao para que a tarxeta bridge teña unha ip válida na rede da túa casa. Probao facendo un ip a na máquina virtual e facendo ping a equipos na túa casa.


3. Cambia o Vagranfile para que cambie a ruta por defecto/gateway do router e deixe de saír a través da rede NAT de vagrant e saía pola rede Bridge. Fíxate que hai un script na sección provision que o fai. Modifícao para que se adapte á rede da túa casa. Probao facendo un ip r e facendo ping a equipos externos (google.com).


4. Cambia o Vagrantfile para que o router sexa capaz de converterse nun router NAT. Para elo tes que descomentar a liña do nftables do Vagrantfile. Ademais tes que editar o script ntftables.conf e poñer a ip que ten a tarxeta bridge para que faga NAT. Para probalo terás que poñer outra máquina (Windows ou Linux) na rede interna E-ATP-CACHER-LAN, darlle unha ip, máscara, gateway (ip interna da máquina router) e dns e probar que sae a internet. Isto último non o tes que facer con Vagrant.





## Exercicio 2

Mediante Vagrant e traballando sobre o vagrantfile do exercicio anterior...

Crea unha nova máquina nova, APT-Cacher baseada en Debian. Fai os cambios necesarios para que esta máquina saia a internet a través da máquina ROUTER e non dende o interface LAN de Vagrant. Tes un script que te pode axudar.

Despois, ten que ofrecer o servizo apt-cacher para a rede 172.16.1.0/24. Tes unha guía no Anexo 1 de como configurar o servizo apt-cacher nos arquivos adxuntos.



## Exercicio 3

Utilizando bucles crea 3 máquinas de tipo Debian:

- que estean na rede 172.16.1.0/24. 
- cambia os reposisitorios no arquivo /etc/apt/sources.list para que utilicen o protocolo http e non https.
- teñen que configurarse para utilicen o servidor apt-cacher como caché de paquetes e despois instalar algún software (apache, destktop...)



## Exercicio 4

Mediante o vagrantfile consegue:

- Na máquina APT-Cacher se reinicie o servizo apt-cacher-ng todos os días as 4:33 AM.
- Nas máquinas clientes consegue que polo menos unha vez o día se execute un apt update.



## Entrega

Crea un arquivo comprimido no que inclúas o vagrantfile e todos os arquivos de aprovisionamento que fixeses para o escenario (non inclúas o directorio .vagrant)


No mesmo comprimido debes incluir:

- Unha captura onde se vexan os logs do apt-cacher-ng.
- Unha captura onde se vexan o panel de administración web onde se vexa a eficacia da caché.













## Anexo I

### Instalación do servizo apt-cacher

A máquina ten que ter saída a internet e ip estática.

* Como a descarga dos paquetes dende os clientes faise vía web (protocolo HTTP) temos que instalar o paquete **apache2** no servidor apt-cacher. Este paquete é un servidor web.
* A continuación xa podemos instalar o software **apt-cacher-ng** para que este equipo faga de caché.

###  Configuración do servizo apt-cacher-ng.

O directorio cos arquivos de configuración do servidor apt-cacher-ng é **/etc/apt-cacher-ng**. Ten varios de arquivos de configuración.

Edita o **/etc/apt-cacher-ng/acng.conf** e modifica as seguintes liñas:

```
PassThroughPattern : .*
VfileUseRangeOps: -1
```

Se non están presente as engades.

Crea o arquivo **/etc/apt-cacher-ng/security.conf** e ponlle o seguinte contido:

```
AdminAuth:teunome:abc123..
```

Por último, para que os cambios nos arquivos de configuración se apliquen tes que reiniciar o serivzo.

```
systemctl restart apt-cacher-ng
```

### Configuración dos clientes.

* Consulta que IP e que teñen os clientes ou ponlle unha onde está o apt-cacher e comproba que tes conectividade enviando pings entre as máquinas.
* No cliente configura configura o cliente apt para que utilice apt-cacher. Creamos o arquivo /etc/apt/apt.conf.d/01-apt-proxy.conf e poñemos a seguinte liña:

```
Acquire::http { Proxy "http://IP-do-servidor-apt-cacher:3142"; }

```


### Verificar o funcionamento

No servidor podemos observar que os clientes están utilizando o apt-cacher monitorizando o arquivo /var/log/apt-cacher/acces.log. Para iso:

    ```
    tail -f /var/log/apt-cacher/access.log
    ```

Vai aos clientes e instala os mesmos paquetes e ambos. Inmediatamente vemos como xa hai movementos no log  do apt-cacher do servidor. No log vemos que cada descarga provoca un MISS (pois é a primeira vez que se descarga esa información e a descarga desde internet). Se o facemos con outro cliente veremos que cambia os MISS por HIT (xa o ten o servidor apt-cacher).

![Log apt-cacher](https://github.com/dani-medina/Actividade_--_Escenario_apt-cacher_con_Vagrant/blob/main/imaxes/apt-cacher-log.png?raw=true)

Ademais se accedes dende un navegador web ao apt-cacher en http://IP_do_servidor:3142 verás o interface de administración e tamén a eficacia da caché.



![Eficacia da cachéº](https://github.com/dani-medina/Actividade_--_Escenario_apt-cacher_con_Vagrant/blob/main/imaxes/apt-cacher-web.png?raw=true)


## Autor

Daniel Medina Méndez

[www.linkedin.com/in/daniel-medina-méndez](www.linkedin.com/in/daniel-medina-méndez)

## Licenza do documento

[![Creative Commons License](https://i.creativecommons.org/l/by-sa/4.0/88x31.png)](http://creativecommons.org/licenses/by-sa/4.0/)

This work is licensed under a [Creative Commons Attribution-ShareAlike 4.0 International License](http://creativecommons.org/licenses/by-sa/4.0/)
