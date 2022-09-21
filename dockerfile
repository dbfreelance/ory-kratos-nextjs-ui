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
COPY --from=builder . .


EXPOSE 3000
CMD ["yarn", "start"]