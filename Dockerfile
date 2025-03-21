FROM python:3.10  

WORKDIR /root  

RUN apt-get update && apt-get install -y sudo git curl build-essential libvips-dev  

RUN mkdir -p /root/.local /root/.cache/pip  
RUN chmod -R 777 /root  

ENV PATH="/root/bin:$PATH"  
ENV PYTHONUSERBASE=/root  
ENV PIP_CACHE_DIR=/root/.cache/pip  

RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash -  
RUN apt-get install -y nodejs  
RUN npm install -g npm@latest  

RUN rm -f /root/.npmrc  

RUN mkdir -p /app/home/.npm-global /app/home/.npm /app/home/.npm/.cache  
RUN chmod -R 777 /app/home/.npm-global /app/home/.npm /app/home/.npm/.cache  
RUN chown -R root:root /app/home/.npm-global /app/home/.npm /app/home/.npm/.cache  

RUN mkdir -p /.npm /.npm/.cache ./npm ./npm/.cache  
RUN chmod -R 777 /.npm /.npm/.cache ./npm ./npm/.cache  
RUN chown -R root:root /.npm /.npm/.cache ./npm ./npm/.cache  

RUN npm config set cache /app/home/.npm/.cache  
RUN npm config set prefix /app/home/.npm-global  
RUN npm config set globalconfig /app/home/.npmrc  
RUN npm config set userconfig /app/home/.npmrc  

ENV NPM_CONFIG_PREFIX="/app/home/.npm-global"  
ENV NPM_CONFIG_CACHE="/app/home/.npm/.cache"  

RUN mkdir -p /app/node_modules /app/home/node_modules  
RUN chmod -R 777 /app/node_modules /app/home/node_modules  
RUN chown -R root:root /app/node_modules /app/home/node_modules  

RUN mkdir -p /app && rm -rf /app/*  
RUN git clone https://github.com/ReirLair/reikerpy.git /app  

WORKDIR /app  

RUN pip install --upgrade pip  
RUN pip install --no-cache-dir --root-user-action=ignore -r requirements.txt  

RUN chmod -R 777 /app  

EXPOSE 7860  

CMD ["python", "server.py"] 
