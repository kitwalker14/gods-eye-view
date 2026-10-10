# God's Eye View — containerized Vite dev server (integrates backend API proxy)
FROM node:24-bookworm

WORKDIR /app

# Skip Chromium download (puppeteer is a dev/test dependency we don't run here)
ENV PUPPETEER_SKIP_DOWNLOAD=1 \
    PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=1 \
    NODE_ENV=development

# Install dependencies against the lockfile first for better layer caching
COPY package.json package-lock.json ./
RUN npm ci

# App source
COPY . .

# Served by vite; backend provider proxy is wired in via the vite plugin
ENV HOST=0.0.0.0 \
    PORT=4173 \
    GEV_ALLOWED_HOSTS=godseye.lwk.space

EXPOSE 4173

CMD ["npm", "run", "dev"]
