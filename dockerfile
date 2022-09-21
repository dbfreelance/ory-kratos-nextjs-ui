FROM node:lts as dependencies
WORKDIR /testproject
COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile

FROM node:lts as builder
WORKDIR /testproject
COPY . .
COPY --from=dependencies /testproject/node_modules ./node_modules
RUN yarn build

FROM node:lts as runner
WORKDIR /testproject
ENV NODE_ENV production
# If you are using a custom next.config.js file, uncomment this line.
COPY --from=builder /testproject/next.config.js ./
COPY --from=builder /testproject/public ./public
COPY --from=builder /testproject/.next ./.next
COPY --from=builder /testproject/.eslintrc.json ./.eslintrc.json
COPY --from=builder /testproject/node_modules ./node_modules
COPY --from=builder /testproject/package.json ./package.json
COPY --from=builder /testproject/styles ./styles
COPY --from=builder /testproject/hooks ./hooks
COPY --from=builder /testproject/pages ./pages
COPY --from=builder /testproject/package-lock.json ./package-lock.json
COPY --from=builder /testproject/tsconfig.json ./tsconfig.json
COPY --from=builder /testproject/next-env.d.ts ./next-env.d.ts


EXPOSE 3000
CMD ["yarn", "start"]