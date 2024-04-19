# Modified version of the original at https://codeberg.org/VnPower/PixivFE/src/branch/v2/Dockerfile
FROM alpine:3.19
WORKDIR /app 

# Create a non-root user `pixivfe` for security purposes and set ownership
RUN addgroup -g 1000 -S pixivfe && \
    adduser -u 1000 -S pixivfe -G pixivfe && \
    chown -R pixivfe:pixivfe /app

# Copy the compiled binary and other necessary files
COPY ./PixivFE/pixivfe /app/pixivfe
COPY ./PixivFE/views /app/views
COPY ./PixivFE/docker/entrypoint.sh /entrypoint.sh

# Include entrypoint script and ensure it's executable
RUN chmod +x /entrypoint.sh && \
    chown pixivfe:pixivfe /entrypoint.sh

# Use the non-root user to run the application
USER pixivfe

EXPOSE 8282

ENTRYPOINT ["/entrypoint.sh"]

HEALTHCHECK --interval=30s --timeout=3s --start-period=15s --start-interval=5s --retries=3 \
 CMD wget --spider -q --tries=1 http://127.0.0.1:8282/about || exit 1