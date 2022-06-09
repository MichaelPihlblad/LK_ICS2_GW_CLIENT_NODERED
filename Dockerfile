FROM nodered/node-red
USER root
COPY package.json /data/package.json
COPY package-lock.json /data/package-lock.json
RUN npm install --unsafe-perm --no-update-notifier --no-fund --only=production /data
RUN rm /data/flows.json
RUN ln -s /LK_ICS2_GW_CLIENT_NODERED /usr/src/node-red/    # workingdir, so for relative file access in node-red nodes to work
RUN ln -s /LK_ICS2_GW_CLIENT_NODERED/settings.js /data/settings.js
RUN apk add py3-pip
RUN pip install pyserial pymodbus
USER node-red
ENV FLOWS=/LK_ICS2_GW_CLIENT_NODERED/flows.json
ENTRYPOINT ["sh", "-c", "python3 /LK_ICS2_GW_CLIENT_NODERED/ModbusRtuEmulator.py --updateconfig & npm --no-update-notifier --no-fund start --cache /data/.npm -- --userDir /data"]
EXPOSE 1880

