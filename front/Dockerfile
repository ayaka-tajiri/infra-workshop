FROM node:14.17.6-alpine AS build_stage
RUN apk update && apk add yarn
COPY app /usr/src/app
WORKDIR /usr/src/app
RUN yarn --frozen-lockfile
RUN yarn run build

FROM nginx:stable
COPY default.conf /etc/nginx/conf.d/default.conf
COPY --from=build_stage /usr/src/app/out/ /usr/share/nginx/html
EXPOSE 80
