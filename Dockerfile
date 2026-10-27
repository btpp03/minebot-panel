FROM node:22-slim

WORKDIR /app
ENV NODE_ENV=production \
    PORT=4681 \
    SERVER_PORT=4681

COPY package.json package-lock.json ./
RUN npm install --omit=dev --no-audit --no-fund && npm cache clean --force

COPY index.js ./
COPY public ./public

EXPOSE 4681
CMD ["node", "index.js"]
