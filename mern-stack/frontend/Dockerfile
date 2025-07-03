# ---------- Build Stage ----------
FROM node:18.9.1-alpine AS builder
RUN adduser -D builderuser
USER builderuser

WORKDIR /app

COPY package.json package-lock.json ./
RUN npm ci

COPY --chown=builderuser:builderuser . .

ARG VITE_API_URL
ENV VITE_API_URL=$VITE_API_URL

RUN npm run build


# ---------- Runtime Stage ----------
FROM node:18.9.1-alpine AS runner

RUN adduser -D appuser && npm install -g vite

USER appuser

WORKDIR /home/appuser/app

# Copy built production files
COPY --from=builder --chown=appuser:appuser /app/dist ./dist
COPY --from=builder --chown=appuser:appuser /app/package.json ./
COPY --from=builder --chown=appuser:appuser /app/vite.config.js ./vite.config.js
COPY --from=builder --chown=appuser:appuser /app/node_modules ./node_modules


# Run the app using vite preview
CMD ["npm", "run", "start"]
