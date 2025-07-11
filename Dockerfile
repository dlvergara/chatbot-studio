# Usa una imagen oficial de Node.js 20+ con soporte para apt-get
FROM node:20

# Establece el usuario root
USER root

# Define el directorio de trabajo
WORKDIR /usr/src/app

RUN apt-get update && apt-get install -y \
    libnss3 \
    libatk1.0-0 \
    libatk-bridge2.0-0 \
    libcups2 \
    libxkbcommon-x11-0 \
    libxcomposite1 \
    libxrandr2 \
    libgbm1 \
    libpango-1.0-0 \
    libpangocairo-1.0-0 \
    libxdamage1 \
    libxshmfence1 \
    libasound2 \
    libxcb1 \
    libxfixes3

# Instala dependencias necesarias
RUN apt-get update \
    && apt-get install -y curl gnupg \
    && npm install -g npm@latest \
    && npm cache clean --force \
    && node -v

# Instala Node-RED manualmente en vez de usar una imagen preconfigurada
RUN npm install -g --unsafe-perm node-red

# Ajusta permisos para evitar errores en módulos
RUN mkdir -p /usr/local/lib/node_modules \
    && chmod -R 777 /usr/local/lib/node_modules

# Instala el módulo de WhatsApp en Node-RED
RUN rm -rf node_modules package-lock.json \
    && npm install --no-cache --legacy-peer-deps node-red-contrib-whatsapp-link --save

RUN npm install node-red-contrib-google-sheets --save
RUN npm install dotenv --save

# Define volumen para persistencia de datos
VOLUME /usr/src/app/data

# Expone el puerto estándar
EXPOSE 1880

# Comando de inicio
CMD ["node-red", "--userDir", "/usr/src/app/data"]