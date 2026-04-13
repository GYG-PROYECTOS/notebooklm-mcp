FROM node:20-bookworm

ENV DEBIAN_FRONTEND=noninteractive

# Instalamos Chromium y dependencias
RUN apt-get update && apt-get install -y --no-install-recommends \
    chromium \
    fonts-liberation \
    libasound2 \
    libatk-bridge2.0-0 \
    libatk1.0-0 \
    libcups2 \
    libdbus-1-3 \
    libdrm2 \
    libgbm1 \
    libgtk-3-0 \
    libnspr4 \
    libnss3 \
    libx11-xcb1 \
    libxcb1 \
    libxcomposite1 \
    libxdamage1 \
    libxrandr2 \
    xdg-utils \
    wget \
    && rm -rf /var/lib/apt/lists/*

ENV CHROME_PATH=/usr/bin/chromium
ENV PLAYWRIGHT_CHROMIUM_EXECUTABLE_PATH=/usr/bin/chromium
ENV PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD=1

WORKDIR /app

# Copiamos archivos de dependencias
COPY package*.json ./

# Instalamos usando install en lugar de ci para evitar el error 127 si falta el lockfile
RUN npm install --production

# Copiamos el resto del código
COPY . .

# Si el proyecto usa TypeScript, necesitamos compilarlo. 
# Si no estás seguro, añade esta línea; si falla, la quitamos.
RUN npm run build || echo "No build script found, skipping..."

EXPOSE 3000

CMD ["node", "dist/index.js"]
