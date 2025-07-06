# Etapa de build
FROM node:18-alpine AS builder

WORKDIR /app

COPY . .

# Instala dependências
RUN yarn install --frozen-lockfile

# Gera Prisma Client
RUN yarn prisma generate

# Builda apenas os apps necessários
RUN npx turbo run build --filter=@calcom/web... --filter=@calcom/api-v2...

# Etapa de produção
FROM node:18-alpine

WORKDIR /app

# Copia arquivos do build
COPY --from=builder /app .

# Expõe porta padrão do Next.js
EXPOSE 3000

# Ativa a API v2
ENV CAL_API_ENABLED=true

# Aplica migrations no start
CMD npx prisma migrate deploy && yarn start
