# Cambiamos a Alpine, que es mucho más estable para despliegues rápidos
FROM node:20-alpine

# Instalamos dependencias para Chromium en Alpine
RUN apk add --no-cache \
      chromium \
      nss \
      freetype \
      harfbuzz \
      ca-certificates \
      ttf-freefont \
      nodejs \
      npm

# Variables para que Playwright sepa dónde está Chromium en Alpine
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true \
    PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser \
    CHROME_PATH=/usr/bin/chromium-browser \
    PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD=1 \
    PLAYWRIGHT_CHROMIUM_EXECUTABLE_PATH=/usr/bin/chromium-browser

WORKDIR /app

# Copiamos solo los archivos de dependencias primero (para usar el caché)
COPY package.json ./

# Instalamos las dependencias
# Usamos --no-audit para ir más rápido y evitar bloqueos
RUN npm install --production --no-audit

# Copiamos el resto de los archivos
COPY . .

# Intentamos compilar si existe el script, si no, seguimos adelante
RUN npm run build --if-present

EXPOSE 3000

# Ejecutamos con la ruta completa para que no haya error 127
CMD ["/usr/local/bin/node", "dist/index.js"]
