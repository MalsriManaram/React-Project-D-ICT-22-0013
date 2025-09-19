# ---- Build stage ----
FROM node:18-alpine AS builder
WORKDIR /app

COPY package*.json ./
RUN npm ci --no-audit --no-fund

COPY . .

# Added this for Vite + Alpine
ENV NODE_OPTIONS=--openssl-legacy-provider

# Build production assets
RUN npm run build

# ---- Runtime stage ----
FROM nginx:alpine
# Copy build to Nginx html directory
COPY --from=builder /app/dist /usr/share/nginx/html


EXPOSE 80

# Minimal healthcheck (optional)
HEALTHCHECK --interval=30s --timeout=3s \
  CMD wget -qO- http://localhost/ || exit 1
