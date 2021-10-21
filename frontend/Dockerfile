# Stage 1 - the build process
FROM node:14.15.4 as builder

ARG REACT_APP_BACKEND_SECRET_KEY
ENV REACT_APP_BACKEND_SECRET_KEY=$REACT_APP_BACKEND_SECRET_KEY
ARG REACT_APP_API_URL
ENV REACT_APP_API_URL=$REACT_APP_API_URL

WORKDIR /usr/src/app

COPY package.json yarn.lock ./
RUN yarn

COPY . ./
RUN yarn build

# Stage 2 - the production environment
FROM nginx:1.18-alpine

COPY --from=builder /usr/src/app/build /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
