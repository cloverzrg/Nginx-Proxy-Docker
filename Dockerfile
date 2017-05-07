FROM ubuntu:latest
RUN apt-get update -qq && apt-get -y upgrade
RUN apt-get install wget gcc make libpcre3 libpcre3-dev git zlib1g.dev -y
RUN apt-get clean \
    # 用完包管理器后安排打扫卫生可以显著的减少镜像大小
    && apt-get autoclean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
WORKDIR /root
RUN git clone git://github.com/yaoweibin/ngx_http_substitutions_filter_module.git
RUN wget http://nginx.org/download/nginx-1.13.0.tar.gz
RUN tar zxvf nginx-1.13.0.tar.gz
WORKDIR nginx-1.13.0
RUN ./configure --with-http_stub_status_module --with-http_gzip_static_module --add-module=../ngx_http_substitutions_filter_module
RUN make
RUN make install
WORKDIR /
COPY run.sh /run.sh
COPY reverse-proxy.conf /usr/local/nginx/conf/reverse-proxy.conf
RUN rm -f /usr/local/nginx/conf/nginx.conf
COPY nginx.conf /usr/local/nginx/conf/nginx.conf
RUN chmod +x run.sh
CMD ["/run.sh"]
EXPOSE 80
VOLUME ["/usr/local/nginx/logs","/hnust-nginx-proxy-logs"]
