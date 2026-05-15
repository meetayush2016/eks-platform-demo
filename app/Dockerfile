# ─── STAGE 1: builder ────────────────────────────────────────────────────────
FROM node:18-alpine AS builder

WORKDIR /app

# Dependencies first — this layer gets cached
# Only invalidates if package.json or package-lock.json changes
COPY package*.json ./

RUN npm install --omit=dev

# Source code last — invalidates on every commit, but npm install stays cached
COPY . .


# ─── STAGE 2: production ─────────────────────────────────────────────────────
FROM node:18-alpine AS production

WORKDIR /app

# Cross the stage boundary — only bring what the running process needs
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/src          ./src
COPY --from=builder /app/package.json ./package.json

# Drop root privileges before the process starts
USER node

EXPOSE 3000

CMD ["node", "src/index.js"]