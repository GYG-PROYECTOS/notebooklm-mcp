FROM node:20-bookworm

ENV DEBIAN_FRONTEND=noninteractive
ENV PATH=/usr/local/bin:/usr/bin:/bin:$PATH

WORKDIR /app
COPY package*.json ./
RUN node --version && which npm && npm install && npm cache clean --force
RUN npx patchright install chromium --with-deps
COPY . .
RUN mkdir -p /root/.local/share/notebooklm-mcp && npm run build

EXPOSE 3000
CMD ["node", "dist/http-wrapper.js"]
