FROM debian:bookworm-slim

# Install SBCL and dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    sbcl \
    curl \
    ca-certificates \
    libssl3 \
    libpq5 \
    && rm -rf /var/lib/apt/lists/*

# Install Quicklisp
RUN curl -o /tmp/quicklisp.lisp https://beta.quicklisp.org/quicklisp.lisp \
    && sbcl --non-interactive \
         --load /tmp/quicklisp.lisp \
         --eval '(quicklisp-quickstart:install)' \
         --eval '(ql-util:without-prompting (ql:add-to-init-file))' \
    && rm /tmp/quicklisp.lisp

WORKDIR /app

# Copy project files
COPY concal.asd ./
COPY src/ ./src/
COPY static/ ./static/

# Download dependencies
RUN sbcl --non-interactive \
    --eval '(push #p"/app/" asdf:*central-registry*)' \
    --eval '(ql:quickload :concal)' \
    --eval '(quit)'

EXPOSE 8080

# Start the application
CMD ["sbcl", "--non-interactive", \
     "--eval", "(push #p\"/app/\" asdf:*central-registry*)", \
     "--eval", "(ql:quickload :concal)", \
     "--eval", "(concal:start)", \
     "--eval", "(loop (sleep 3600))"]
