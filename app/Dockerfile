
# Stage 1: Build and prepare the application
FROM node:22-alpine AS builder

WORKDIR /app

COPY package*.json ./
RUN npm install --omit=dev

COPY --chown=node:node . .


# Stage 2: Run the application
FROM node:22-alpine AS runtime

ENV NODE_ENV=production

WORKDIR /app

COPY --from=builder --chown=node:node /app /app

USER node

EXPOSE 3000

CMD ["node", "server.js"]
