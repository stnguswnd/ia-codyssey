FROM nginx:alpine
LABEL org.opencontainers.image.title="codyssey-week1-web"
LABEL org.opencontainers.image.description="Codyssey week1 custom nginx image"
ENV APP_ENV=dev
COPY app/ /usr/share/nginx/html/